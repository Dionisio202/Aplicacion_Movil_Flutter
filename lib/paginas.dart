import 'package:flutter/material.dart';

class paginas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black, // Fondo de pantalla negro
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Text(
                      "IMC",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Image.asset(
                    'Imagenes/altura.jpg',
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "¿Qué es IMC ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: 300,
                      child: Text(
                        "Es una medida utilizada para evaluar si una persona tiene un peso saludable en relación con su altura.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Image.asset(
                    'Imagenes/quees.png',
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "¿Porque es importante?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: 300,
                      child: Text(
                        "Tener un IMC dentro del rango saludable está asociado con un menor riesgo de desarrollar enfermedades crónicas, como diabetes tipo 2, enfermedades cardíacas, hipertensión arterial y ciertos tipos de cáncer. ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Alimentate saludablemente ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Image.asset(
                    'Imagenes/comidamenu.png',
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: 300,
                      child: Text(
                        "Es importante tener una buena dieta para tener un peso saludable",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
