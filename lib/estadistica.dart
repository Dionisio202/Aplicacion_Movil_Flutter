import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'dart:math';

class estadistica extends StatefulWidget {
  @override
  _estadisticaState createState() => _estadisticaState();
}

class _estadisticaState extends State<estadistica> {
  static String? pointerAmount;
  static String? pointerDay;

  @override
  Widget build(BuildContext context) {
    final data = [
      Expenses(DateTime(2023, 1, 1), 22.0),
      Expenses(DateTime(2023, 1, 2), 22.0),
    ];
    List<charts.Series<Expenses, DateTime>> series = [
      charts.Series<Expenses, DateTime>(
        id: 'Lineal',
        domainFn: (v, i) => v.date,
        measureFn: (v, i) => v.imc,
        data: data,
      ),
    ];

    return Center(
      child: SizedBox(
        height: 350.0,
        child: charts.TimeSeriesChart(
          series,
          selectionModels: [
            charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  pointerAmount = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      ?.toStringAsFixed(2);
                  pointerDay = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      ?.toString();
                }
              },
            ),
          ],
          behaviors: [
            charts.LinePointHighlighter(symbolRenderer: MySymbolRenderer()),
          ],
          domainAxis: charts.DateTimeAxisSpec(
            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: charts.TimeFormatterSpec(
                  format: 'MMM', transitionFormat: 'MMM'),
            ),
            tickProviderSpec: charts.StaticDateTimeTickProviderSpec([
              charts.TickSpec<DateTime>(DateTime(2023, 1, 2)),
              charts.TickSpec<DateTime>(DateTime(2023, 2, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 3, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 4, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 5, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 6, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 7, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 8, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 9, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 10, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 11, 1)),
              charts.TickSpec<DateTime>(DateTime(2023, 12, 1)),
            ]),
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
            'Fecha: ${_estadisticaState.pointerDay} \nIMC: ${_estadisticaState.pointerAmount}',
            style: myStyle),
        (bounds.left - 20).round(),
        (bounds.top - 26).round());
  }
}

class Expenses {
  final DateTime date;
  final double imc;
  Expenses(this.date, this.imc);
}
