import 'package:flutter/material.dart';
import 'alimentacion.dart';
import 'estadistica.dart';
import 'login.dart';

class MyappMenu extends StatefulWidget {
  @override
  _MyappMenuState createState() => _MyappMenuState();
}

class _MyappMenuState extends State<MyappMenu> {
  int _selectedIndex = 0;

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyappLogin()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Menu"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Alimentacion()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Imagenes/comida.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                      SizedBox(
                        height: 10.0,
                        width: 300.0,
                      ),
                      Text(
                        'Alimentación',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => estadistica()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Imagenes/estadistica.jpeg',
                        width: 150.0,
                        height: 100.0,
                      ),
                      SizedBox(
                        height: 10.0,
                        width: 300.0,
                      ),
                      Text(
                        'ICM',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Acción al presionar el segundo botón
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => estadistica()),
                  );
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.food_bank_sharp),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Alimentacion()),
                  );
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
