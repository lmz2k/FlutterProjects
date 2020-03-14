import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final List<String> dias = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sabado",
    "Domingo"
  ];

  int _cont = 0;

  void selectForward(){
    setState(() {
      _cont++;
    });
  }
  void selectBackward(){
    setState(() {
      _cont--;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          disabledColor: Colors.white30,
          onPressed: _cont > 0 ? selectBackward : null,
        ),
        Text(
          dias[_cont],
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
              fontSize: 18),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: Colors.white,
          disabledColor: Colors.white30,
          onPressed: _cont < dias.length -1 ? selectForward : null,
        ),
      ],
    );
  }
}
