import 'package:flutter/material.dart';

import 'barraMenu.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primaryColor: Colors.white),
      home: BarramenuWidget(),
    );
  }
}
