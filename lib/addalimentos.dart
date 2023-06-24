import 'package:flutter/material.dart';

import 'conexion.dart';

class Add extends StatefulWidget {
  @override
  _Addali createState() => _Addali();
}

class _Addali extends State<Add> {
  String? selectedType;
  String? selectedFood;
  late String ali;
  List<String> texts = [];
  List<String> alimento = [];

  void initializeData() {
    sql().obtenertipo().then((tipos) {
      setState(() {
        texts = tipos;
      });
    });
  }

  void initializeData2() {
    sql().obtenerAlimento(ali).then((tipos) {
      setState(() {
        alimento = tipos.toSet().toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir alimentos'),
        backgroundColor: Color(0xFF17203A),
      ),
      body: Container(
        color: Colors.black, // Fondo negro
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Seleccione sus alimentos',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tipos:',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  SizedBox(width: 49.0),
                  Container(
                    width: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: selectedType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedType = newValue;
                          selectedFood =
                              null; // Reiniciar el valor seleccionado de alimentos
                        });
                        ali = selectedType.toString();
                        initializeData2();
                      },
                      items: texts.map((text) {
                        return DropdownMenuItem<String>(
                          value: text,
                          child: Text(text),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Alimentos:',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: selectedFood,
                      onChanged: (newValue) {
                        setState(() {
                          selectedFood = newValue;
                        });
                        print(ali);
                      },
                      items: alimento.map((text) {
                        return DropdownMenuItem<String>(
                          value: text,
                          child: Text(text),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFFBFBF3D),
                  ), // Color de fondo del botón
                ),
                child: Text('Añadir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
