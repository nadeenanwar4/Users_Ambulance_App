import 'dart:convert';
import 'package:http/http.dart' as http;


class RequestAssistant
{
  // String url
  static Future<dynamic> getRequest(url) async
  {
    // url as Uri
    http.Response response = await http.get(url);

    try
    {
      if(response.statusCode == 200)
      {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      }
      else
      {
        return "failed.";
      }
    }
    catch(exp)
    {
      return "failed.";
    }
  }
}