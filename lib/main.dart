import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Meu Armário Virtual',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: HomeGuardaRoupa(),
  ));
}