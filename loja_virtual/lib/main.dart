import 'package:flutter/material.dart';
import 'package:loja_virtual/models/caat_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/home_screen.dart';
import 'package:loja_virtual/screen/login_screen.dart';
import 'package:loja_virtual/screen/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Flutter's Clothing",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 1, 1, 38)
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      )


    );
  }
}
