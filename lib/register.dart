import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'conexion.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _selectedHeight = 160; // Valor inicial de la estatura en cm
  int _selectedWeight = 50; // Valor inicial del peso en kg

  // Controladores de los campos de texto
  final TextEditingController correoc = TextEditingController();
  final TextEditingController nombrec = TextEditingController();
  final TextEditingController apellidoc = TextEditingController();
  final TextEditingController usuarioc = TextEditingController();
  final TextEditingController contraseniac = TextEditingController();
  final TextEditingController confirmarContraseniac = TextEditingController();
  String nombre1 = "";
  String nombre2 = "";
  String ape1 = "";
  String ape2 = "";

  bool validateFields() {
    return correoc.text.isNotEmpty &&
        nombrec.text.isNotEmpty &&
        apellidoc.text.isNotEmpty &&
        usuarioc.text.isNotEmpty &&
        contraseniac.text.isNotEmpty &&
        confirmarContraseniac.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyappLogin()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'Imagenes/lobo.png', // Ruta de la imagen
                width: 200, // Ancho de la imagen
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: correoc,
                        decoration: InputDecoration(
                          labelText: 'e-mail',
                          hintText: "Ingrese el e-mail",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: nombrec,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          hintText: "Ingrese los Nombres",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          List<String> nombreParts = text.split(" ");
                          setState(() {
                            if (nombreParts.length > 1) {
                              nombre1 = nombreParts[0];
                              nombre2 = nombreParts[1];
                            } else if (nombreParts.length == 1) {
                              nombre1 = nombreParts[0];
                              nombre2 = "";
                            } else {
                              nombre1 = "";
                              nombre2 = "";
                            }
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: apellidoc,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          hintText: "Ingrese los Apellidos",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          List<String> apeParts = text.split(" ");
                          setState(() {
                            if (apeParts.length > 1) {
                              ape1 = apeParts[0];
                              ape2 = apeParts[1];
                            } else if (apeParts.length == 1) {
                              ape1 = apeParts[0];
                              ape2 = "";
                            } else {
                              ape1 = "";
                              ape2 = "";
                            }
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: usuarioc,
                        decoration: InputDecoration(
                            labelText: 'Usuario',
                            hintText: "Ingrese el Usuario",
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: contraseniac,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: "Ingrese la Contraseña",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: confirmarContraseniac,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          hintText: "Confirmar Contraseña",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Estatura:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          NumberPicker(
                            value: _selectedHeight,
                            minValue: 0,
                            maxValue: 300,
                            onChanged: (value) {
                              setState(() {
                                _selectedHeight = value;
                              });
                            },
                            axis: Axis.horizontal,
                            itemHeight: 40,
                            itemWidth: 60,
                          ),
                          Text(
                            "cm",
                            style: TextStyle(
                              fontSize: 16,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          NumberPicker(
                            value: _selectedWeight,
                            minValue: 0,
                            maxValue: 200,
                            onChanged: (value) {
                              setState(() {
                                _selectedWeight = value;
                              });
                            },
                            axis: Axis.horizontal,
                            itemHeight: 40,
                            itemWidth: 60,
                          ),
                          Text(
                            "kg",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (validateFields()) {
                            String correo = correoc.text;

                            String usuario = usuarioc.text;
                            String contrasenia = contraseniac.text;
                            String confirmarContrasenia =
                                confirmarContraseniac.text;
                            int estatura = _selectedHeight;
                            int peso = _selectedWeight;

                            if (contrasenia == confirmarContrasenia) {
                              bool registroExitoso = await insertarRegistro(
                                correo,
                                usuario,
                                nombre1,
                                nombre2,
                                ape1,
                                ape2,
                                estatura,
                                peso,
                                contrasenia,
                              );

                              if (registroExitoso) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content:
                                          Text("Usuario creado con éxito."),
                                      actions: [
                                        TextButton(
                                          child: Text("Aceptar"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyappLogin()),
                                            );
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
                                      title: Text("Error"),
                                      content: Text(
                                          "Ocurrió un error al registrar el usuario."),
                                      actions: [
                                        TextButton(
                                          child: Text("Aceptar"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "La contraseña y la confirmación de contraseña no coinciden."),
                                    actions: [
                                      TextButton(
                                        child: Text("Aceptar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Campos vacíos"),
                                  content: Text(
                                      "Por favor, completa todos los campos."),
                                  actions: [
                                    TextButton(
                                      child: Text("Aceptar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('Registrarse'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
