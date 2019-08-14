import 'dart:async';
import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String _pesquisa;
  int _offset;

  Future<Map> _getGif() async {
    http.Response response;

    if (_pesquisa == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=aS8Lc75jJHuFZuW8ax8U9pa1zGILXKJY&limit=19&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=aS8Lc75jJHuFZuW8ax8U9pa1zGILXKJY&q=$_pesquisa&limit=25&offset=$_offset&rating=G&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _barraSuperior(),
      body: _corpoHome(),
      backgroundColor: Colors.black,
    );
  }

  Widget _barraSuperior() {
    return (AppBar(
      title: Image.network(
          "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
      backgroundColor: Colors.black,
      centerTitle: true,
    ));
  }

  Widget _corpoHome() {
    return (Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              labelText: "Pesquise Aqui!",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              setState(() {
                _pesquisa = text;
                _offset = 0;
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return (Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    ));
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _criarGifTable(context, snapshot);
                }
              }),
        )
      ],
    ));
  }

  int _getCount(List data) {
    if(_pesquisa == null || _pesquisa.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _criarGifTable(context, snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_pesquisa == null || _pesquisa.isEmpty || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }
      },
    );
  }
}
