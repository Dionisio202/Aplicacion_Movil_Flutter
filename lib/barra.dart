import 'dart:async';

import 'package:agilapp/conexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barraMenu.dart';
import 'barraMenuest.dart';
import 'barramenuali.dart';

import 'login.dart';
import 'menuitemns.dart';

class Sidebar extends StatefulWidget {
  int paginaActual = 0;

  @override
  barra createState() => barra();
}

class barra extends State<Sidebar>
    with SingleTickerProviderStateMixin<Sidebar> {
  late AnimationController controladora;
  late StreamController<bool> barrabiertaStreamController;
  late Stream<bool> barrabiertaStream;
  late StreamSink<bool> barrabiertaSink;

  final animacion = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controladora = AnimationController(vsync: this, duration: animacion);
    barrabiertaStreamController = PublishSubject<bool>();
    barrabiertaStream = barrabiertaStreamController.stream;
    barrabiertaSink = barrabiertaStreamController.sink;
  }

  @override
  void dispose() {
    controladora.dispose();
    barrabiertaStreamController.close();
    barrabiertaSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = controladora.status;
    final bool animacionCompleta = animationStatus == AnimationStatus.completed;
    if (animacionCompleta) {
      barrabiertaSink.add(false);
      controladora.reverse();
    } else {
      barrabiertaSink.add(true);
      controladora.forward();
    }
  }

  void salir() async {
    bool loginn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', "");
    prefs.setBool('isLoggedIn', loginn);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyappLogin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pantalla = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: barrabiertaStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: animacion,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ?? false ? 0 : -pantalla,
          right: isSideBarOpenedAsync.data ?? false ? 0 : pantalla - 45,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: 900, // Ajusta la altura según tus necesidades
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Color(0xFF17203A),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            ListTile(
                              title: Text(
                                sql.nombreuser,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    sql.correouser,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                radius: 40,
                              ),
                            ),
                            Divider(
                              height: 64,
                              thickness: 0.5,
                              color: Colors.white,
                              indent: 32,
                              endIndent: 32,
                            ),
                            appitemns(
                              icono: Icons.home,
                              titulo: "Home",
                              click: () {
                                onIconPressed();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BarramenuWidget(),
                                  ),
                                );
                              },
                            ),
                            appitemns(
                              icono: MaterialCommunityIcons.food,
                              titulo: "Alimentación",
                              click: () {
                                onIconPressed();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => menuali(),
                                  ),
                                );
                              },
                            ),
                            appitemns(
                              icono: MaterialCommunityIcons.chart_bar,
                              titulo: "IMC",
                              click: () {
                                onIconPressed();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => menuest(),
                                  ),
                                );
                              },
                            ),
                            Divider(
                              height: 64,
                              thickness: 0.5,
                              color: Colors.white,
                              indent: 32,
                              endIndent: 32,
                            ),
                            appitemns(
                              icono: MaterialCommunityIcons.logout,
                              titulo: "Salir",
                              click: salir,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.9),
                      child: GestureDetector(
                        onTap: () {
                          onIconPressed();
                        },
                        child: ClipPath(
                          clipper: CustomMenuClipper(),
                          child: Container(
                            width: 35,
                            height: 110,
                            color: Color(0xFF17203A),
                            alignment: Alignment.centerLeft,
                            child: AnimatedIcon(
                              progress: controladora.view,
                              icon: AnimatedIcons.menu_close,
                              color: Color(0xFF1BB5FD),
                              size: 25,
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
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
