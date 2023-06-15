import 'barra.dart';

import 'package:agilapp/alimentacion.dart';
import 'package:flutter/material.dart';

class menuali extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Alimentacion(),
          Sidebar(),
        ],
      ),
    );
  }
}
