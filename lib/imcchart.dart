import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoIMC2 extends StatefulWidget {
  final Function() onDataUpdated;
  List<DataPoint> datas;

  GraficoIMC2({Key? key, required this.onDataUpdated, required this.datas})
      : super(key: key);

  @override
  State<GraficoIMC2> createState() => _GraficoIMC2State();
}

class _GraficoIMC2State extends State<GraficoIMC2> {
  void updateData() {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Center(
              child: SizedBox(
                height: 300.0,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: widget.datas.map((point) {
                          return FlSpot(
                            point.date.millisecondsSinceEpoch.toDouble(),
                            point.imc.toDouble(),
                          );
                        }).toList(),
                        isCurved: true,
                        colors: [
                          Color.fromARGB(255, 80, 135, 236),
                        ],
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          colors: [
                            Color(0xFF17203A).withOpacity(0.8),
                            Color(0xFF17203A).withOpacity(0.8),
                          ],
                          gradientColorStops: [0.0, 0.8],
                          gradientFrom: const Offset(0, 0),
                          gradientTo: const Offset(0, 1),
                        ),
                      ),
                    ],
                    minX: widget.datas.first.date.millisecondsSinceEpoch
                            .toDouble() -
                        (30 * 60 * 1000),
                    maxX: widget.datas.last.date.millisecondsSinceEpoch
                            .toDouble() +
                        (30 * 60 * 1000),
                    minY: 10,
                    maxY: widget.datas
                            .map((point) => point.imc)
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() +
                        10,
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        rotateAngle: 90,
                        getTextStyles: (value) => const TextStyle(
                          color: Color.fromRGBO(235, 231, 230, 1),
                          fontSize: 12,
                          fontFamily: 'lato',
                        ),
                        getTitles: (value) {
                          return '';
                        },
                        margin: 4,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                          color: Color.fromRGBO(240, 238, 238, 1),
                          fontSize: 6,
                          fontFamily: 'lato',
                        ),
                        getTitles: (value) {
                          // Aquí puedes formatear el valor del eje Y (IMC) como desees
                          // Por ejemplo, puedes redondearlo a un decimal.
                          return value.toStringAsFixed(0);
                        },
                        reservedSize: 12,
                        margin: 6,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color:
                              Color.fromARGB(255, 248, 248, 249).withOpacity(1),
                          strokeWidth: 0.2,
                        );
                      },
                    ),
                    backgroundColor: Color.fromARGB(0, 9, 9, 9).withOpacity(1),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Color.fromARGB(255, 245, 241, 241),
                        width: 1,
                      ),
                    ),
                    axisTitleData: FlAxisTitleData(
                      show: true,
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'IMC',
                        margin: 2,
                        textStyle: const TextStyle(
                          color: Color.fromRGBO(240, 238, 238, 1),
                          fontSize: 12,
                          fontFamily: 'lato',
                        ),
                      ),
                      bottomTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Fecha',
                        margin: 4,
                        textStyle: const TextStyle(
                          color: Color.fromRGBO(235, 231, 230, 1),
                          fontSize: 12,
                          fontFamily: 'lato',
                        ),
                      ),
                    ),
                    rangeAnnotations: RangeAnnotations(
                      verticalRangeAnnotations: [
                        VerticalRangeAnnotation(
                          x1: widget.datas.first.date.millisecondsSinceEpoch
                              .toDouble(),
                          x2: widget.datas.last.date.millisecondsSinceEpoch
                              .toDouble(),
                          color: Color.fromARGB(255, 42, 83, 79).withOpacity(1),
                        ),
                      ],
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor:
                            Color.fromARGB(255, 243, 243, 245).withOpacity(0.8),
                        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                          return lineBarsSpot.map((lineBarSpot) {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                    lineBarSpot.x.toInt(),
                                    isUtc: true)
                                .toLocal();

                            DateTime nextDay = date.add(Duration(days: 1));
                            double imc = lineBarSpot.y.toDouble();

                            return LineTooltipItem(
                              'IMC: $imc\nFecha: ${nextDay.day}/${date.month}/${date.year}',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final double imc;
  final DateTime date;

  DataPoint(this.imc, this.date);

  double getImc() {
    return imc;
  }

  DateTime getDate() {
    return date;
  }
}
