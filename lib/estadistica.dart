import 'package:agilapp/alimentacion.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class estadistica extends StatefulWidget {
  @override
  _estadistica createState() => _estadistica();
}

class _estadistica extends State<estadistica> {
  Color _buttonColor = Colors.blue; // Color inicial del botón
  int _selectedIndex = 1;

  void _changeColor() {
    setState(() {
      // Cambia el color del botón al ser tocado
      _buttonColor = _buttonColor == Colors.blue ? Colors.red : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navega de vuelta al menú al presionar el botón de retroceso
        setState(() {
          _selectedIndex = 0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyappMenu()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Estadistica"),
        ),
        body: Container(
          // Coloca aquí el contenido de tu widget personalizado
          child: ElevatedButton(
            onPressed: _changeColor,
            style: ElevatedButton.styleFrom(
              backgroundColor: _buttonColor, // Color del botón
            ),
            child: Text('Cambiar Color'),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Acción al presionar el segundo botón
                  setState(() {
                    _selectedIndex = 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyappMenu()),
                    );
                  });
                },
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () {
                  // Acción al presionar el primer botón
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.food_bank_sharp),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Alimentacion()),
                  );
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
