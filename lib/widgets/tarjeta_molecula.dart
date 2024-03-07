import 'package:flutter/material.dart';

class TarjetaComponenteQuimico extends StatelessWidget {
  //LLAVE ES LA KEY DEL MAPA, EN ESTE CASO LA MOLECULA
  final String llave;
  // VALOR ES EL MAPA DENTRO DE LA KEY (AQI Y CONCENTRATION)
  const TarjetaComponenteQuimico({
    super.key,
    required this.llave,
    required this.calidadAire,
  });

  final Map calidadAire;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const Icon(Icons.air),
                  Text(
                    llave,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                  textAlign: TextAlign.center,
                  "${calidadAire[llave]['concentration']} PPM"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                  textAlign: TextAlign.center,
                  "Indice de calidad ${calidadAire[llave]['aqi']}\n"),
            ),
          ],
        ),
      ),
    );
  }
}
