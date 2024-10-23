import 'package:flutter/material.dart';
import 'package:gasolina/Funciones/BaseDeDatos.dart';
import 'package:gasolina/Vista/InicioSesion.dart';
import 'package:geolocator/geolocator.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  List<dynamic> resultados = [];

  @override
  void initState() {
    super.initState();
    // Inicializa la conexión a la base de datos
    inicializarConexion();
  }

  // Inicializa la conexión a la base de datos
  Future<void> inicializarConexion() async {
    try {
      conexionGlobal = Conexion(); // Asegúrate de crear la instancia
      await conexionGlobal.initializeConnection(); // Inicializa la conexión
    } catch (e) {
      print('Error al inicializar la conexión: $e');
      // Considera mostrar un mensaje al usuario aquí si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Hero(
              tag: 'servicios',
              child: ElevatedButton(
                onPressed: () {
                  consultar();
                },
                child: const Icon(Icons.home_repair_service),
              ),
            ),
          ),
          resultados.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      var resultado = resultados[index];
                      return Center(
                        child: SizedBox(
                          width: 300,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Prioridad: ${resultado['Prioridad']}',
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Fecha: ${resultado['Fecha']}'),
                                    Text(
                                        'No.Cuenta: ${resultado['NumeroCuenta']}'),
                                    Text('Zona: ${resultado['Zona']}'),
                                    Text('Alcaldía: ${resultado['Alcaldia']}'),
                                    Text(
                                      'Status: ${resultado['Status'] == '0' ? 'Pendiente' : resultado['Status'] == '1' ? 'Atendiendo' : 'Finalizado'}',
                                    ),
                                    if (resultado['Status'] == '2')
                                      const Text('Finalizado')
                                    else ...[
                                      ElevatedButton(
                                        onPressed: resultado['Status'] == '0'
                                            ? () async {
                                                await atenderServicio(
                                                    resultado);
                                              }
                                            : null,
                                        child: const Text('Atender Ahora'),
                                      ),
                                      ElevatedButton(
                                        onPressed: resultado['Status'] == '1'
                                            ? () async {
                                                await finalizarServicio(
                                                    resultado);
                                              }
                                            : null,
                                        child: const Text('Finalizar'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(child: Text('Consultar')),
        ],
      ),
    );
  }

  Future<void> consultar() async {
    if (sesionUsuario.userId.isEmpty) {
      return;
    }

    String consultaBD =
        "SELECT * FROM Servicios WHERE UsuarioId = ${sesionUsuario.userId}";

    try {
      List<Map<String, dynamic>> consultaResultados =
          await conexionGlobal.realizarConsulta(consultaBD);

      setState(() {
        resultados = consultaResultados;
      });
    } catch (e) {}
  }

  Future<void> atenderServicio(resultado) async {
    String query = """UPDATE Servicios 
        SET Status = '1', HoraAtendido = NOW() 
        WHERE NumeroCuenta = '${resultado['NumeroCuenta']}';""";
    await conexionGlobal.realizarConsulta(query);

    // Pasa el número de cuenta a obtenerUbicacionInicio
    await obtenerUbicacionInicio(resultado['NumeroCuenta']);
    setState(() {
      consultar();
    });
  }

  Future<void> finalizarServicio(resultado) async {
    String query = """UPDATE Servicios 
        SET Status = '2', HoraFinalizado = NOW() 
        WHERE NumeroCuenta = '${resultado['NumeroCuenta']}';""";
    await conexionGlobal.realizarConsulta(query);

    // Pasa el número de cuenta a obtenerUbicacionFinal
    await obtenerUbicacionFinal(resultado['NumeroCuenta']);
    setState(() {
      consultar();
    });
  }

  Future<void> obtenerUbicacionInicio(String numeroCuenta) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Actualiza la ubicación en base al NumeroCuenta
      String query = """UPDATE Servicios 
                      SET GPS_Inicio = '$latitude,$longitude' 
                      WHERE NumeroCuenta = '$numeroCuenta';""";
      await conexionGlobal.realizarConsulta(query);
    } else {
      // Manejo de permisos no concedidos
    }
  }

  Future<void> obtenerUbicacionFinal(String numeroCuenta) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Actualiza la ubicación en base al NumeroCuenta
      String query = """UPDATE Servicios 
                      SET GPS_Final = '$latitude,$longitude' 
                      WHERE NumeroCuenta = '$numeroCuenta';""";
      await conexionGlobal.realizarConsulta(query);
    } else {
      // Manejo de permisos no concedidos
    }
  }
}
