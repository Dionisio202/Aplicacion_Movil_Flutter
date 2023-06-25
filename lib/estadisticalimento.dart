import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'dart:math';

class estadisticaalimento extends StatefulWidget {
  @override
  _estadisticaState createState() => _estadisticaState();
}

class _estadisticaState extends State<estadisticaalimento> {
  static String? pointerAmount;
  static String? pointerAlimento;
  double visibleBars = 2; // Número inicial de barras visibles

  @override
  Widget build(BuildContext context) {
    final data = [
      Expenses('Manzana', 22.0),
      Expenses('Plátano', 21.5),
      Expenses('Naranja', 20.8),
      Expenses('Pera', 21.2),
      Expenses('Uva', 22.5),
      Expenses('Piña', 23.1),
      Expenses('Sandía', 20.5),
      Expenses('Melón', 22.8),
      Expenses('Fresa', 20.3),
      Expenses('Mango', 21.7),
      Expenses('Papaya', 22.3),
      Expenses('Coco', 19.8),
    ];
    List<charts.Series<Expenses, String>> series = [
      charts.Series<Expenses, String>(
        id: 'Lineal',
        domainFn: (v, i) => v.alimento,
        measureFn: (v, i) => v.imc,
        data: data,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Asegurar que el gráfico ocupe todo el ancho disponible
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
                        labelRotation:
                            45, // Rotación de las etiquetas en 45 grados
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 10,
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
        bounds.left - 25,
        bounds.top - 30,
        bounds.width + 48,
        bounds.height + 18,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2,
    );
    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
        elements.TextElement(
            'Alimento: ${_estadisticaState.pointerAlimento} \nIMC: ${_estadisticaState.pointerAmount}',
            style: myStyle),
        (bounds.left - 20).round(),
        (bounds.top - 26).round());
  }
}

class Expenses {
  final String alimento;
  final double imc;
  Expenses(this.alimento, this.imc);
}
