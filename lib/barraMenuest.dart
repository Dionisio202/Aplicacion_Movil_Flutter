import 'barra.dart';
import 'estadistica.dart';

import 'package:flutter/material.dart';

import 'estaditica2.dart';

class menuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          estadisticaIMC(),
          Sidebar(),
        ],
      ),
    );
  }
}
