import 'package:buscador_gifs/ui/home_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

void main(){

  runApp(MaterialApp(
    home: homePage(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}