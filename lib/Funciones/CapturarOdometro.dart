import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gasolina/Funciones/BaseDeDatos.dart';
import 'package:gasolina/Vista/InicioSesion.dart';
import 'package:image/image.dart' as img;

class CapturarOdometro extends StatefulWidget {
  const CapturarOdometro({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  _CapturarOdometroState createState() => _CapturarOdometroState();
}

class _CapturarOdometroState extends State<CapturarOdometro> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador de la cámara
    controller = CameraController(
      widget.cameras[0], // Usa la cámara principal
      ResolutionPreset.high, // Baja resolución para optimizar recursos
    );
    _initializeControllerFuture = controller.initialize();
    inicializarConexion();
  }

  // Inicializar la conexión a la base de datos
  Future<void> inicializarConexion() async {
    try {
      conexionGlobal = Conexion(); // Crear la instancia de la conexión
      await conexionGlobal.initializeConnection(); // Inicializar la conexión
    } catch (e) {
      print('Error al inicializar la conexión: $e');
    }
  }

  @override
  void dispose() {
    // Liberar el controlador de la cámara
    controller.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    try {
      await _initializeControllerFuture; // Esperar a que la cámara se inicialice
      XFile picture = await controller.takePicture(); // Tomar la foto

      // Convertir la foto a bytes
      final bytes = await picture.readAsBytes();

      // Decodificar la imagen
      img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage != null) {
        // Redimensionar la imagen a 10% de su tamaño original
        img.Image resizedImage = img.copyResize(originalImage,
            width: (originalImage.width ~/ 10),
            height: (originalImage.height ~/ 10));

        // Convertir la imagen redimensionada a bytes PNG
        List<int> resizedBytes = img.encodePng(resizedImage);
        String base64Image = base64Encode(resizedBytes);

        // Verificar si el ID de usuario está disponible
        if (sesionUsuario.userId.isEmpty) {
          return; // Salir si el ID de usuario está vacío
        }

        // Query para insertar la imagen en la base de datos
        String query = """
        INSERT INTO LecturaOdometro (IdUsuario, Fecha, Foto)
        VALUES (${sesionUsuario.userId}, NOW(), '$base64Image');
        """;

        await conexionGlobal.realizarConsulta(query); // Ejecutar la consulta

        // Mostrar un mensaje de éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto registrada correctamente'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Liberar la cámara inmediatamente después de la captura
        controller.dispose();

        // Esperar unos milisegundos para evitar que la navegación ocurra demasiado rápido
        await Future.delayed(const Duration(milliseconds: 500));

        // Regresar a la pantalla anterior
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      // Mostrar mensaje de error en caso de fallo
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capturar Odómetro')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Vista previa de la cámara
                CameraPreview(controller),
                // Rectángulo indicador
                Positioned(
                  left: 60,
                  top: 200,
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Text(
                      'Capture el odómetro',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Botón para tomar la foto
                Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: ElevatedButton(
                    onPressed: _tomarFoto,
                    child: const Text('Tomar Foto'),
                  ),
                ),
              ],
            );
          } else {
            // Mostrar un indicador de carga mientras se inicializa la cámara
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
