import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //importa funcionalidades para formatear fechas y horas
import '../models/earthquake.dart'; // Importamos el modelo de datos de terremotos.


//---------Esta clase extiende StatelessWidget, lo que significa que es un 
//widget inmutable que no mantiene estado. Recibe un objeto Earthquake como parámetro requerido en su constructor.
//--------
/// Widget que representa un ítem de la lista de terremotos.
class EarthquakeListItem extends StatelessWidget {
  final Earthquake earthquake; // Objeto de terremoto que se mostrará en este ítem.

  /// Constructor del widget que recibe un objeto `Earthquake` como parámetro requerido.
  const EarthquakeListItem({Key? key, required this.earthquake}) : super(key: key);
//--------------
/*-----Este método privado determina el color del indicador visual según la magnitud del terremoto:

Verde para magnitudes menores a 2 (terremotos leves)
Amarillo para magnitudes entre 2 y 4 (terremotos moderados)
Naranja para magnitudes entre 4 y 6 (terremotos fuertes)
Rojo para magnitudes mayores a 6 (terremotos muy fuertes/peligrosos)*/

  /// Método para determinar el color del indicador según la magnitud del terremoto.
  Color _getMagnitudeColor() {
    if (earthquake.magnitude < 2) return Colors.green; // Magnitudes menores a 2 → Verde.
    if (earthquake.magnitude < 4) return Colors.yellow; // Magnitudes entre 2 y 4 → Amarillo.
    if (earthquake.magnitude < 6) return Colors.orange; // Magnitudes entre 4 y 6 → Naranja.
    return Colors.red; // Magnitudes mayores a 6 → Rojo.
  }

/*
Este método obligatorio construye la interfaz visual del widget. Utiliza:

Un Card como contenedor principal, que proporciona una apariencia elevada con bordes redondeados
Se establece un margen horizontal de 16 píxeles y vertical de 8 píxeles para el Card
*/
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margen del Card.

      /*
      El ListTile organiza la información del terremoto de manera estructurada:

      leading: Muestra un CircleAvatar (círculo con contenido) que:

      Tiene un color de fondo que depende de la magnitud del terremoto
      Contiene texto que muestra la magnitud con un decimal, en color blanco y negrita


      title: Muestra la ubicación del terremoto
      subtitle: Muestra la fecha y hora del terremoto formateada (día/mes/año hora:minuto)
      onTap: Define qué sucede cuando el usuario toca el elemento de la lista
      */
      child: ListTile(
        leading: CircleAvatar( // Ícono circular con la magnitud.
          backgroundColor: _getMagnitudeColor(), // Color según la magnitud.
          child: Text(
            earthquake.magnitude.toStringAsFixed(1), // Magnitud con un decimal.
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(earthquake.place), // Muestra la ubicación del terremoto.
        subtitle: Text(
          DateFormat('dd/MM/yyyy HH:mm').format(earthquake.time), // Formatea la fecha y hora.
        ),
        /*
        Cuando el usuario toca un elemento de la lista:

        Se muestra un diálogo (AlertDialog) con información detallada del terremoto
        El título del diálogo muestra la magnitud
        El contenido es una Column (columna vertical) con:

        mainAxisSize: MainAxisSize.min: La columna ocupa solo el espacio necesario
        crossAxisAlignment: CrossAxisAlignment.start: Los elementos se alinean a la izquierda
        Varios widgets Text que muestran detalles como ubicación, fecha, coordenadas, profundidad y estado


        En la sección de acciones hay un botón "Cerrar" que cierra el diálogo mediante Navigator.of(ctx).pop()

        Relación entre Widgets

        La Card proporciona el contenedor visual principal con bordes redondeados y sombra
        Dentro de la Card, el ListTile organiza la información en un formato estándar de lista
        El CircleAvatar en la parte izquierda proporciona un indicador visual rápido de la severidad
        El título y subtítulo del ListTile muestran la información básica (lugar y fecha)
        Al tocar el elemento, el AlertDialog muestra información más detallada, organizada en una columna vertical
        El TextButton permite cerrar el diálogo y volver a la lista

        Este widget está diseñado siguiendo los principios de Flutter de composición de widgets más pequeños para 
        crear interfaces más complejas, y sigue el patrón de diseño Material Design.
        */
        onTap: () {
          // Al tocar el elemento, se muestra un diálogo con más detalles.
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Magnitud ${earthquake.magnitude}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ubicación: ${earthquake.place}'),
                  Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(earthquake.time)}'),
                  Text('Latitud: ${earthquake.latitude}'),
                  Text('Longitud: ${earthquake.longitude}'),
                  Text('Profundidad: ${earthquake.depth} km'),
                  Text('Estado: ${earthquake.status}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), // Cierra el diálogo.
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
