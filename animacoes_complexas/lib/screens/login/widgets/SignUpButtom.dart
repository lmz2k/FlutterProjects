import 'package:flutter/material.dart';



class SignUpButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(top: 160),
      onPressed: (){},
      child: Text("Não possui conta? cadastre-se!",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize: 12,letterSpacing: 0.5),),


    );
  }
}
