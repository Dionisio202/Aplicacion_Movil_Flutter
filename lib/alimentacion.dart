import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'addalimentos.dart';

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

  List<charts.Series<FoodData, DateTime>> createSeriesData() {
    return [
      charts.Series<FoodData, DateTime>(
        id: 'calorias',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (FoodData foodData, _) => foodData.fecha,
        measureFn: (FoodData foodData, _) => foodData.calorias,
        data: foodDataList,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: Color(0xFFBFBF3D),
                      width: 2.0,
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: charts.TimeSeriesChart(
                    createSeriesData(),
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    defaultRenderer:
                        charts.LineRendererConfig(includePoints: true),
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                      tickProviderSpec:
                          charts.BasicNumericTickProviderSpec(zeroBound: false),
                    ),
                    domainAxis: const charts.DateTimeAxisSpec(
                      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(format: 'dd/MM')),
                    ),
                    behaviors: [
                      charts.SeriesLegend(),
                    ],
                  ),
                ),
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
    );
  }
}

class FoodData {
  final DateTime fecha;
  final String nombre;
  final double calorias;

  FoodData(this.fecha, this.nombre, this.calorias);
}

final List<FoodData> foodDataList = [
  FoodData(DateTime(2023, 6, 1), 'Alimento 1', 100),
  FoodData(DateTime(2023, 6, 5), 'Alimento 2', 200),
  FoodData(DateTime(2023, 6, 10), 'Alimento 3', 150),
  FoodData(DateTime(2023, 6, 15), 'Alimento 4', 180),
  FoodData(DateTime(2023, 6, 20), 'Alimento 5', 220),
];
