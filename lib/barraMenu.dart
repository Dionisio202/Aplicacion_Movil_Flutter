import 'package:flutter/material.dart';

import 'barra.dart';
import 'paginas.dart';

class BarramenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          paginas(),
          Sidebar(),
        ],
      ),
    );
  }
}
