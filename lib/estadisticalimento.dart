import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'dart:math';

import 'conexion.dart';

class estadisticaalimento extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  estadisticaalimento({required this.startDate, required this.endDate});
  @override
  _estadisticaState createState() => _estadisticaState(startDate, endDate);
}

class _estadisticaState extends State<estadisticaalimento> {
  static String? pointerAmount;
  static String? pointerAlimento;

  double visibleBars = 2; // Número inicial de barras visibles

  List<Expenses> data = []; // Variable de estado para almacenar los datos
  DateTime startDate;
  DateTime endDate;

  _estadisticaState(this.startDate, this.endDate);
  @override
  void initState() {
    super.initState();
    obtenerDatos(); // Llama al método para obtener los datos al iniciar
  }

  Future<void> obtenerDatos() async {
    List<Expenses> result = await sql()
        .obtenerAlimentoCalorias(); // Obtiene los datos del método estático
    setState(() {
      data = result; // Actualiza la variable de estado con los datos obtenidos
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Expenses, String>> series = [
      charts.Series<Expenses, String>(
        id: 'Lineal',
        domainFn: (v, i) => v.nombreAlimento,
        measureFn: (v, i) => v.caloriasAlimento,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF3F95C2)),
      ),
    ];
    estadisticaalimento(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)));

    return Scaffold(
      body: Container(
        color: Colors.black, // Color de fondo negro
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 350.0,
                      child: charts.BarChart(
                        series,
                        selectionModels: [
                          charts.SelectionModelConfig(
                            changedListener: (charts.SelectionModel model) {
                              if (model.hasDatumSelection) {
                                pointerAmount = model.selectedSeries[0]
                                    .measureFn(model.selectedDatum[0].index)
                                    ?.toStringAsFixed(2);
                                pointerAlimento = model.selectedSeries[0]
                                    .domainFn(model.selectedDatum[0].index);
                              }
                            },
                          ),
                        ],
                        behaviors: [
                          charts.LinePointHighlighter(
                              symbolRenderer: MySymbolRenderer()),
                        ],
                        domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(
                            labelRotation: 45,
                            labelStyle: charts.TextStyleSpec(
                              fontSize: 10,
                              color: charts.MaterialPalette.white,
                            ),
                          ),
                        ),
                        primaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                              fontSize: 10,
                              color: charts.MaterialPalette.white,
                            ),
                            lineStyle: charts.LineStyleSpec(
                              color: charts.MaterialPalette.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MySymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
      Rectangle(
        bounds.left - 35,
        bounds.top - 20,
        bounds.width + 100,
        bounds.height + 25,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2,
    );
    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;
    myStyle.color =
        charts.MaterialPalette.white; // Color de la etiqueta en blanco

    canvas.drawText(
        elements.TextElement(
            'Alimento: ${_estadisticaState.pointerAlimento} \nCalorias: ${_estadisticaState.pointerAmount}',
            style: myStyle),
        (bounds.left - 30).round(),
        (bounds.top - 10).round());
  }
}

class Expenses {
  final String nombreAlimento;
  final double caloriasAlimento;

  Expenses(this.nombreAlimento, this.caloriasAlimento);
}
