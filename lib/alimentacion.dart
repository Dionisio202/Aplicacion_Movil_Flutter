import 'package:flutter/material.dart';

class Alimentacion extends StatefulWidget {
  @override
  _AlimentacionState createState() => _AlimentacionState();
}

class _AlimentacionState extends State<Alimentacion> {
  Color _buttonColor = Colors.blue; // Color inicial del botón
  int _selectedIndex = 2;

  void _changeColor() {
    setState(() {
      // Cambia el color del botón al ser tocado
      _buttonColor = _buttonColor == Colors.blue ? Colors.red : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentación'),
      ),
      body: Center(
        child: Text(
          'Estamos trabajando en esto',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
