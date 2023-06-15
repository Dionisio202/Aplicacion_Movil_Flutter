import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false; // No hay conexión a Internet
  } else {
    return true; // Hay conexión a Internet
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection().then((isConnected) {
      if (isConnected) {
        Timer(Duration(seconds: 4), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyappLogin()),
          );
        });
      } else {
        // No hay conexión a Internet, muestra una advertencia
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Advertencia'),
              content: Text('No hay conexión a Internet.'),
              actions: [
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    exit(0);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('Imagenes/lobo.png'),
                  ),
                  SizedBox(height: 25.0),
                  Text(
                    'WolfCompany.Inc',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    height: 1.0,
                    width: 200,
                    color: Colors.white,
                  ),
                  SizedBox(height: 60.0),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 60.0, bottom: 16.0),
                      child: Text(
                        'Version  1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
