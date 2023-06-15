import 'package:flutter/material.dart';

class appitemns extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final void Function()? click;

  const appitemns(
      {super.key,
      required this.icono,
      required this.titulo,
      required this.click});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icono,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              titulo,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 26,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
