import 'package:flutter/material.dart';

import '../CategoryView.dart';



class homeTop extends StatelessWidget {

  final Animation<double> containerGrow;
  homeTop({@required this.containerGrow});


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height *0.4,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("images/login_background.jpg"),
        fit: BoxFit.cover)

      ),
      child: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Bem-vindo, Gabriel!", style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300,color: Colors.white)),
          Container(
            alignment: Alignment.topRight,
            width: containerGrow.value *120,
            height: containerGrow.value *120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,image: DecorationImage(image: AssetImage("images/smurf.jpg"),
            fit: BoxFit.cover)
            ),
            child: Container(
              width: containerGrow.value * 35,
              height: containerGrow.value * 35,

            ),
          ),
          CategoryView()
        ],

      )),
    );
  }
}
