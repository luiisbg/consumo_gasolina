import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  final TextEditingController _controllerServidor = TextEditingController();
  final TextEditingController _controllerUsuario = TextEditingController();
  final TextEditingController _controllerContrasena = TextEditingController();
  final TextEditingController _controllerNombreBD = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _controllerServidor.text = prefs.getString('servidor') ?? '';
    _controllerUsuario.text = prefs.getString('usuario') ?? '';
    _controllerContrasena.text = prefs.getString('contrasena') ?? '';
    _controllerNombreBD.text = prefs.getString('nombreBD') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Conexión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SizedBox(
                  width: size.width * 0.2,
                  child: Image.asset('assets/imagenes/cj_logo.png')),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onTap: () {
                _controllerServidor.clear();
              },
              obscureText: true,
              controller: _controllerServidor,
              decoration: const InputDecoration(
                labelText: 'Servidor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onTap: () {
                _controllerUsuario.clear();
              },
              obscureText: true,
              controller: _controllerUsuario,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onTap: () {
                _controllerContrasena.clear();
              },
              controller: _controllerContrasena,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onTap: () {
                _controllerNombreBD.clear();
              },
              obscureText: true,
              controller: _controllerNombreBD,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Base de Datos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Guardar en SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('servidor', _controllerServidor.text);
                await prefs.setString('usuario', _controllerUsuario.text);
                await prefs.setString('contrasena', _controllerContrasena.text);
                await prefs.setString('nombreBD', _controllerNombreBD.text);

                // Mostrar mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajustes guardados')),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar Ajustes'),
            ),
          ],
        ),
      ),
    );
  }
}
