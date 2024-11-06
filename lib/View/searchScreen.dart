import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users_ambulance_app/AllWidgets/Divider.dart';
import 'package:users_ambulance_app/AllWidgets/progressDialog.dart';
import 'package:users_ambulance_app/Assistants/requestAssistant.dart';
import 'package:users_ambulance_app/Controller/appData.dart';
import 'package:users_ambulance_app/Models/address.dart';
import 'package:users_ambulance_app/Models/placePredictions.dart';
import 'package:users_ambulance_app/configMaps.dart';

class SearchScreen extends StatefulWidget
{
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}



class _SearchScreenState extends State<SearchScreen>
{
  TextEditingController pickUptextEditingController = TextEditingController();
  TextEditingController dropOfftextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionsList = [];


  @override
  Widget build(BuildContext context)
  {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation!.placeName ?? "";
    pickUptextEditingController.text = placeAddress;


    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top:28.0, right: 25.0, bottom: 2.0),
              child: Column(
                children: [
                  //SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                            Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 20.0, color: Colors.red[600], fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  //SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset("images/location_icon_home.png", height: 80.0, width: 50.0,),

                      SizedBox(width: 12.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              style: TextStyle(fontSize: 15,color: Colors.black),
                              controller: pickUptextEditingController,
                              decoration: InputDecoration(
                                hintText: "Pick Up Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 3.0),
                                ),

                                isDense:true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Image.asset("images/location_icon_2.png", height: 80.0, width: 50.0,),

                      SizedBox(width: 12.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              style: TextStyle(fontSize: 15,color: Colors.black),
                              controller: dropOfftextEditingController,
                              decoration: InputDecoration(
                                hintText: "Drop Off Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 3.0),
                                ),
                                isDense:true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

           //view the places granted from autocomplete in a list for the user to choose one from them
          //tile for predictions
          SizedBox(height: 8.0,),
          (placePredictionsList.length > 0)
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index)
              {
                return PredictionTile(placePredictions: placePredictionsList[index],);
              },
              separatorBuilder: (BuildContext context, int index) => DividerWidget(),
              itemCount: placePredictionsList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
              : Container(),
        ],
      ),
    );
  }

  //the autocomplete feature implementation
  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
        var autoCompleteUrl = Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:eg");

        var response = await RequestAssistant.getRequest(autoCompleteUrl);

        if(response == "failed")
        {
          return;
        }

        if(response["status"] == "OK")
        {
          var predictions = response["predictions"];

          var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
          setState(() {
            placePredictionsList = placesList;
          });

        }
    }
  }
}

//the autocomplete that works when starting to search for a spesific place
class PredictionTile extends StatelessWidget
{

  final PlacePredictions placePredictions;
  PredictionTile({Key? key, required this.placePredictions}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return TextButton(
      //padding: EdgeInsets.all(0.0),
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id!, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
             Row(
              children: [
                Icon(Icons.add_location,),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 8.0,),
                      Text(placePredictions.main_text!, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18.0),),
                      SizedBox(height: 3.0,),
                      Text(placePredictions.secondary_text!, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),),
                      //SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  //get the details(latitude,longitude) of a selected place from a list of places
  void getPlaceAddressDetails(String placeId, context) async
  {
    // showing a progress dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "   Setting DropOff, Please Wait...",),
    );

    //var placeDetailsUrl = Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&type=hospital&&key=$mapKey");
    //var response = await RequestAssistant.getRequest(placeDetailsUrl);

    var placeDetailsUrl = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey");
    var response = await RequestAssistant.getRequest(placeDetailsUrl);
    //print(response["result"]["name"]);
    Navigator.pop(context);   // stop the progress dialog from being displayed

    if(response == "failed")
    {
      return;
    }

    else if(response["status"] == "OK")
    {
      Address address = Address();
      address.placeName = response["result"]["name"];
      address.placeId = placeId;
      address.latitude = response["result"]["geometry"]["location"]["lat"];
      address.longitude = response["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("This Is Your Drop Off Location :: ");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }







  }
}

