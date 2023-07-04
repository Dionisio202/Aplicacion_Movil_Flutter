import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'conexion.dart';

class Add extends StatefulWidget {
  @override
  _Addali createState() => _Addali();
}

class _Addali extends State<Add> {
  List<Widget> cards = [];
  String? selectedType;
  String? selectedFood;
  late String ali;
  String? caloria;
  List<String> texts = [];
  List<String> alimento = [];
  bool isLoading = false;
  void initializeData() {
    sql().obtenertipo().then((tipos) {
      setState(() {
        texts = tipos;
      });
    });
  }

  Card miCard() {
    if (selectedFood == null || caloria == null) {
      return Card(); // Otra alternativa si selectedFood es nulo o está vacía
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text(selectedType!),
            subtitle: Text("Nombre del alimento: " +
                selectedFood! +
                "\n Calorias: " +
                caloria!),
            leading: Icon(MaterialCommunityIcons.food),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        bool registroExitoso = await sql().insertarAlimento(
                            selectedFood.toString()); // Corrección aquí

                        if (registroExitoso) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    const Text('Alimento añadido con exito.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'Por favor selecciona un alimento '),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Añadir',
                        style: TextStyle(color: Color(0xFF222222)),
                      ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFBFBF3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void initializeData2() {
    sql().obtenerAlimento(ali).then((tipos) {
      setState(() {
        alimento = tipos.toSet().toList();
      });
    });
  }

  void obtenerCaloria() {
    if (selectedFood != null) {
      sql().obtenerCal(selectedFood!).then((cal) {
        setState(() {
          caloria = cal;
        });
      });
    }
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
      body: SafeArea(
        child: Container(
          height: 1100,
          color: Colors.black, // Fondo negro
          child: SingleChildScrollView(
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
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'Imagenes/comida.png',
                    height: 160,
                    width: 160,
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
                            obtenerCaloria();
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
                miCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
