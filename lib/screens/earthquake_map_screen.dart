import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Paquete para integrar Google Maps en Flutter.
import 'package:provider/provider.dart'; // Para la gestión del estado con Provider.
import '../providers/earthquake_provider.dart'; // Importamos el proveedor que contiene los datos de los terremotos.

/*
EarthquakeMapScreen es un StatefulWidget porque la pantalla necesita actualizarse cuando los datos de terremotos cambian.
createState() devuelve una instancia de _EarthquakeMapScreenState, que manejará la lógica y el estado de la pantalla.
*/
/// Pantalla que muestra un mapa con la ubicación de los terremotos.
class EarthquakeMapScreen extends StatefulWidget {
  const EarthquakeMapScreen({Key? key}) : super(key: key);

  @override
  State<EarthquakeMapScreen> createState() => _EarthquakeMapScreenState();
}

class _EarthquakeMapScreenState extends State<EarthquakeMapScreen> {
  /*
  _createMarkers(provider):
Convierte la lista de terremotos en un Set<Marker> para Google Maps.
Si provider.earthquakes es null, devuelve un conjunto vacío.
Usa .map() para transformar cada terremoto en un marcador de Google Maps.
Se establece la posición, título, información adicional y color del marcador.
  */
// Controlador del mapa de Google.

 Set<Marker> _createMarkers(EarthquakeProvider provider) {
  // Verifica que earthquakes no sea null antes de intentar usar map
  // ignore: unnecessary_null_comparison
  if (provider.earthquakes == null) {
    return <Marker>{};  // Retorna un conjunto vacío si earthquakes es null
  }
  
  // Usa el operador null-aware para evitar problemas
  return provider.earthquakes.map((earthquake) {
    return Marker(
      markerId: MarkerId(earthquake.id),
      position: LatLng(earthquake.latitude, earthquake.longitude),
      infoWindow: InfoWindow(
        title: 'Magnitud ${earthquake.magnitude}',
        snippet: earthquake.place,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _getMarkerHue(earthquake.magnitude),
      ),
    );
  }).toSet();
}
/*
_getMarkerHue(magnitude): Retorna un color diferente según la magnitud del terremoto.
Verde: terremotos de baja magnitud (<2).
Amarillo: magnitud entre 2 y 4.
Naranja: magnitud entre 4 y 6.
Rojo: terremotos más fuertes (≥6).
*/
  /// Devuelve el color del marcador dependiendo de la magnitud del terremoto.
  double _getMarkerHue(double magnitude) {
    if (magnitude < 2) return BitmapDescriptor.hueGreen; // Verde para terremotos menores a magnitud 2.
    if (magnitude < 4) return BitmapDescriptor.hueYellow; // Amarillo para terremotos entre 2 y 4.
    if (magnitude < 6) return BitmapDescriptor.hueOrange; // Naranja para terremotos entre 4 y 6.
    return BitmapDescriptor.hueRed; // Rojo para terremotos de magnitud 6 o mayor.
  }
/*
build(context):

Obtiene el EarthquakeProvider con Provider.of<EarthquakeProvider>(context).
Usa Scaffold para construir la pantalla.
Muestra un CircularProgressIndicator() mientras los datos se están cargando.
Cuando los datos están listos, se muestra un GoogleMap.
GoogleMap:

initialCameraPosition: Posición inicial del mapa (latitud 0, longitud 0, zoom 2).
markers: Llama a _createMarkers(provider) para agregar los terremotos.
onMapCreated: Se ejecuta cuando el mapa está listo (aquí podría usarse para mover la cámara).
*/
  @override
  Widget build(BuildContext context) {
    // Obtiene el proveedor que maneja la lista de terremotos.
    final provider = Provider.of<EarthquakeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Terremotos'), // Título de la pantalla en la barra superior.
      ),
      body: provider.isLoading // Si está cargando, muestra un indicador de carga.
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga centrado en la pantalla.
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0), // Posición inicial centrada en el ecuador.
                zoom: 2, // Nivel de zoom inicial.
              ),
              markers: _createMarkers(provider), // Añade los marcadores de los terremotos al mapa.
              onMapCreated: (GoogleMapController controller) {
// Guarda el controlador del mapa para futuras interacciones.
                // Usa el controlador para algo, por ejemplo, para mover la cámara
                // controller.animateCamera(...);
              },
            ),
    );
  }
}
/*
Se importa Google Maps y Provider para manejar el estado de la lista de terremotos.
EarthquakeMapScreen es un StatefulWidget que muestra un mapa con marcadores de terremotos.
Se obtiene la lista de terremotos desde EarthquakeProvider y se crean marcadores en el mapa.
Se usa _getMarkerHue() para cambiar el color del marcador según la magnitud.
Si los datos aún no están disponibles, se muestra un CircularProgressIndicator().
Una vez que los datos están listos, se renderiza el mapa con los marcadores.
*/