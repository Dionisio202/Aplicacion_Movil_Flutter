import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:core';
import 'package:intl/intl.dart';

import 'conexion.dart';

class addimc extends StatefulWidget {
  @override
  _Addali createState() => _Addali();
}

class _Addali extends State<addimc> {
  DateTime? _lastIMCDate;
  List<Widget> cards = [];
  int _selectedHeight = 160; // Valor inicial de la estatura en cm
  int _selectedWeight = 50; // Valor inicial del peso en kg
  bool isLoading = false;

  Card miCard(String fecha, int altura, int peso, double imc,
      DateTime fechaNacimiento) {
    // Formatea la cadena 'fecha' para mostrar solo la fecha sin la parte de la hora
    String formattedFecha =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(fecha));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text("   Índice de masa corporal"),
            subtitle: Text("\n" +
                "            Fecha: $formattedFecha \n " + // Utiliza la fecha formateada
                "\n Altura: $altura cm" +
                "           Peso: $peso kg" +
                "\n Edad: ${calculateAge(fechaNacimiento)} años" +
                "            IMC: $imc" +
                "\n"),
            leading: Icon(MaterialCommunityIcons.food),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[],
          )
        ],
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir IMC'),
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
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'Imagenes/ultimaf.png',
                    height: 230,
                    width: 300,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Seleccione su peso y masa corporal',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                FutureBuilder<Map<String, dynamic>>(
                  future: sql().obtenerIMC(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var datos = snapshot.data!['data'];

                      if (datos.isEmpty) {
                        return Text('No se encontraron datos');
                      } else {
                        _lastIMCDate = datos[0]['fecha'];
                        return miCard(
                          datos[0]['fecha'].toString(),
                          datos[0]['altura'],
                          datos[0]['peso'],
                          datos[0]['imc'],
                          datos[0]['fechaNacimiento'],
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Estatura:",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return NumberPicker(
                          value: _selectedHeight,
                          minValue: 10,
                          maxValue: 200,
                          onChanged: (value) {
                            setState(() {
                              _selectedHeight = value;
                            });
                          },
                          axis: Axis.horizontal,
                          itemHeight: 40,
                          itemWidth: 60,
                          textStyle: TextStyle(
                            color: Colors.white, // Números en blanco
                            fontSize: 16,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Colors.blue, // Número seleccionado en azul
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    Text(
                      "cm",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Peso:",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return NumberPicker(
                          value: _selectedWeight,
                          minValue: 3,
                          maxValue: 150,
                          onChanged: (value) {
                            setState(() {
                              _selectedWeight = value;
                            });
                          },
                          axis: Axis.horizontal,
                          itemHeight: 40,
                          itemWidth: 60,
                          textStyle: TextStyle(
                            color: Colors.white, // Números en blanco
                            fontSize: 16,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Colors.blue, // Número seleccionado en azul
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    Text(
                      "kg",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              // Validar si ya se registró un IMC hoy
                              DateTime currentDate = DateTime.now();
                              if (_lastIMCDate != null &&
                                  _lastIMCDate!.year == currentDate.year &&
                                  _lastIMCDate!.month == currentDate.month &&
                                  _lastIMCDate!.day == currentDate.day) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          'Ya no puedes ingresar más IMC hoy.'),
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
                                bool registroExitoso = await sql().insertarIMC(
                                  _selectedHeight,
                                  _selectedWeight,
                                );

                                if (registroExitoso) {
                                  // Actualizar la última fecha de IMC registrada

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                            'IMC añadido con éxito.'),
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
                                        content:
                                            const Text('Error de conexión.'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
