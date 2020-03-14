import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: "Contador de Pessoas",
      home: Home()));
}






class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  int _p = 0;
  String _info = "Pode entrar!";

  void _atualizarPessoas(int delta){
    setState(() {
      _p += delta;

      if(_p < 0){
        _info = "Morreu alguem ai dentro?";

      }else if (_p <= 10){

        _info = "Pode entrar!";
      }else{
        _info = "ESTA LOTADO";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pessoas: $_p",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("+1",
                        style:
                        TextStyle(fontSize: 40.0, color: Colors.white)),
                    onPressed: () {_atualizarPessoas(1);},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("-1",
                        style:
                        TextStyle(fontSize: 40.0, color: Colors.white)),
                    onPressed: () {_atualizarPessoas(-1);},
                  ),
                ),
              ],
            ),
            Text(_info,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30.0))
          ],
        )
      ],
    );
  }
}
