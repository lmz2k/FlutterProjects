import 'package:animacoes_complexas/screens/login/LoginScreen.dart';
import 'package:animacoes_complexas/screens/login/home/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animations",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

