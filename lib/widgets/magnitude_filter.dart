import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/earthquake_provider.dart'; // Importamos el proveedor de datos.
/*
class MagnitudeFilter extends StatelessWidget

Declara una clase MagnitudeFilter que extiende StatelessWidget, lo que significa que este widget 
no tiene un estado interno y depende del estado externo proporcionado por un Provider.
const MagnitudeFilter({Key? key}) : super(key: key);

Declara el constructor del widget como const, lo que permite optimizaciones en Flutter si el widget no cambia después de ser construido.
*/
/// Widget que permite filtrar los terremotos según la magnitud mínima seleccionada.
class MagnitudeFilter extends StatelessWidget {
  /// Constructor del widget.
  const MagnitudeFilter({Key? key}) : super(key: key);

/*
@override

Indica que estamos sobrescribiendo el método build de StatelessWidget, que es el encargado de construir la interfaz del widget.
Widget build(BuildContext context) {

build es el método que se ejecuta cada vez que se necesita construir o reconstruir la interfaz del widget.
*/
  @override
  Widget build(BuildContext context) {
    /*
    final provider = Provider.of<EarthquakeProvider>(context);
    Provider.of<EarthquakeProvider>(context); obtiene una instancia del provider EarthquakeProvider, que gestiona el estado de los terremotos.
    context se usa para acceder a la jerarquía de widgets y encontrar el Provider adecuado.
    Con esto, el widget puede acceder a la magnitud mínima (minMagnitude) y actualizarla con setMinMagnitude()
    */
    // Obtenemos la instancia del provider que gestiona el estado de los terremotos.
    final provider = Provider.of<EarthquakeProvider>(context);

    /*
    return Padding(...)

    Devuelve un Padding, que agrega espacio alrededor del contenido para evitar que esté pegado a los bordes.
    padding: const EdgeInsets.all(16.0),

    EdgeInsets.all(16.0) establece un margen uniforme de 16 píxeles en todos los lados del widget.
    */

    return Padding(
      padding: const EdgeInsets.all(16.0), // Espaciado alrededor del widget.
      /*
      child: Column(...)
      Un Column se usa para organizar widgets en una columna vertical.
      crossAxisAlignment: CrossAxisAlignment.start,
      Alinea los elementos al inicio en el eje horizontal.
      */
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*
          Text(...)
          Muestra un texto indicando la magnitud mínima actual seleccionada.
          provider.minMagnitude.toStringAsFixed(1)
          provider.minMagnitude obtiene el valor de la magnitud mínima desde el provider.
          .toStringAsFixed(1) lo convierte en un número con un solo decimal.
          TextStyle(fontWeight: FontWeight.bold)
          Hace que el texto sea negrita.

          */
          // Texto que muestra la magnitud mínima seleccionada.
          Text(
            'Filtrar por magnitud mínima: ${provider.minMagnitude.toStringAsFixed(1)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          /*
          Slider(...)
          Es un control deslizante para seleccionar valores numéricos.
          min: 0.0, max: 9.0,
          Define el rango de valores de la magnitud mínima (0 a 9).
          divisions: 18,
          Divide el Slider en 18 partes, permitiendo valores con incrementos de 0.5 ((9-0)/18 = 0.5).
          value: provider.minMagnitude,
          Establece el valor actual del Slider según el provider.
          label: provider.minMagnitude.toStringAsFixed(1),
          Muestra un tooltip con el valor actual del Slider.
          onChanged: (value) { provider.setMinMagnitude(value); }
          Cada vez que el usuario mueve el Slider, actualiza el valor en el Provider con setMinMagnitude(value).
          */
          // Control deslizante para seleccionar la magnitud mínima.
          Slider(
            min: 0.0, // Valor mínimo de magnitud.
            max: 9.0, // Valor máximo de magnitud.
            divisions: 18, // Número de divisiones para valores intermedios (0.5 en 0.5).
            value: provider.minMagnitude, // Valor actual.
            label: provider.minMagnitude.toStringAsFixed(1), // Etiqueta flotante.
            onChanged: (value) {
              provider.setMinMagnitude(value); // Actualiza el valor en el provider.
            },
          ),
        ],
      ),
    );
  }
}
/*
ste widget:

Usa Provider para obtener y actualizar la magnitud mínima.
Muestra la magnitud seleccionada con Text().
Permite cambiar la magnitud con un Slider.
Cuando el usuario mueve el Slider, actualiza la magnitud en el Provider, lo que reconstruye este widget y otros que dependan de minMagnitude.
*/
