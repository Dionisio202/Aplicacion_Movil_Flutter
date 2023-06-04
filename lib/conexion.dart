import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

final settings = ConnectionSettings(
  host: 'bdmaqgeqcojjnmapceth-mysql.services.clever-cloud.com',
  port: 3306,
  user: 'ufaomtpab6ngtxtl',
  password: 'ouVHL4pCZexLZWKJu1fT',
  db: 'bdmaqgeqcojjnmapceth',
);
Future<bool> insertarRegistro(
    String correo,
    String usuario,
    String nombres,
    String nombres2,
    String apellidos,
    String apellidos2,
    int estatura,
    int peso,
    String contrasenia) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Establecer la configuración de la conexión

  try {
    // Crear la conexión
    final conn = await MySqlConnection.connect(settings);

    // La conexión se realizó con éxito
    print('Conexión exitosa');

    // Insertar un nuevo registro en la tabla "USUARIOS"
    final result = await conn.query(
        'INSERT INTO USUARIOS (COR_ELE, NOM_USU, NOM_PER, NOM2_PER, APE_PER, APE2_PER, EST_PER, PES_PER, CON_USU) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          correo,
          usuario,
          nombres,
          nombres2,
          apellidos,
          apellidos2,
          estatura,
          peso,
          contrasenia
        ]);

    // Verificar si el registro se insertó correctamente
    int n = result.affectedRows!.toInt();
    if (n > 0) {
      print('Registro insertado correctamente');
      await conn.close();
      return true;
    } else {
      print('Error al insertar el registro');
      await conn.close();
      return false;
    }
  } catch (e) {
    // Ocurrió un error al establecer la conexión
    print('Error de conexión: $e');
    return false;
  }
}

Future<bool> obtenerUsuarioYContrasenia(
    String contrasenia, String usuario) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Crear la conexión
    final conn = await MySqlConnection.connect(settings);

    // La conexión se realizó con éxito
    print('Conexión exitosa');

    // Obtener el usuario y la contrasenia
    final Result = await conn.query(
      'SELECT NOM_USU, CON_USU FROM USUARIOS WHERE CON_USU = ? AND NOM_USU = ?',
      [contrasenia, usuario],
    );

    // Verificar si se obtuvo un resultado
    if (Result.isNotEmpty) {
      final row = Result.first;
      final nombreUsuario = row['NOM_USU'];
      final contraseniaUser = row['CON_USU'];

      await conn.close();

      // Comparar la contrasenia ingresada con la contrasenia del usuario
      if (contrasenia == contraseniaUser && usuario == nombreUsuario) {
        return true;
      } else {
        return false;
      }
    } else {
      print(
          'No se encontró un usuario con la contrasenia y el usuario especificados');
      await conn.close();
      return false;
    }
  } catch (e) {
    print('Error de conexión: $e');
    return false;
  }
}
