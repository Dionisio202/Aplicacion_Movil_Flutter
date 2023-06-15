import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class sql {
  static String nombreuser = '';
  static String correouser = '';
  final settings = ConnectionSettings(
    host: 'bdmaqgeqcojjnmapceth-mysql.services.clever-cloud.com',
    port: 3306,
    user: 'ufaomtpab6ngtxtl',
    password: 'ouVHL4pCZexLZWKJu1fT',
    db: 'bdmaqgeqcojjnmapceth',
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

      print('Conexión exitosa');

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de conexión'),
            content: Text(
                'Hubo un problema al conectarse a la base de datos. Por favor, inténtalo de nuevo más tarde. \n $e'),
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
}
