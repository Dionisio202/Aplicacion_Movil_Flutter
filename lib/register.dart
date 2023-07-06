import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController contraseniac = TextEditingController();
  final TextEditingController confirmarContraseniac = TextEditingController();
  TextEditingController fechag = TextEditingController();
  String nombre1 = "";
  String nombre2 = "";
  String ape1 = "";
  String ape2 = "";
  DateTime? selectedDate;
  String fc = '';
  bool fecha = false;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked.toUtc();
      final DateTime currentDate = DateTime.now();

      final ageDuration = currentDate.difference(selectedDate!);
      final ageInYears = ageDuration.inDays ~/ 365;
      print(selectedDate);
      print(ageInYears);
      if (ageInYears >= 1) {
        setState(() {
          fecha = true;
          fechag.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
        });
      } else {
        fecha = false;
        fechag.text = "Fecha no valida";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error de fecha"),
              content: Text(
                  "Fecha no válida. Asegúrate de que sea tu fecha de nacimiento."),
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
      fecha = false;
    }
  }

//controlador fecha

  bool validateFields() {
    return correoc.text.trim().isNotEmpty &&
        nombrec.text.trim().isNotEmpty &&
        apellidoc.text.trim().isNotEmpty &&
        contraseniac.text.trim().isNotEmpty &&
        confirmarContraseniac.text.trim().isNotEmpty;
  }

  bool validarCorreo() {
    String email = correoc.text.trim();
    RegExp regex = RegExp(
        r'^[_A-Za-z0-9-\+]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$');

    if (regex.hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  bool isLoading = false;
  bool passwordMismatch = false;
  bool mostrarContrasenia = false;

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
        backgroundColor: Colors.black, // Color de fondo negro

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'Imagenes/registern.png', // Ruta de la imagen
                  width: 170, // Ancho de la imagen
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Crear perfil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Por favor crea tu perfil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.grey),
                      controller: correoc,
                      decoration: InputDecoration(
                        labelText: 'e-mail',
                        hintText: "Ingrese el e-mail",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Color(0xFFBFBF3D),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nombrec,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-ZñÑ\s]+$')),
                      ],
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        labelText: 'Nombres',
                        hintText: "Ingrese los Nombres",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Color(0xFFBFBF3D),
                        ),
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
                          }
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: apellidoc,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-ZñÑ\s]+$')),
                      ],
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        labelText: 'Apellidos',
                        hintText: "Ingrese los Apellidos",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Color(0xFFBFBF3D),
                        ),
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
                      controller: contraseniac,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^.{0,12}')),
                      ],
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: "Ingrese la Contraseña",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            mostrarContrasenia
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFBFBF3D),
                          ),
                          onPressed: () {
                            setState(() {
                              mostrarContrasenia = !mostrarContrasenia;
                            });
                          },
                        ),
                      ),
                      obscureText: !mostrarContrasenia,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: confirmarContraseniac,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^.{0,12}')),
                      ],
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        hintText: "Confirmar Contraseña",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFFBFBF3D),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (text) {
                        setState(() {
                          passwordMismatch = contraseniac.text != text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // aqui va a ir la fecha
                    TextFormField(
                      controller: fechag,
                      style: TextStyle(
                        color: Color(0xFFBFBF3D),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Fecha de nacimiento',
                        hintText: fc,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBFBF3D)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFFBFBF3D),
                        ),
                      ),
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
                        NumberPicker(
                          value: _selectedHeight,
                          minValue: 0,
                          maxValue: 230,
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
                        NumberPicker(
                          value: _selectedWeight,
                          minValue: 0,
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFBFBF3D), // Color de fondo del botón
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (validateFields()) {
                                setState(() {
                                  isLoading = true;
                                });

                                String correo = correoc.text.trim();
                                String contrasenia = contraseniac.text.trim();
                                String confirmarContrasenia =
                                    confirmarContraseniac.text.trim();
                                int estatura = _selectedHeight;
                                int peso = _selectedWeight;
                                if (fecha) {
                                  if (validarCorreo()) {
                                    if (contrasenia == confirmarContrasenia) {
                                      bool registroExitoso =
                                          await sql().insertarRegistro(
                                        correo,
                                        nombre1,
                                        nombre2,
                                        ape1,
                                        ape2,
                                        estatura,
                                        peso,
                                        contrasenia,
                                        selectedDate!, // aqui va la fecha
                                        context,
                                      );

                                      if (registroExitoso) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(""),
                                              content: Text(
                                                "Usuario creado con éxito.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Aceptar"),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyappLogin(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {}
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(""),
                                            content: Text(
                                              "Las contraseñas no coinciden. Por favor, inténtelo de nuevo.",
                                            ),
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
                                          title: Text(""),
                                          content: Text(
                                            "Correo electronico invalido",
                                          ),
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
                                        title: Text(""),
                                        content: Text(
                                          "Seleccione una fecha correcta ",
                                        ),
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
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content: Text(
                                        "Por favor, complete todos los campos.",
                                      ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Registrarse',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
