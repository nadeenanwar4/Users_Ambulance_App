import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_ambulance_app/Assistants/requestAssistant.dart';
import 'package:users_ambulance_app/Controller/appData.dart';
import 'package:users_ambulance_app/Models/address.dart';
import 'package:users_ambulance_app/Models/allUsers.dart';
import 'package:users_ambulance_app/Models/directionDetails.dart';
import 'package:users_ambulance_app/configMaps.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1,st2,st3,st4;
    var url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    //String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    // url as String
    var response = await RequestAssistant.getRequest(url);

    if(response != 'failed')
    {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][2]["long_name"];
      st3 = response["results"][0]["address_components"][4]["long_name"];
      st4 = response["results"][0]["address_components"][5]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);


    }


    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionsDetails(LatLng intialPosition, LatLng finalPosition) async
  {
    var directionUrl = Uri.parse("https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${intialPosition.latitude},${intialPosition.longitude}&key=$mapKey");

    var response = await RequestAssistant.getRequest(directionUrl);

    if(response == "failed")
    {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints = response["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = response["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;

  }

  static void getCurrentOnlineUserInfo() async
  {
    firebaseUser = (await FirebaseAuth.instance.currentUser)!;
    String userId = firebaseUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("users").child(userId);

    reference.once().then((event)
    {
      final dataSnapShot = event.snapshot;
      if(dataSnapShot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }

    });

  }
  static double createRandomNumber(int num)
  {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }


}