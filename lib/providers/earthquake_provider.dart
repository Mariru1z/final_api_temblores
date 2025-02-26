import 'package:flutter/foundation.dart';// Importamos `foundation.dart` para utilizar `ChangeNotifier`, que permite la gestión del estado en Flutter
import '../models/earthquake.dart'; // Importamos el modelo de datos `Earthquake`
import '../services/usgs_api_service.dart'; // Importamos el servicio que obtiene datos de la API de USGS
/*
Se define EarthquakeProvider como una clase que usa ChangeNotifier, lo que la convierte en un provider en Flutter.
Un provider es una forma de gestionar el estado globalmente y notificar a los widgets cuando los datos cambian.
*/
// Clase `EarthquakeProvider` que gestiona la obtención y actualización de datos sobre terremotos
class EarthquakeProvider with ChangeNotifier {
  /*
  Se crea una instancia privada de USGSApiService para realizar solicitudes a la API.
Se mantiene privada (_apiService) para que solo EarthquakeProvider la use y no se acceda desde otros archivos directamente.
  */
  // Instancia del servicio que realiza las solicitudes a la API de USGS
  final USGSApiService _apiService = USGSApiService();

  // Lista privada que almacena los terremotos obtenidos de la API
  List<Earthquake> _earthquakes = [];

  // Variables de estado
  bool _isLoading = false; // Indica si la aplicación está cargando datos
  double _minMagnitude = 0.0; // Magnitud mínima de los terremotos a buscar
  String _error = ''; // Almacena posibles errores de la API
  int _offset = 1; // Controla la paginación de los datos
  int _limit = 20; // Número de registros a obtener por solicitud
  bool _hasMoreData = true; // Indica si hay más datos disponibles para cargar

  // Getters públicos para acceder a las variables privadas desde otros widgets
  List<Earthquake> get earthquakes => _earthquakes; // Devuelve la lista de terremotos
  bool get isLoading => _isLoading; // Indica si los datos están cargando
  double get minMagnitude => _minMagnitude; // Devuelve la magnitud mínima establecida
  String get error => _error; // Devuelve el mensaje de error si existe
  bool get hasMoreData => _hasMoreData; // Indica si hay más datos para paginación

  // Método para obtener la lista inicial de terremotos desde la API
  Future<void> fetchEarthquakes() async {
    _isLoading = true; // Indica que la carga de datos ha comenzado
    _error = ''; // Limpia errores previos
    _offset = 1; // Reinicia el índice de paginación
    _hasMoreData = true; // Reinicia el estado de paginación
    _earthquakes = []; // Limpia la lista de terremotos anterior
    notifyListeners(); // Notifica a los widgets que dependen de este provider

    try {
      // Se calculan las fechas para obtener terremotos de las últimas 24 horas
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Se llama a la API con los parámetros de tiempo y magnitud
      _earthquakes = await _apiService.getEarthquakes(
        startTime: yesterday,
        endTime: now,
        minMagnitude: _minMagnitude,
        limit: _limit, // Se solicita el número máximo de registros permitidos
      );

      // Si la cantidad de terremotos obtenidos es menor al límite, no hay más datos disponibles
      if (_earthquakes.length < _limit) {
        _hasMoreData = false;
      }

      _isLoading = false; // Finaliza la carga de datos
      notifyListeners(); // Notifica a los widgets para que se actualicen
    } catch (e) {
      _isLoading = false; // Finaliza la carga si ocurre un error
      _error = e.toString(); // Guarda el mensaje de error
      notifyListeners(); // Notifica el cambio para que se refleje en la UI
    }
  }

  // Método para cargar más terremotos mediante paginación
  Future<void> loadMoreEarthquakes() async {
    // Si ya estamos cargando datos o no hay más datos, no hacemos nada
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true; // Iniciamos la carga
    notifyListeners(); // Notificamos a la UI para actualizar el estado

    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Se solicita una nueva página de datos, ajustando el offset
      final moreEarthquakes = await _apiService.getEarthquakes(
        startTime: yesterday,
        endTime: now,
        minMagnitude: _minMagnitude,
        limit: _limit,
        offset: _offset * _limit + 1, // Se calcula el offset para la siguiente página
      );

      // Si no hay más datos o la cantidad de datos obtenidos es menor al límite, detenemos la paginación
      if (moreEarthquakes.isEmpty || moreEarthquakes.length < _limit) {
        _hasMoreData = false;
      } else {
        _earthquakes.addAll(moreEarthquakes); // Agregamos los nuevos datos a la lista existente
        _offset++; // Incrementamos el offset para futuras cargas
      }

      _isLoading = false; // Finalizamos la carga
      notifyListeners(); // Notificamos a la UI para actualizar los datos
    } catch (e) {
      _isLoading = false; // Finalizamos la carga en caso de error
      _error = e.toString(); // Guardamos el mensaje de error
      notifyListeners(); // Notificamos a la UI del error
    }
  }

  // Método para actualizar la magnitud mínima de los terremotos y recargar los datos
  void setMinMagnitude(double value) {
    if (_minMagnitude == value) return; // Si la magnitud no cambia, no hacemos nada
    _minMagnitude = value; // Actualizamos el valor de magnitud mínima
    fetchEarthquakes(); // Volvemos a cargar los datos con la nueva magnitud
  }
}
