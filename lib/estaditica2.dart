import 'package:flutter/material.dart';
import 'addimc.dart';
import 'cargaimc.dart';
import 'imcchart.dart';
import 'package:agilapp/conexion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addalimentos.dart';

import 'cargaralimento.dart';
import 'estadisticalimento.dart';

class estadisticaIMC extends StatefulWidget {
  @override
  _MyappEstaditica createState() => _MyappEstaditica();
}

DateTime? selectedDate;
DateTime? selectedDate2;
String fc = '';
bool fecha = false;
bool fecha2 = false;
TextEditingController fechag = TextEditingController();

TextEditingController fechag2 = TextEditingController();

class _MyappEstaditica extends State<estadisticaIMC> {
  List<DataPoint> datas = [];
  @override
  void initState() {
    super.initState();
    // Cargar los datos del método obtenerIMCgrafico al iniciar la pantalla
    cargarDatosIMC();
  }

  Future<void> cargarDatosIMC() async {
    DateTime startDate = selectedDate ?? DateTime.now();
    DateTime endDate = selectedDate2 ?? DateTime.now();

    // Llamar al método obtenerIMCgrafico
    List<DataPoint> datos = await sql().recuperarIMCfechas(startDate, endDate);

    setState(() {
      // Actualizar el estado con los datos obtenidos

      if (datos.isEmpty) {
        datas = [DataPoint(0, DateTime(2020, 1, 1))];
      } else {
        datas = datos;
      }
    });
  }

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
          fecha2 = true;
          fechag2.text = DateFormat('dd/MM/yyyy').format(selectedDate2!);
        });
      } else {
        fecha2 = false;
        fechag2.text = "Fecha no valida";
      }
    } else {
      fecha2 = false;
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
                  'Índice de masa corporal',
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
                  'Mostrar IMC ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (fecha && fecha2) {
                      if (selectedDate2!.isAfter(selectedDate!) ||
                          selectedDate == selectedDate2) {
                        sql.obtenerfecha(selectedDate!, selectedDate2!);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => cargaimc(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  const Text('Seleccione una fecha válida'),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text('Seleccione una fecha'),
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
                  },
                  child: Text('Mostrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFBFBF3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Añadir IMC',
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
                        builder: (context) => addimc(),
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
                Container(
                  height: 400,
                  width: 370,
                  child: (datas.isEmpty)
                      ? Center(
                          child: Text(
                            "Cargando..",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : GraficoIMC2(
                          onDataUpdated: () {},
                          datas: datas, // Pasar la lista 'datas' aquí
                        ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
