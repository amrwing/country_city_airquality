import 'package:contamination_cities/api/request_methods.dart';
import 'package:contamination_cities/global/global_api_information.dart';
import 'package:contamination_cities/providers/cities_provider.dart';
import 'package:contamination_cities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AssistantMethods {
  static void airQualityDialog(BuildContext context, int index) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    await RequestMethods.solicitarInformacionDeAire(
            listaCiudadesPrincipal[index]['name'],
            listaCiudadesPrincipal[index]['latitude'],
            listaCiudadesPrincipal[index]['longitude'])
        .then((value) {
      if (value is Map && value.isNotEmpty) {
        context.pop();
        //EN ESTA SECCIÓN ASIGNAMOS LOS VALORES DE ESTATUS DEL AIRE DEPENDIENDO DEL AQI PROMEDIO DE CADA CIUDAD
        String calidadCualitativa = "";
        Color colorIndicador = Colors.white;
        calidadAire = value;
        if (calidadAire['overall_aqi'] <= 50) {
          calidadCualitativa = "Bueno";
          colorIndicador = Colors.green;
        } else if (calidadAire['overall_aqi'] > 50 &&
            calidadAire['overall_aqi'] <= 100) {
          calidadCualitativa = "Moderado";
          colorIndicador = Colors.yellow;
        } else if (calidadAire['overall_aqi'] > 100 &&
            calidadAire['overall_aqi'] <= 150) {
          calidadCualitativa = "Insalubre para grupos sensibles";
          colorIndicador = Colors.orange;
        } else if (calidadAire['overall_aqi'] > 150 &&
            calidadAire['overall_aqi'] <= 200) {
          calidadCualitativa = "Insalubre";
          colorIndicador = Colors.red;
        } else if (calidadAire['overall_aqi'] > 200 &&
            calidadAire['overall_aqi'] <= 300) {
          calidadCualitativa = "Muy insalubre";
          colorIndicador = Colors.purple;
        } else if (calidadAire['overall_aqi'] > 300) {
          calidadCualitativa = "Peligroso";
          colorIndicador = Colors.indigo;
        }
        //MOSTRAMOS EL DIALOG DONDE SE MUESTRA LA INFORMACIÓN DEL AIRE DE LA CIUDAD
        showDialog(
          anchorPoint: Offset.fromDirection(BorderSide.strokeAlignCenter),
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.white),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          child: Text(
                            "Calidad del aire en ${listaCiudadesPrincipal[index]['name']}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              calidadCualitativa,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: colorIndicador),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'CO',
                          ),
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'NO2',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'O3',
                          ),
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'SO2',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TarjetaComponenteQuimico(
                              calidadAire: calidadAire,
                              llave: 'PM2.5',
                            ),
                            TarjetaComponenteQuimico(
                              calidadAire: calidadAire,
                              llave: 'PM10',
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        context.pop();
        Fluttertoast.showToast(
            msg: "Ha ocurrido un error al recibir la información");
      }
    });
  }

  static void airQualityDialogSearch(
      BuildContext context, SelectedCityProvider selectedCityProvider) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    await RequestMethods.solicitarInformacionDeAire(
            selectedCityProvider.getCityName,
            selectedCityProvider.getCityLatitude,
            selectedCityProvider.getCitylongitude)
        .then((value) {
      if (value is Map && value.isNotEmpty) {
        context.pop();
        calidadAire = value;
        String calidadCualitativa = "";
        Color colorIndicador = Colors.white;
        calidadAire = value;
        if (calidadAire['overall_aqi'] <= 50) {
          calidadCualitativa = "Buena";
          colorIndicador = Colors.green;
        } else if (calidadAire['overall_aqi'] > 50 &&
            calidadAire['overall_aqi'] <= 100) {
          calidadCualitativa = "Moderada";
          colorIndicador = Colors.yellow;
        } else if (calidadAire['overall_aqi'] > 100 &&
            calidadAire['overall_aqi'] <= 150) {
          calidadCualitativa = "Insalubre para grupos sensibles";
          colorIndicador = Colors.orange;
        } else if (calidadAire['overall_aqi'] > 150 &&
            calidadAire['overall_aqi'] <= 200) {
          calidadCualitativa = "Insalubre";
          colorIndicador = Colors.red;
        } else if (calidadAire['overall_aqi'] > 200 &&
            calidadAire['overall_aqi'] <= 300) {
          calidadCualitativa = "Muy insalubre";
          colorIndicador = Colors.purple;
        } else if (calidadAire['overall_aqi'] > 300) {
          calidadCualitativa = "Peligrosa";
          colorIndicador = Colors.indigo;
        }
        showDialog(
          anchorPoint: Offset.fromDirection(BorderSide.strokeAlignCenter),
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.white),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Calidad del aire en ${selectedCityProvider.getCityName}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: Text(
                            calidadCualitativa,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colorIndicador),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'CO',
                          ),
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'NO2',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'O3',
                          ),
                          TarjetaComponenteQuimico(
                            calidadAire: calidadAire,
                            llave: 'SO2',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TarjetaComponenteQuimico(
                              calidadAire: calidadAire,
                              llave: 'PM2.5',
                            ),
                            TarjetaComponenteQuimico(
                              calidadAire: calidadAire,
                              llave: 'PM10',
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        context.pop();
        Fluttertoast.showToast(
            msg: "Ha ocurrido un error al recibir la información");
      }
    });
  }
}
