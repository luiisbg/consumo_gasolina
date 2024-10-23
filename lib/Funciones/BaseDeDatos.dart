import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conexion {
  MySQLConnectionPool? pool;

  /// Inicializa la conexión a la base de datos.
  Future<void> initializeConnection() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String host = prefs.getString('servidor') ?? 'defaultServidor';
      String user = prefs.getString('usuario') ?? 'defaultUsuario';
      String password = prefs.getString('contrasena') ?? 'defaultContrasena';
      String dbName = prefs.getString('nombreBD') ?? 'defaultBD';

      pool = MySQLConnectionPool(
        host: host,
        port: 3306,
        userName: user,
        password: password,
        maxConnections: 10,
        databaseName: dbName,
        secure: false,
      );
    } catch (e) {
      print('Error al inicializar la conexión: $e');
      rethrow; // Permite propagar el error
    }
  }

  /// Realiza una consulta a la base de datos y devuelve los resultados.
  Future<List<Map<String, dynamic>>> realizarConsulta(String consultaBD) async {
    if (pool == null) throw Exception('La conexión no ha sido inicializada.');

    try {
      var consulta = await pool!.execute(consultaBD);
      return consulta.numOfRows > 0
          ? consulta.rows.map((row) => row.assoc()).toList()
          : [];
    } catch (e) {
      print('Error al realizar la consulta: $e');
      rethrow; // Propaga el error para manejarlo en otro lugar
    }
  }

  /// Cierra la conexión a la base de datos y actualiza el estado de la sesión.
  Future<void> cerrarConexion() async {
    try {
      await pool?.close();
      pool = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesionIniciada', false);
    } catch (e) {
      print('Error al cerrar la conexión: $e');
    }
  }
}

// Declarar la variable global
late Conexion conexionGlobal;
