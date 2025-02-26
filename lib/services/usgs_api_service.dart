import 'dart:convert'; // Para convertir la respuesta JSON en un objeto de Dart.
import 'package:http/http.dart' as http; // Cliente HTTP para hacer solicitudes a la API.
import '../models/earthquake.dart'; // Importamos el modelo que representa un terremoto.

/*
Se define la clase USGSApiService, que encapsula la lógica para obtener datos de terremotos desde la API de USGS.
final String baseUrl: Almacena la URL base de la API. Se define como final porque su valor no cambiará después de la inicialización
*/
/// Servicio para obtener datos de terremotos desde la API de USGS (United States Geological Survey).
class USGSApiService {
  final String baseUrl = 'https://earthquake.usgs.gov/fdsnws/event/1/'; // URL base de la API de USGS.
  /*
  Se define un método asíncrono (async) llamado getEarthquakes(), que devuelve una Future<List<Earthquake>>, es decir, una lista de terremotos después de completar la solicitud HTTP.
Parámetros de entrada:
startTime: Fecha de inicio del intervalo de búsqueda.
endTime: Fecha de fin del intervalo de búsqueda.
minMagnitude: Magnitud mínima de los terremotos (por defecto 0.0).
limit: Cantidad máxima de resultados a devolver (20 por defecto).
offset: Controla la paginación, indicando desde qué posición comenzar (por defecto 1).
  */

  /// Método para obtener una lista de terremotos en un rango de fechas.
  /// 
  /// Parámetros:
  /// - `startTime`: Fecha de inicio del intervalo de búsqueda.
  /// - `endTime`: Fecha de fin del intervalo de búsqueda.
  /// - `minMagnitude`: Magnitud mínima de los terremotos (por defecto es 0.0).
  /// - `limit`: Cantidad máxima de resultados a devolver (por defecto es 20).
  /// - `offset`: Paginación, indica desde qué posición comenzar (por defecto es 1).
  Future<List<Earthquake>> getEarthquakes({
    required DateTime startTime,
    required DateTime endTime,
    double minMagnitude = 0.0,
    int limit = 20,
    int offset = 1,
  }) async { //de manera asíncrona, funaciona como en segundo hilo
    /*
    La API de USGS requiere que las fechas estén en formato ISO 8601 (YYYY-MM-DDTHH:MM:SSZ).
    Se convierten los objetos DateTime en cadenas con toIso8601String().
    */
    // Convertimos las fechas a formato ISO 8601 (requerido por la API).
    String startTimeStr = startTime.toIso8601String();
    String endTimeStr = endTime.toIso8601String();

/*
Se usa await porque la solicitud HTTP es una operación asíncrona y queremos esperar la respuesta antes de continuar.
Uri.parse() convierte la cadena de texto en un objeto Uri, que es necesario para http.get().
Se usa Interpolación de Strings ($variable) para construir dinámicamente la URL con los parámetros de búsqueda.
*/
/*
${baseUrl}: Este es un marcador de posición que se reemplaza por la base de la URL de la API que se está utilizando.
query?: Indica que se está haciendo una consulta a la API.
format=geojson: Especifica el formato de la respuesta que se espera. En este caso, se solicita el formato GeoJSON, que es comúnmente utilizado para datos geoespaciales.
starttime=$startTimeStr: Establece el tiempo de inicio para filtrar los resultados. $startTimeStr es otro marcador de posición que se reemplaza por una cadena que representa la fecha y hora de inicio.
endtime=$endTimeStr: Similar al anterior, pero establece el tiempo de finalización para la consulta.
minmagnitude=$minMagnitude: Establece un valor mínimo de magnitud para los resultados. $minMagnitude se reemplaza por un número que representa esta magnitud mínima.
limit=$limit: Define el número máximo de resultados que se desea obtener. $limit se reemplaza por un número entero.
offset=$offset: Este parámetro se utiliza para la paginación de los resultados, permitiendo omitir un número específico de registros en la respuesta. $offset se reemplaza por un número entero.
*/
    // Construimos la URL de la solicitud con los parámetros necesarios.
    final response = await http.get(Uri.parse( //parsse convierte o traduce el valor a una url
      '${baseUrl}query?format=geojson&starttime=$startTimeStr&endtime=$endTimeStr&minmagnitude=$minMagnitude&limit=$limit&offset=$offset'
    ));

    /*
    Verificación del código de estado (200): Si la solicitud fue exitosa, se procesa la respuesta.
json.decode(response.body): Convierte la respuesta JSON en un Map<String, dynamic>, lo que permite acceder a los datos con claves.
data['features']: Extrae la lista de terremotos desde la clave features del JSON.
    */

    // Si la respuesta es exitosa (código 200), procesamos los datos.
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body); // Convertimos la respuesta en un mapa de Dart.
      final List<dynamic> features = data['features']; // Extraemos la lista de terremotos de la respuesta.
/*
features.map((feature) => Earthquake.fromJson(feature)).toList():
Se recorre cada elemento de la lista features y se convierte en un objeto Earthquake usando el método fromJson().
Se transforma en una lista con .toList().
Manejo de errores: Si la solicitud falla, se lanza una excepción con un mensaje de error y el código de estado.
*/
      // Convertimos cada terremoto del JSON a un objeto Earthquake y devolvemos la lista.
      return features.map((feature) => Earthquake.fromJson(feature)).toList();
    } else {
      // Si la respuesta falla, lanzamos una excepción con el código de error.
      throw Exception('Failed to load earthquakes: ${response.statusCode}');
    }
  }
}
/*
Se importa http para hacer solicitudes y dart:convert para manejar JSON.
Se define una clase USGSApiService con una URL base.
getEarthquakes() es un método asíncrono que construye una URL con los parámetros recibidos.
Se realiza una solicitud HTTP con http.get().
Si la respuesta es válida, se convierte en una lista de objetos Earthquake.
Si hay un error, se lanza una excepción.
*/
