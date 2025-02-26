// Importamos los paquetes necesarios.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/earthquake_provider.dart'; // Importamos el proveedor de datos.
import 'screens/earthquake_list_screen.dart'; // Importamos la pantalla principal.

/// Función principal que inicia la aplicación.
void main() {
  runApp(const MyApp()); // Ejecuta la app.
}

/// Clase principal de la aplicación.
class MyApp extends StatelessWidget {
  /// Constructor de la clase MyApp.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Proporcionamos el `EarthquakeProvider` a toda la aplicación.
      create: (ctx) => EarthquakeProvider(),
      child: MaterialApp(
        title: 'Earthquake Tracker', // Título de la aplicación.
        debugShowCheckedModeBanner: false, // Oculta la etiqueta de "Debug" en la esquina superior derecha.
        theme: ThemeData(
          primarySwatch: Colors.blue, // Color primario de la aplicación.
          visualDensity: VisualDensity.adaptivePlatformDensity, // Densidad visual adaptativa.
        ),
        home: const EarthquakeListScreen(), // Pantalla principal de la app.
      ),
    );
  }
}
