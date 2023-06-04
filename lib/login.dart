import 'package:agilapp/register.dart';
import 'package:flutter/material.dart';

import 'conexion.dart';
import 'menu.dart';

class MyappLogin extends StatefulWidget {
  @override
  _MyappLoginState createState() => _MyappLoginState();
}

class _MyappLoginState extends State<MyappLogin> {
  late String usuario;
  late String contrasenia;
  final TextEditingController nom_usu = TextEditingController();
  final TextEditingController contraseniac = TextEditingController();

  @override
  void dispose() {
    // Limpiar los controladores de texto al salir de la pantalla
    nom_usu.dispose();
    contraseniac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 90.0),
        children: <Widget>[
          Column(
            children: [
              CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('Imagenes/lobo.png'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: TextField(
                  controller: nom_usu,
                  enableInteractiveSelection: false,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el Usuario',
                    labelText: 'Usuario',
                    suffixIcon: Image.asset(
                      'Imagenes/usuario.png',
                      width: 24.0,
                      height: 24.0,
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
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: TextField(
                  controller: contraseniac,
                  enableInteractiveSelection: false,
                  autofocus: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Ingrese la contraseña',
                    labelText: 'Contraseña',
                    suffixIcon: Image.asset(
                      'Imagenes/contrasena.png',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  onSubmitted: (valor) {},
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String usuario = nom_usu.text;
                        String contrasena = contraseniac.text;
                        bool registroExitoso = await obtenerUsuarioYContrasenia(
                            contrasena, usuario);
                        if (registroExitoso) {
                          // Limpiar los controladores de texto
                          nom_usu.clear();
                          contraseniac.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyappMenu()));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Información incorrecta"),
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
                      child: Text('Login'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(21, 44, 158, 1), // Color verde oscuro
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Limpiar los controladores de texto
                        nom_usu.clear();
                        contraseniac.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text('Registrarse'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(21, 44, 158, 1), // Color verde oscuro
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
