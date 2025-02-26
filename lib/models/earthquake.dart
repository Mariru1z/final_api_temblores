// Se define la clase Earthquake que representa un terremoto con varias propiedades
class Earthquake {
  /*
  final: Se utiliza la palabra clave final para indicar que estos valores no cambiarán después de ser asignados.
  id: Identificador único de cada terremoto, útil para identificar registros en la API.
  magnitude: Representa la intensidad del terremoto en la escala de magnitud (como Richter o momento).
  place: Describe la ubicación donde ocurrió el terremoto, generalmente en forma de texto.
  time: Momento exacto en que ocurrió el terremoto, representado con la clase DateTime.
  longitude y latitude: Coordenadas geográficas del epicentro del terremoto.
  depth: Profundidad a la que ocurrió el terremoto en kilómetros.
  status: Estado del terremoto según la API (puede ser reviewed si fue verificado por un experto o automatic si fue generado automáticamente).

  */
  // Propiedades finales (inmutables) que representan la información de un terremoto
  final String id; // Identificador único del terremoto
  final double magnitude; // Magnitud del terremoto
  final String place; // Ubicación donde ocurrió el terremoto
  final DateTime time; // Momento en que ocurrió el terremoto
  final double longitude; // Coordenada de longitud del epicentro
  final double latitude; // Coordenada de latitud del epicentro
  final double depth; // Profundidad del terremoto en kilómetros
  final String status; // Estado del evento (ej. 'reviewed', 'automatic')
/*
Se define un constructor con parámetros nombrados para facilitar la creación de objetos Earthquake.
Se usa required en cada parámetro para asegurarse de que todos los atributos sean proporcionados al instanciar la clase.
Esta estructura hace que los objetos Earthquake sean seguros y consistentes en toda la aplicación.
*/
  // Constructor de la clase Earthquake, que requiere todos los atributos obligatoriamente
  Earthquake({
    required this.id,
    required this.magnitude,
    required this.place,
    required this.time,
    required this.longitude,
    required this.latitude,
    required this.depth,
    required this.status,
  });
/*
Se usa un factory constructor, que permite crear instancias de Earthquake a partir de datos en formato JSON.
Este método es útil para transformar la respuesta de la API en un objeto Earthquake manejable en Flutter.
*/
  // Método de fábrica para crear una instancia de Earthquake desde un JSON
  factory Earthquake.fromJson(Map<String, dynamic> json) {
    /*
    Se extrae el identificador único (id) del JSON, que será utilizado para diferenciar cada terremoto.
    */
    return Earthquake(
      id: json['id'], // Se obtiene el identificador del JSON
      /*
      Se accede al valor de magnitud dentro del objeto JSON en properties['mag'].
      Se usa ?.toDouble() para convertir el valor a double, en caso de que sea null.
      Si el valor no está presente en el JSON, se asigna un valor predeterminado de 0.0.
      */
      // Se obtiene la magnitud desde la clave 'properties' -> 'mag', si no existe, se asigna 0.0
      magnitude: json['properties']['mag']?.toDouble() ?? 0.0,
      /*
      Se obtiene la ubicación del terremoto de properties['place'].
      Si la ubicación no está disponible, se asigna "Unknown location" como valor predeterminado.  
      */
      // Se obtiene la ubicación desde 'properties' -> 'place', si no existe, se asigna 'Unknown location'
      place: json['properties']['place'] ?? 'Unknown location',
      /*
      json['properties']['time'] contiene el timestamp del terremoto en milisegundos desde la época Unix.
      Se convierte a un objeto DateTime usando DateTime.fromMillisecondsSinceEpoch(), lo que permite manipularlo fácilmente en Flutter.
      */
      // Se obtiene el tiempo en milisegundos y se convierte a un objeto DateTime
      time: DateTime.fromMillisecondsSinceEpoch(json['properties']['time']),
      /*
      Se accede al arreglo de coordenadas dentro de geometry['coordinates'].
      coordinates[0]: Contiene la longitud del epicentro.
      coordinates[1]: Contiene la latitud del epicentro.
      coordinates[2]: Contiene la profundidad en kilómetros.
      */
      // Se obtienen las coordenadas del epicentro desde 'geometry' -> 'coordinates'
      longitude: json['geometry']['coordinates'][0], // Longitud
      latitude: json['geometry']['coordinates'][1], // Latitud
      depth: json['geometry']['coordinates'][2], // Profundidad en kilómetros
      /*
      Se obtiene el estado del evento desde properties['status'], indicando si fue revisado o generado automáticamente.
      Si no existe, se usa "unknown" como valor predeterminado
      */
      // Se obtiene el estado del terremoto desde 'properties' -> 'status', si no existe, se asigna 'unknown'
      status: json['properties']['status'] ?? 'unknown',
    );
  }
}
/*
Obtener datos de la API: La clase USGSApiService hace una solicitud a la API de USGS y recibe datos en formato JSON.
Convertir JSON a objetos Earthquake: Se usa Earthquake.fromJson(json) para transformar los datos en objetos reutilizables.
Usar EarthquakeProvider: La clase EarthquakeProvider almacena y gestiona la lista de terremotos, proporcionando datos a los widgets.
Mostrar en la UI: Widgets como ListView.builder o FutureBuilder muestran la lista de terremotos en la interfaz de usuario.
*/