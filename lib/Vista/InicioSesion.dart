import 'package:flutter/material.dart';
import 'package:gasolina/Funciones/BaseDeDatos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _controllerUsuario = TextEditingController();
  final TextEditingController _controllerContrasena = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verificarSesion(); // Verifica la sesión al iniciar
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/ajustes');
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                    width: size.width * 0.2,
                    child: Image.asset('assets/imagenes/cj_logo.png')),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: TextField(
                  controller: _controllerUsuario,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: TextField(
                  controller: _controllerContrasena,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.password),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    verificarCredenciales();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _verificarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sesionIniciada = prefs.getBool('sesionIniciada') ?? false;

    if (sesionIniciada) {
      Navigator.pushReplacementNamed(context, '/inicio');
    }
  }

  Future<void> verificarCredenciales() async {
    WidgetsFlutterBinding.ensureInitialized();
    Conexion conexion = Conexion();
    await conexion.initializeConnection();

    String user = _controllerUsuario.text;
    String password = _controllerContrasena.text;

    String query =
        "SELECT * FROM usuarios WHERE UserName = '$user' AND Password = '$password'";

    try {
      var resultado = await conexion.realizarConsulta(query);

      if (resultado.isNotEmpty) {
        sesionUsuario.userId = resultado[0]['Id'].toString();
        sesionUsuario.nombreUsuario = resultado[0]['NombreUsuario'].toString();

        // Guardar estado de la sesión
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('sesionIniciada', true);

        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error: No hay conexión a la base de datos')),
      );
    }
  }
}

class sesionUsuario {
  static String userId = '';
  static String nombreUsuario = '';
}
