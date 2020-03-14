import 'dart:async';
import 'dart:convert';
import 'package:lol_profile_search/scr/player_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _riotKey = "RGAPI-0aec5688-7b05-4414-afb5-3dc93a03e814";
  String _summoner;
  String _iconID;

  Future<Map> _getSummoner(String nomeMeliante) async {


      http.Response response;
      response = await http.get(
          "https://br1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$nomeMeliante?api_key=$_riotKey");
      return json.decode(response.body);


  }

  Future<List> _getChallengerRankTEST() async {
    http.Response response;
    response = await http.get(
        "https://br1.api.riotgames.com/lol/league-exp/v4/entries/RANKED_SOLO_5x5/CHALLENGER/I?api_key=$_riotKey");
    return json.decode(response.body);
  }

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 41, 37, 0.9),
      appBar: _homeAppBar(),
      body: _homeSommunerBasicInfos(),


    );
  }

  Widget _homeAppBar() {
    return (AppBar(
      title: Image.asset("images/logo.png"),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
      centerTitle: true,
    ));
  }

  Widget _homeSommunerBasicInfos() {
    return Stack(
      children: <Widget>[
        Image.asset("images/back3.jpg",
          fit: BoxFit.cover,
          height: 1000.0, ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(214, 175, 84, 1.0), width: 2.0)),
                  labelText: "Summoner Name ",
                  labelStyle: TextStyle(color: Color.fromRGBO(214, 175, 84, 1.0)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),


                  ),
                ),
                style: TextStyle(
                  color: Color.fromRGBO(214, 175, 84, 1),
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
                onSubmitted: (text) {

                  if(text != null && text.isNotEmpty){

                    Map<String, dynamic> mapa = Map();
                    mapa["summonerName"] = text;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => playerPage(mapa)));

                  }


                },
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text("TOP 10 CHALLENGERS",
                    style: TextStyle(
                      color: Color.fromRGBO(214, 175, 84, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia Bold',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ]

                    ),
                    overflow: TextOverflow.ellipsis)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(), color: Color.fromRGBO(51, 51, 204, 0.1)),
                padding: EdgeInsets.all(15.0),
                child: FutureBuilder<List>(
                  //future: _getChallengerRank(),
                    future: _getChallengerRankTEST(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return (Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                                strokeWidth: 5.0,
                              )));
                        default:
                          if (snapshot.hasError) {
                            print("deu erro");
                            return Container();
                          } else {
                            print("deu certo");

                            return _top10ChallengerListREAL(context, snapshot);
                          }
                      }
                    }),
              ),
            ),
          ],
        )


      ],
    )
        ;
  }

  Widget _top10ChallengerListREAL(context, snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.all(1.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => playerPage(snapshot.data[index])));
            print("Apertei" + snapshot.data[index]["summonerName"].toString());
          },


          child: Container(
            padding: EdgeInsets.all(10.0),
            height: 75,
            color: Colors.white70,
            child: Row(
              children: <Widget>[
                Container(
                  child: FutureBuilder(
                      future: _getSummoner(
                          snapshot.data[index]["summonerName"].toString()),
                      builder: (context, snap) {
                        switch (snap.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return (Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 5.0,
                              ),
                            ));
                          default:
                            if (snap.hasError) {
                              print("n peguei icone");
                              return Container();
                            } else {
                              print(" peguei icone");

                              print(snap.data["profileIconId"].toString());
                              _iconID = snap.data["profileIconId"].toString();
                              return Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          image: new NetworkImage(
                                              "https://ddragon.leagueoflegends.com/cdn/9.15.1/img/profileicon/$_iconID.png"))));
                            }
                        }
                      }),
                ),
                Divider(
                  endIndent: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Text(
                        snapshot.data[index]["summonerName"],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(snapshot.data[index]["wins"].toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(0, 128, 43, 1.0),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            )),
                        Text("/",
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            )),
                        Text(snapshot.data[index]["losses"].toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            )),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          snapshot.data[index]["leaguePoints"].toString(),
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold))),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
