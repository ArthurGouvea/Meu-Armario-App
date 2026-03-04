import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Tira a faixa de debug
    title: 'Meu Armário Virtual',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: HomeGuardaRoupa(),
  ));
}