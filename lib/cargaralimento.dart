import 'package:flutter/material.dart';

import 'alimentacion.dart';
import 'barramenuali.dart';
import 'conexion.dart';

class Carga extends StatefulWidget {
  @override
  _CargaState createState() => _CargaState();
}

class _CargaState extends State<Carga> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: 1), // Duración de la animación del círculo de progreso
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _redirigir();
        sql().obtenerAlimentoCalorias();
      }
    });

    _animationController.forward();
  }

  void _redirigir() {
    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => menuali(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sus datos se estan cargando....',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 60),
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) {
                // Agregamos el signo de interrogación (?) para hacer que el argumento 'child' sea opcional
                return CircularProgressIndicator(
                  value: _animationController.value,
                  color: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
