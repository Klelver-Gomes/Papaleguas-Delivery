import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papaléguas Delivery',
      theme: ThemeData(
          primaryColor: Util.COR_DO_TEXTFIELD,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          iconTheme: IconThemeData(color: Util.COR_DO_ICONE)),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
