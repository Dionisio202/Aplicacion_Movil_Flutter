import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addalimentos.dart';

import 'estadisticalimento.dart';

class Alimentacion extends StatefulWidget {
  @override
  _AlimentacionState createState() => _AlimentacionState();
}

DateTime? selectedDate;
DateTime? selectedDate2;
String fc = '';
bool fecha = false;
TextEditingController fechag = TextEditingController();

TextEditingController fechag2 = TextEditingController();

class _AlimentacionState extends State<Alimentacion> {
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

      if (ageInYears >= 0) {
        setState(() {
          fecha = true;
          fechag.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
        });
      } else {
        fecha = false;
        fechag.text = "Fecha no valida";
      }
    } else {
      fecha = false;
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate2) {
      selectedDate2 = picked.toUtc();
      final DateTime currentDate = DateTime.now();

      final ageDuration = currentDate.difference(selectedDate2!);
      final ageInYears = ageDuration.inDays ~/ 365;

      if (ageInYears >= 0) {
        setState(() {
          fecha = true;
          fechag2.text = DateFormat('dd/MM/yyyy').format(selectedDate2!);
        });
      } else {
        fecha = false;
        fechag2.text = "Fecha no valida";
      }
    } else {
      fecha = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Alinea los elementos en la parte superior
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Centra horizontalmente los elementos

              children: [
                SizedBox(height: 30),
                Text(
                  'Alimentación',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Fecha inicial",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: TextFormField(
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
                      labelText: '',
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
                ),
                SizedBox(height: 20),
                Text(
                  "Fecha final",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: TextFormField(
                    controller: fechag2,
                    style: TextStyle(
                      color: Color(0xFFBFBF3D),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate2(context);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: '',
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
                ),
                SizedBox(height: 20),
                Text(
                  'Añadir alimentación',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Add(),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            Color(0xFFBFBF3D), // Establece el color del borde
                        width: 2.0, // Establece el ancho del borde
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFBFBF3D),
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 400, // Establece la altura deseada para el gráfico
                  width: 370,
                  child:
                      estadisticaalimento(), // Crea una instancia de la clase "estadistica" y colócala dentro del contenedor
                ),
                SizedBox(height: 20),
                Image.asset(
                  'Imagenes/comida.png',
                  height: 160,
                  width: 160,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
