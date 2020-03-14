import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;

const String API_KEY = "AIzaSyAt0kXByfY66bHrEiSi9hO76RafW0SEvM8";

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"

class Api{


  String _search;
  String _nextToken;




   search(String search) async {


     this._search = search;


    http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");

    return decode(response);

  }

   nextPage() async {


     http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");

     return decode(response);

   }






  List<Video> decode(http.Response response){

     if (response.statusCode == 200){

       var decoded = json.decode(response.body);

       this._nextToken = decoded["nextPageToken"];

       List<Video> videos = decoded["items"].map<Video>((map){

         return Video.fromJson(map);


       }).toList();


       return videos;


     }else{


       throw Exception("Failed to load Videos");


     }


  }


}