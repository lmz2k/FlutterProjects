import 'package:flutter/material.dart';


class Input extends StatelessWidget {


  final stringHint;
  final bool obscure;
  final IconData icon;


  Input({this.stringHint, this.obscure, this.icon});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(

              color: Colors.white,
              width: 0.5
          ))
      ),
      child: TextFormField(
        obscureText: obscure,
        style: TextStyle(
          color: Colors.white,
        ),


        decoration: InputDecoration(icon: Icon(icon, color: Colors.white,),
            border: InputBorder.none,
            hintText: stringHint,
            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
            contentPadding: EdgeInsets.only(top: 30, right: 30, bottom: 30,
                left: 5)),
      ),
    );
  }
}
