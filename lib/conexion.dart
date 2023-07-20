import 'package:agilapp/alimentacion.dart';
import 'package:agilapp/estadisticalimento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'imcchart.dart';

class sql {
  static DateTime startDate = DateTime.now().toUtc();
  static DateTime endDate = DateTime.now().toUtc();
  static String nombreuser = '';
  static String correouser = '';
  static List<DateTime> miArrayGlobal = [];
  sql();
  sql.obtenerfecha(DateTime fechaIni, DateTime fechaFin) {
    miArrayGlobal.add(fechaIni);
    miArrayGlobal.add(fechaFin);
    startDate = fechaIni.toUtc();
    endDate = fechaFin.toUtc();
  }

  final settings = ConnectionSettings(
    host: 'us-cdbr-east-06.cleardb.net',
    port: 3306,
    user: 'bd8c1b8b12fdce',
    password: '51880e76',
    db: 'heroku_47ae01e4a394ac8',
  );

  Future<bool> insertarRegistro(
      String correo,
      String nombres,
      String nombres2,
      String apellidos,
      String apellidos2,
      int estatura,
      int peso,
      String contrasenia,
      DateTime fecha,
      BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      final conn = await MySqlConnection.connect(settings);
      DateTime now = DateTime.now().subtract(Duration(hours: 5));
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      double alturaMetros = estatura / 100;
      double imc = peso / (alturaMetros * alturaMetros);
      print('Conexión exitosa');

      final result = await conn.query(
          'INSERT INTO USUARIOS (COR_ELE, NOM_PER, NOM2_PER, APE_PER, APE2_PER, EST_PER, PES_PER, CON_USU , FEC_NAC) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)',
          [
            correo,
            nombres,
            nombres2,
            apellidos,
            apellidos2,
            estatura,
            peso,
            contrasenia,
            fecha
          ]);
      final result2 = await conn
          .query('INSERT INTO IMC (COR_ELE ,FECHA,IMC) VALUES (?, ?, ?)', [
        correo,
        formattedDate,
        double.parse(imc.toStringAsFixed(1)),
      ]);
      int n = result.affectedRows!.toInt();
      if (n > 0) {
        await conn.close();
        return true;
      } else {
        await conn.close();
        return false;
      }
    } catch (e) {
      if (e is MySqlException && e.errorNumber == 1062) {
        // Clave primaria duplicada
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error al crear el usuario '),
              content: Text('El usuario ya existe '),
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
      } else {
        // Otras excepciones
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de conexión'),
              content: Text(
                'Hubo un problema al conectarse a la base de datos. Por favor, inténtalo de nuevo más tarde. \n $e',
              ),
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
      return false;
    }
  }

  Future<bool> obtenerUsuarioYContrasenia(
      String contrasenia, String corEle, BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
        'SELECT COR_ELE, CON_USU ,NOM_PER FROM USUARIOS WHERE CON_USU = ? AND COR_ELE = ?',
        [contrasenia, corEle],
      );

      if (result.isNotEmpty) {
        for (var row in result) {
          var correoElectronico = row['COR_ELE'];
          var contraseniaUser = row['CON_USU'];
          nombreuser = row['NOM_PER'];
          correouser = correoElectronico;
          if (contrasenia == contraseniaUser && corEle == correoElectronico) {
            correouser = correoElectronico;
            await conn.close();
            return true;
          }
        }

        await conn.close();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Advertencia'),
              content: Text(
                  'Credenciales incorrectas. Por favor, inténtalo de nuevo.'),
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
        return false;
      } else {
        await conn.close();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Advertencia'),
              content: Text(
                  'Credenciales incorrectas. Por favor, inténtalo de nuevo.'),
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
        return false;
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de conexión'),
            content: const Text(
                'Hubo un problema al conectarse a la base de datos. Por favor, inténtalo de nuevo más tarde.'),
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
      return false;
    }
  }

  late SharedPreferences prefs;
  late String email = '';
  late String contrasenna = '';
  late bool isLoggedIn = false;
  Future<bool> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      email = prefs.getString('email') ?? '';
      contrasenna = prefs.getString('contraseña') ?? '';
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    } else {
      email = ''; // Valor predeterminado
      isLoggedIn = false; // Valor predeterminado
      contrasenna = '';
    }
    return isLoggedIn;
  }

  Future<bool> obtenerInfo() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializePreferences();

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
        'SELECT COR_ELE, CON_USU ,NOM_PER FROM USUARIOS WHERE CON_USU = ? AND COR_ELE = ?',
        [contrasenna, email],
      );

      if (result.isNotEmpty) {
        for (var row in result) {
          var correoElectronico = row['COR_ELE'];
          var contraseniaUser = row['CON_USU'];
          nombreuser = row['NOM_PER'];
          correouser = correoElectronico;
          if (contrasenna == contraseniaUser && email == correoElectronico) {
            correouser = correoElectronico;
            await conn.close();
            return true;
          }
        }

        await conn.close();

        return false;
      } else {
        await conn.close();

        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> obtenertipo() async {
    List<String> listaAlimentos = [];

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query('SELECT NOM_TIP  FROM TIPO_ALIMENTO');

      if (result.isNotEmpty) {
        for (var row in result) {
          var nombreAlimento = row['NOM_TIP'] as String;
          listaAlimentos.add(nombreAlimento);
        }
        await conn.close();
      }

      await conn.close();
    } catch (e) {
      print("Error tipo  $e");
    }

    return listaAlimentos;
  }

  Future<List<String>> obtenerAlimento(String tipo) async {
    List<String> listaAlimentos = [];

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
          'SELECT NOM_ALI FROM ALIMENTOS WHERE TIP_ALI = (SELECT ID_TIP FROM TIPO_ALIMENTO WHERE NOM_TIP = ?)',
          [tipo]);

      if (result.isNotEmpty) {
        for (var row in result) {
          var nombreAlimento = row['NOM_ALI'] as String;
          listaAlimentos.add(nombreAlimento);
        }
        await conn.close();
      }

      await conn.close();
    } catch (e) {
      print("Error obeteneraliemnto  $e");
    }

    return listaAlimentos;
  }

  Future<List<String>> obtenerContenedorAlimento(String contenedor) async {
    List<String> listaAlimentos = [];

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
          'SELECT CON_ALI FROM ALIMENTOS WHERE NOM_ALI = ?', [contenedor]);

      if (result.isNotEmpty) {
        for (var row in result) {
          var nombreAlimento = row['CON_ALI'] as String;
          listaAlimentos.add(nombreAlimento);
        }
        await conn.close();
      }

      await conn.close();
    } catch (e) {
      print("Error contenedor alimento $e");
    }

    return listaAlimentos;
  }

  Future<bool> insertarAlimento(String alimento) async {
    initializePreferences();

    try {
      final conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        'SELECT ID_ALI FROM ALIMENTOS WHERE  NOM_ALI = ?',
        [alimento],
      );
      DateTime now = DateTime.now().subtract(Duration(hours: 0));
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      if (result.isNotEmpty) {
        for (var row in result) {
          var id = row['ID_ALI'] as int;

          await conn.query(
            'INSERT INTO DETALLE_ALIMENTOS (COR_ELE, ID_ALI, FEC_ALI) VALUES (?, ?, ?)',
            [
              email,
              id,
              formattedDate,
            ],
          );
        }
        return true;
      }
      await conn.close();
      return false;
    } catch (e) {
      print('Error al insertar alimento: $e');
      print("Error de correo vacío");
      print(email);
      return false;
    }
  }

  Future<List<Expenses>> obtenerAlimentoCalorias() async {
    initializePreferences();
    List<Expenses> data = [];
    print(startDate);
    print(endDate);
    try {
      var formattedDate = DateFormat('yyyy-MM-dd')
          .format(startDate.subtract(Duration(hours: 5)));
      var formattedDate2 =
          DateFormat('yyyy-MM-dd').format(endDate.subtract(Duration(hours: 5)));
      final conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
          'SELECT A.NOM_ALI, SUM(A.CAL_ALI) AS SUMA_CALORIAS '
          'FROM ALIMENTOS A '
          'JOIN DETALLE_ALIMENTOS DA ON A.ID_ALI = DA.ID_ALI '
          'JOIN USUARIOS U ON DA.COR_ELE = U.COR_ELE '
          'WHERE U.COR_ELE = ? AND DA.FEC_ALI BETWEEN ? AND ? '
          'GROUP BY A.NOM_ALI',
          [email, formattedDate, formattedDate2]);

      if (result.isNotEmpty) {
        for (var row in result) {
          var nombreAlimento = row['NOM_ALI'];

          var caloriasAlimento =
              double.tryParse(row['SUMA_CALORIAS'].toString()) ?? 0.0;

          data.add(Expenses(nombreAlimento, caloriasAlimento));
        }
      }

      await conn.close(); // Cerrar la conexión aquí
    } catch (e) {
      print("No conectado $e");
    }

    return data;
  }

  Future<String> obtenerCal(String ALI) async {
    String nom = '';

    try {
      final conn = await MySqlConnection.connect(settings);
      var result = await conn
          .query('SELECT CAL_ALI FROM ALIMENTOS WHERE NOM_ALI=?', [ALI]);

      if (result.isNotEmpty) {
        for (var row in result) {
          var nombreAlimento = row['CAL_ALI'] as int;
          nom = nombreAlimento.toString();
        }
      }

      await conn.close();
    } catch (e) {
      print("$e");
    }

    return nom;
  }

  Future<bool> insertarIMC(
    int estatura,
    int peso,
  ) async {
    initializePreferences();

    try {
      final conn = await MySqlConnection.connect(settings);

      DateTime now = DateTime.now().subtract(Duration(hours: 5));
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      double alturaMetros = estatura / 100;
      double imc = peso / (alturaMetros * alturaMetros);
      imc = (peso / (alturaMetros * alturaMetros)).truncateToDouble();

      await conn.query(
        'INSERT INTO IMC (COR_ELE,FECHA, IMC,ALTURA,PESO) VALUES (?, ?, ?,?,?)',
        [
          email,
          formattedDate,
          imc,
          estatura,
          peso,
        ],
      );

      await conn.close();
      return true; // Devuelve 'true' si la inserción fue exitosa
    } catch (e) {
      print('Error al insertar alimento: $e');
      print("Error de correo vacío");
      print(email); // Asegúrate de tener esta variable definida
      return false;
    }
  }

  Future<Map<String, dynamic>> obtenerIMC() async {
    List<Map<String, dynamic>> resultList = [];
    initializePreferences();

    try {
      final conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        'SELECT i.FECHA, i.ALTURA, i.PESO, i.IMC, u.FEC_NAC ' +
            'FROM IMC i INNER JOIN USUARIOS u ON i.COR_ELE = u.COR_ELE ' +
            'WHERE i.COR_ELE = ? ' +
            'ORDER BY i.FECHA DESC ' +
            'LIMIT 1',
        [email],
      );

      if (result.isNotEmpty) {
        for (var row in result) {
          var fecha = row['FECHA'] as DateTime;
          var altura = row['ALTURA'] as int;
          var peso = row['PESO'] as int;
          var imc = row['IMC'] as double;
          var fechaNacimiento = row['FEC_NAC'] as DateTime;

          resultList.add({
            'fecha': fecha,
            'altura': altura,
            'peso': peso,
            'imc': imc,
            'fechaNacimiento': fechaNacimiento,
          });
        }
      }

      await conn.close();
    } catch (e) {
      print("$e");
    }

    return {'data': resultList};
  }

  Future<List<DataPoint>> obtenerIMCgrafico(
      DateTime startDate, DateTime endDate) async {
    initializePreferences();
    final conn = await MySqlConnection.connect(settings);
    List<DataPoint> datas = [];

    try {
      var formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      var formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      var result = await conn.query(
        'SELECT FECHA, IMC '
        'FROM IMC '
        'WHERE COR_ELE = ? AND FECHA BETWEEN ? AND ?',
        [email, formattedStartDate, formattedEndDate],
      );

      if (result.isNotEmpty) {
        for (var row in result) {
          var fecha = row['FECHA'];
          var imc = double.tryParse(row['IMC']) ?? 0.0;
          datas.add(DataPoint(imc, DateTime.parse(fecha)));
          print(fecha + imc);
        }
      }
      print("Se obtuvo informacion");
    } catch (e) {
      print("No conectado $e");
    }

    await conn.close();
    return datas;
  }

  Future<List<DataPoint>> recuperarIMCfechas(
      DateTime fechaInicio, DateTime fechaFinal) async {
    initializePreferences();
    try {
      final conn = await MySqlConnection.connect(settings);
      var formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      var formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      var result = await conn.query(
        'SELECT FECHA, IMC '
        'FROM IMC '
        'WHERE COR_ELE = ? AND FECHA BETWEEN ? AND ? ORDER BY FECHA ASC',
        [email, formattedStartDate, formattedEndDate],
      );

      List<DataPoint> datos = [];

      if (result.isNotEmpty) {
        for (var row in result) {
          // Obtener los valores de la fila y convertirlos al formato adecuado
          DateTime fecha = DateTime.parse(row[0].toString());
          double imc = double.parse(row[1].toString());

          datos.add(DataPoint(imc, fecha));
        }
      }

      for (var d in datos) {
        print("IMCES AQUI: ${d.getImc()}");
        print("FECHA: ${d.getDate()}");
      }

      return datos;
    } catch (e) {
      print('Error querying MySQL: $e');
      return [];
    }
  }
}
