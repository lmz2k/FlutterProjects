import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _iconID;
String _riotKey = "RGAPI-0aec5688-7b05-4414-afb5-3dc93a03e814";
String _leagueID;
String lvlSum;
int IndX = 0;

Future<Map> _getSummoner(String nomeMeliante) async {
  http.Response response;
  response = await http.get(
      "https://br1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$nomeMeliante?api_key=$_riotKey");
  return json.decode(response.body);
}

Future<List> _getSummonerRank(_summonerID) async {
  http.Response response;
  response = await http.get(
      "https://br1.api.riotgames.com/lol/league/v4/entries/by-summoner/$_summonerID?api_key=$_riotKey");
  return jsonDecode(response.body);
}

Future<Map> _getSummonerChampions(_summonerID) async {
  http.Response response;
  response = await http.get(
      "https://br1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/$_summonerID?api_key=$_riotKey");
  return json.decode(response.body);
}


class playerPage extends StatelessWidget {
  final Map _playerData;

  playerPage(this._playerData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_playerData["summonerName"]),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
      ),
      body: _corpoPlayer(_playerData),
      backgroundColor: Colors.black,
    );
  }
}

Widget _corpoPlayer(_playerData) {
  return Stack(
    children: <Widget>[
      Image.asset(
        "images/back2.jpg",
        fit: BoxFit.cover,
        height: 1000.0,
      ),
      Column(children: <Widget>[
        FutureBuilder(
            future: _getSummoner(_playerData["summonerName"].toString()),
            builder: (context, snap) {
              switch (snap.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return (Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  ));
                default:
                  if (snap.hasError) {
                    print("n peguei icone");
                    return Container();
                  } else {
                    _iconID = snap.data["profileIconId"].toString();
                    lvlSum = snap.data["summonerLevel"].toString();
                    print("lvl = " + lvlSum);
                    return Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 30),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: new BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.amber,
                                      blurRadius: 5.0,
                                      spreadRadius: 10.0)
                                ],
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    image: new NetworkImage(
                                        "https://ddragon.leagueoflegends.com/cdn/9.15.1/img/profileicon/$_iconID.png")),
                                color: Colors.amber)),
                      ),
                    );
                  }
              }
            }),
        Align(
          alignment: Alignment.center,
          child: FutureBuilder(
              future: _getSummoner(_playerData["summonerName"].toString()),
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return (Container());
                  default:
                    if (snap.hasError) {
                      return Container();
                    } else {
                      lvlSum = snap.data["summonerLevel"].toString();
                      print("lvl = " + lvlSum);
                      return Column(
                        children: <Widget>[
                          Text(
                            _playerData["summonerName"].toString(),
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ]),
                          ),
                          Text(
                            "Brazil Server - Level $lvlSum",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }
                }
              }),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder(
                future: _getSummoner(_playerData["summonerName"].toString()),
                builder: (context, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return (Container());
                    default:
                      if (snap.hasError) {
                        return Container();
                      } else {
                        return Container(
                            child: FutureBuilder<List>(
                                future: _getSummonerRank(
                                    snap.data["id"].toString()),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.none:
                                      return (Container());
                                    default:
                                      if (snapshot.hasError) {
                                        return Container();
                                      } else {


                                        for (var i = 0; i < 3; i++) {
                                          if (snapshot.data[i]["queueType"] == "RANKED_SOLO_5x5"){
                                            IndX = i;
                                            break;
                                          }


                                        }
                                        print("INDEX: $IndX") ;
                                        String linkRank = (snapshot.data[IndX]
                                                ["tier"] +
                                            "_" +
                                            snapshot.data[IndX]["rank"]);

                                        print(linkRank);
                                        return Container(
                                            color: Color.fromRGBO(0, 51, 51, 1),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Image.network(
                                                        "https://lolprofile.net/web/img/badges/$linkRank.png"),
                                                  ),
                                                  Divider(
                                                    endIndent: 50,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "Ranked Solo",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          snapshot.data[IndX]
                                                                  ["tier"] +
                                                              " " +
                                                              snapshot.data[IndX]
                                                                  ["rank"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          snapshot.data[IndX][
                                                                  "leaguePoints"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      }
                                  }
                                }));
                      }
                  }
                }),
          ),
        )
      ])
    ],
  );
}
