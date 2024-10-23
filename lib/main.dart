import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:gasolina/Funciones/Ajustes.dart';
import 'package:gasolina/Funciones/BaseDeDatos.dart';
import 'package:gasolina/Vista/InicioSesion.dart';
import 'package:gasolina/Vista/MenuPrincipal.dart';

// late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  Conexion conexion = Conexion();
  await conexion.initializeConnection();

  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  const MainApp({required this.cameras, super.key});
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo Gasolina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        primaryColor: Colors.orange,
        secondaryHeaderColor: Colors.cyan,
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.amber,
      ),
      // Definir rutas
      routes: {
        '/': (context) => const InicioSesion(),
        '/inicio': (context) => Inicio(
              cameras: cameras,
            ),
        '/ajustes': (context) => const Ajustes(),
      },
      initialRoute: '/',
    );
  }
}
