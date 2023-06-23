import 'dart:io';

import 'package:agilapp/register.dart';
import 'package:flutter/material.dart';
import 'package:agilapp/conexion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

import 'manu2.dart';

class MyappLogin extends StatefulWidget {
  @override
  _MyappLoginState createState() => _MyappLoginState();
}

class _MyappLoginState extends State<MyappLogin> {
  late String usuario;
  late String contrasenia;
  final TextEditingController nom_usu = TextEditingController();
  final TextEditingController contraseniac = TextEditingController();
  bool mostrarContrasena = false;
  bool isLoading = false;

  @override
  void dispose() {
    nom_usu.dispose();
    contraseniac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Align(
                    alignment: Alignment(5.0, 0.0),
                    child: Image.asset('Imagenes/login.png'),
                  ),
                ),
                SizedBox(height: 20.0),
                const Text(
                  '¡Bienvenido de nuevo! ',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                const Text(
                  'Por favor ingrese su cuenta',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: TextField(
                    controller: nom_usu,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: 'Ingrese el Correo Electrónico',
                      labelText: 'Correo Electrónico',
                      labelStyle: TextStyle(color: Color(0xFFBFBF3D)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 30.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFBFBF3D),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFBFBF3D),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: Icon(
                        Icons.email,
                        color: Color(0xFFBFBF3D),
                      ),
                    ),
                    onSubmitted: (valor) {
                      usuario = valor;
                      print(usuario);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: TextField(
                    controller: contraseniac,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^.{0,12}')),
                    ],
                    style: TextStyle(color: Colors.grey),
                    obscureText: !mostrarContrasena,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Ingrese la contraseña',
                      labelStyle: TextStyle(
                        color: Color(0xFFBFBF3D),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFBFBF3D),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFBFBF3D),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          mostrarContrasena
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFBFBF3D),
                        ),
                        onPressed: () {
                          setState(() {
                            mostrarContrasena = !mostrarContrasena;
                          });
                        },
                      ),
                    ),
                    onSubmitted: (valor) {},
                  ),
                ),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    SizedBox(
                      width: 250, // Ancho del SizedBox
                      height: 34, // Alto del SizedBox
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });

                                String usuario = nom_usu.text.trim();
                                String contrasena = contraseniac.text.trim();
                                bool registroExitoso =
                                    await sql().obtenerUsuarioYContrasenia(
                                  contrasena,
                                  usuario,
                                  context,
                                );

                                if (registroExitoso) {
                                  bool loginn = true;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('email', usuario);
                                  prefs.setBool('isLoggedIn', loginn);
                                  nom_usu.clear();
                                  contraseniac.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp2(),
                                    ),
                                  );
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text('Iniciar sesión'),
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color(0xFFBFBF3D), // Color de fondo del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25), // Radio de borde para hacerlo redondo
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Aún no eres miembro?',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              nom_usu.clear();
                              contraseniac.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
