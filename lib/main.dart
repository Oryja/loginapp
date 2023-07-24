import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(primarySwatch: Colors.red),
    );
  }
}