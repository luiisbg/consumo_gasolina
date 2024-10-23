import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gasolina/Funciones/BaseDeDatos.dart';
import 'package:gasolina/Funciones/CapturarOdometro.dart';
import 'package:gasolina/Vista/InicioSesion.dart';
import 'package:gasolina/Vista/Servicios.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simular un retraso para representar la carga
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Cambiar el estado de carga a false
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async {
              // Cerrar la conexión a la base de datos
              Conexion conexion = Conexion();
              await conexion.cerrarConexion();

              // Limpiar la sesión del usuario
              sesionUsuario.userId = '';

              // Navegar a la pantalla de ajustes
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
        title: SizedBox(
            height: size.height * 0.08,
            width: size.width * 0.08,
            child: Image.asset('assets/imagenes/cj_logo.png')),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  height: 35,
                  width: 35,
                  color: Colors.orange,
                  animateIcon: AnimateIcons.loading1,
                ),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Hero(
                        tag: 'logo',
                        child: SizedBox(
                          height: 100,
                          child: Center(
                              child:
                                  Image.asset('assets/imagenes/odometro.png')),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                            height: 50,
                            child: Center(
                                child: Text(
                              'Bienvenido:\n${sesionUsuario.nombreUsuario} ',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              textAlign: TextAlign.center,
                            ))))
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),

                //Fila para Capturar Odometro
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              Center(
                                  child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             CapturarOdometro(
                                      //                 cameras: cameras)));
                                      // Agregar Navigator
                                    },
                                    child: Card(
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: AnimateIcon(
                                          key: UniqueKey(),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CapturarOdometro(
                                                            cameras: widget
                                                                .cameras)));
                                          },
                                          iconType: IconType.continueAnimation,
                                          height: 70,
                                          width: 70,
                                          color: Theme.of(context).primaryColor,
                                          animateIcon:
                                              AnimateIcons.numericalSorting,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Capturar\nOdometro',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                            ],
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),

                //Fila para Reportar Servicio
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              Center(
                                  child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Agregar Navigator
                                    },
                                    child: Hero(
                                      tag: 'servicios',
                                      child: Card(
                                        shadowColor: Colors.black,
                                        elevation: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: AnimateIcon(
                                            key: UniqueKey(),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Usuarios()));
                                            },
                                            iconType:
                                                IconType.continueAnimation,
                                            height: 70,
                                            width: 70,
                                            color:
                                                Theme.of(context).primaryColor,
                                            animateIcon: AnimateIcons.list,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Servicios\nReportados',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            ),
    );
  }
}
