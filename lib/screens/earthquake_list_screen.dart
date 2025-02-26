import 'package:flutter/material.dart';
import 'package:provider/provider.dart';// Importamos el proveedor que maneja los datos de terremotos
import '../providers/earthquake_provider.dart';// Importamos los widgets personalizados utilizados en la pantalla
import '../widgets/earthquake_list_item.dart'; // Item de la lista de terremotos
import '../widgets/magnitude_filter.dart'; // Filtro de magnitud
import 'earthquake_map_screen.dart'; // Pantalla del mapa de terremotos
/*
EarthquakeListScreen: Declara la pantalla de la lista de terremotos como un StatefulWidget porque necesita manejar el estado interno.
_EarthquakeListScreenState: La clase de estado asociada a la pantalla.
*/
// se define la pantalla de la lista de terremotos como un StatefulWidget
class EarthquakeListScreen extends StatefulWidget {
  const EarthquakeListScreen({Key? key}) : super(key: key);

  @override
  _EarthquakeListScreenState createState() => _EarthquakeListScreenState();
}
/*
_scrollController: Se usa para detectar cuándo el usuario llega al final de la lista y así cargar más datos.
*/
class _EarthquakeListScreenState extends State<EarthquakeListScreen> {
  // Controlador para manejar el scroll de la lista
  final ScrollController _scrollController = ScrollController();
/*
initState: Se ejecuta al iniciar la pantalla.
Future.microtask(() => Provider.of<EarthquakeProvider>(context, listen: false).fetchEarthquakes()):
Usa Provider.of con listen: false para obtener el EarthquakeProvider y llamar fetchEarthquakes(), lo que inicia la carga de datos.
Future.microtask garantiza que se ejecute después de que se construya el widget.
_scrollController.addListener(_onScroll);:
Registra un listener para detectar cuando el usuario se acerca al final de la lista y cargar más datos automáticamente.
*/
  @override
  void initState() {
    super.initState();
    
    // Cargamos los terremotos al iniciar la pantalla
    Future.microtask(() => 
      Provider.of<EarthquakeProvider>(context, listen: false).fetchEarthquakes()
    );

    // Agregamos un listener para detectar cuando se llega al final de la lista
    _scrollController.addListener(_onScroll);
  }

/*
dispose: Se llama cuando el widget se elimina de la pantalla.
_scrollController.removeListener(_onScroll);: Elimina el listener del scroll para evitar llamadas innecesarias.
_scrollController.dispose();: Libera la memoria utilizada por el controlador.
*/
  @override
  void dispose() {
    // Eliminamos el listener y liberamos el controlador cuando se destruye el widget
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
/*
_onScroll: Se ejecuta cuando el usuario se acerca al final de la lista.
_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200:
Verifica si el usuario está a 200 píxeles del final de la lista.
provider.isLoading:
Evita cargar más datos si ya se está procesando una solicitud.
provider.hasMoreData:
Solo carga más datos si hay más disponibles.
*/
  // Método que se ejecuta cuando el usuario se acerca al final de la lista
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Obtenemos el proveedor de terremotos
      final provider = Provider.of<EarthquakeProvider>(context, listen: false);
      
      // Si no está cargando y hay más datos, cargamos más terremotos
      if (!provider.isLoading && provider.hasMoreData) {
        provider.loadMoreEarthquakes();
      }
    }
  }
/*
Scaffold: Estructura básica de la pantalla.
AppBar: Barra superior con el título "Terremotos en Tiempo Real".
IconButton(Icons.map):
Al hacer clic, navega a EarthquakeMapScreen().
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terremotos en Tiempo Real'), // Título de la pantalla
        actions: [
          IconButton(
            icon: const Icon(Icons.map), // Botón de acceso a la pantalla del mapa
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EarthquakeMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      /*
      Column:
      Contiene el filtro de magnitud y la lista de terremotos.
      MagnitudeFilter():
      Widget para filtrar la lista según la magnitud.
      */
      body: Column(
        children: [
          const MagnitudeFilter(), // Widget de filtrado por magnitud
          Expanded(
            child: Consumer<EarthquakeProvider>(
              builder: (context, provider, child) {
                /*
                Si isLoading es true y earthquakes está vacío:
                Muestra un indicador de carga.
                Si hay un error:
                Muestra un mensaje con la descripción del error.
                Si la lista está vacía después de aplicar filtros:
                Muestra un mensaje de "No se encontraron terremotos"
                */
                if (provider.isLoading && provider.earthquakes.isEmpty) {
                  // Muestra un indicador de carga si está cargando y no hay datos
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.error.isNotEmpty && provider.earthquakes.isEmpty) {
                  // Muestra un mensaje de error si ocurrió un problema al cargar los datos
                  return Center(child: Text('Error: ${provider.error}'));
                }
                
                if (provider.earthquakes.isEmpty) {
                  // Muestra un mensaje si no se encontraron terremotos con los filtros aplicados
                  return const Center(
                    child: Text('No se encontraron terremotos con estos filtros'),
                  );
                }
                /*
                ListView.builder:
                Genera la lista de terremotos dinámicamente.
                controller: _scrollController:
                Asigna el controlador para detectar el scroll.
                itemCount: provider.earthquakes.length + (provider.hasMoreData ? 1 : 0):
                Si hay más datos, se suma 1 para mostrar el CircularProgressIndicator.
                EarthquakeListItem(earthquake: earthquake):
                Muestra cada terremoto en la lista.
                */
                // Lista de terremotos con soporte para scroll infinito
                return ListView.builder(
                  controller: _scrollController, // Asigna el controlador de scroll
                  itemCount: provider.earthquakes.length + (provider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.earthquakes.length) {
                      // Muestra un indicador de carga al final de la lista si hay más datos por cargar
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    // Muestra un item de la lista de terremotos
                    final earthquake = provider.earthquakes[index];
                    return EarthquakeListItem(earthquake: earthquake);
                  },
                );
              },
            ),
          ),
        ],
      ),
      /*
      FloatingActionButton:
      Recarga manualmente la lista de terremotos.

      */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Botón para recargar la lista de terremotos manualmente
          Provider.of<EarthquakeProvider>(context, listen: false).fetchEarthquakes();
        },
        tooltip: 'Actualizar',
        child: const Icon(Icons.refresh), // Icono de actualización
      ),
    );
  }
}
