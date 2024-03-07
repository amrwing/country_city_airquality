import 'package:contamination_cities/api/request_methods.dart';
import 'package:contamination_cities/global/global_api_information.dart';
import 'package:contamination_cities/helpers/assistant_methods.dart';
import 'package:contamination_cities/providers/providers.dart';
import 'package:contamination_cities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  int limite = 30;
  final _focusNode = FocusNode();
  final finder = TextEditingController();
  //(La pantalla al principio muestra varias tarjetas de ciudades del país si el searchStatus está desactivado )
  //Si está activado significa que se comenzó a realizar una busqueda a través del textfield de busqueda. Entonces desaparecen
  //todas las tarjetas de ciudades para que tras la busqueda solo aparezca el elemento buscado
  bool _searchStatus = false;
  //De la misma forma que en países, utilizamos isLoading para hacer aparcer o desaparecer un circulo de carga al realizar los requests
  bool isLoading = false;
  // Es el texto que aparece en caso de que no encuentre una ciudad o haya un error
  String? textoAviso;
  @override
  Widget build(BuildContext context) {
    //INSTANCIAMOS PROVIDER DE CIUDAD
    final selectedCityProvider = Provider.of<SelectedCityProvider>(context);
    //PROVIDER DE PAÍS
    final selectedCountryProvider =
        Provider.of<SelectedCountryProvider>(context);
    //OBTENEMOS SU VALOR
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            title: Text(
              "Ciudades de ${selectedCountryProvider.getName}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black),
        //EN EL BODY PRINCIPAL, TENEMOS LA BARRA DE BUSQUEDA DE CIUDADES, ESTA ES FIJA Y SE ENCUENTRA DENTRO DE UN COLUMN PARA PONER MÁS ELEMENTOS DEBAJO
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              Text(
                "Calidad del aire en ${selectedCountryProvider.getName}\n Ahora busca la ciudad",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (val) {
                    //SI EL TEXTFIELD DETECTA QUE ESTÁ VACÍO
                    if (val.trim() == "") {
                      selectedCityProvider.setCityName = "";
                      selectedCityProvider.setCityPopulation = -1;
                      selectedCityProvider.setCityLatitude = 0.0;
                      selectedCityProvider.setCitylongitude = 0.0;
                      // DEVOLVEMOS LA APARICIÓN DE LAS TARJETAS DE ALGUNAS CIUDADES DEL PAÍS
                      setState(() {
                        isLoading = false;
                        _searchStatus = false;
                      });
                    }
                  },
                  focusNode: _focusNode,
                  onTapOutside: (_) => _focusNode.unfocus(),
                  decoration: InputDecoration(
                      label: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.search),
                            Text(
                              "Buscar ciudad",
                            )
                          ]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2))),
                  controller: finder,
                ),
              ),
              //BOTON PARA INICIAR BUSQUEDA PERSONALIZADA
              ElevatedButton(
                  onPressed: () async {
                    //Si el textfield contiene texto
                    if (finder.text.trim() != "") {
                      //Activamos el estatus de busqueda (El estat)
                      setState(() {
                        isLoading = true;
                        _searchStatus = true;
                      });
                      //Hacemos un await del request
                      final value =
                          await RequestMethods.solicitarCiudadEspecifica(
                              finder.text.trim(),
                              selectedCountryProvider.getIsoKey);
                      if (value == "Not found") {
                        //NO SE ENCONTRARON COINCIDENCIAS
                        //Para cumplir con la condición de muestreo de la busqueda, tendremos que reinciiar el estado del país seleccionado
                        //Cuando los valores del selectedCountry son vacíos, significa que no hay ningun elemento en busqueda
                        selectedCityProvider.setCityName = "";
                        selectedCityProvider.setCityPopulation = -1;
                        selectedCityProvider.setCityLatitude = 0.0;
                        selectedCityProvider.setCitylongitude = 0.0;
                        textoAviso = "Ciudad no encontrada";
                        //Desactivamos el circularloading por que no encontramos nada y actualizamos
                        setState(() {
                          isLoading = false;
                        });
                        //Si la respuesta es una lista y no está vacía (segun la estructura de las respuestas de la api) significa que se encontró una coincidencia
                      } else if (value is List<dynamic> && value.isNotEmpty) {
                        //No habrá aviso de advertencia
                        textoAviso = null;
                        //Asignamos los valores de la respuesta en el estado de país seleccionado
                        selectedCityProvider.setCityName = value[0]['name'];
                        selectedCityProvider.setCityPopulation =
                            value[0]['population'] ?? 0;
                        selectedCityProvider.setCityLatitude =
                            value[0]['latitude'];
                        selectedCityProvider.setCitylongitude =
                            value[0]['longitude'];

                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        //LA RESPUESTA ES UN ERROR
                        textoAviso = "Error $value";
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      //Si el textfield está vacío, vaciamos el estado de mi provider y así desaparecerá el estatus de busqueda (dejando el textfield de busqueda solo)
                      selectedCityProvider.setCityName = "";
                      selectedCityProvider.setCityPopulation = -1;
                      selectedCityProvider.setCityLatitude = 0.0;
                      selectedCityProvider.setCitylongitude = 0.0;
                      textoAviso = null;
                      setState(() {
                        isLoading = false;
                        _searchStatus = false;
                      });
                    }
                  },
                  child: const Text("Buscar")),
              const Divider(
                thickness: 2,
              ),
              //SI EL ESTATUS DE BUSQUEDA ESTÁ DESACTIVADO MOSTRAREMOS TARJETAS DE ALGUNAS CIUDADES
              (!_searchStatus)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: listaCiudadesPrincipal.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${listaCiudadesPrincipal[index]['name']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.people_sharp),
                                            Text(
                                                " ${listaCiudadesPrincipal[index]['population'] ?? "Cantidad desconocida de"} personas")
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(Icons.location_on),
                                                Text("Coordenadas"),
                                              ],
                                            ),
                                            Text(
                                              "Latitud: ${listaCiudadesPrincipal[index]['latitude']}\nLongitud: ${listaCiudadesPrincipal[index]['longitude']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () => AssistantMethods
                                                  .airQualityDialog(
                                                      context, index),
                                              child: const SizedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Text(
                                                      "Ver calidad del aire"),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  //SI SE ACTIVO EL ESTATUS DE BUSQUEDA Y EL ESTATUS DE CARGA, MOSTRAREMOS UN CIRCULAR LOADING
                  : (_searchStatus && isLoading)
                      ? const CirculoDeCarga()
                      //SI IS LOADING SE VUELVE FALSO (A ESTE PUNTO _SEARCHSTATUS NO PUEDE SER FALSO) SIGNIFICA QUE HAY RESPUESTA
                      : (selectedCityProvider.getCityName !=
                              "") //SI HUBO ASIGNACIÓN DE RESPUESTA DE LA BUSQUEDA ENTONCES MOSTRAREMOS SOLO UNA TARJETA (LA DE LA CIUDAD CONSULTADA)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 12,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "[${selectedCountryProvider.getIsoKey}]${selectedCityProvider.getCityName}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.people_sharp),
                                              Text(
                                                  " ${selectedCityProvider.getCityPopulation.toInt().toString()} personas")
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text("Coordenadas"),
                                                ],
                                              ),
                                              Text(
                                                "Lattitud: ${selectedCityProvider.getCityLatitude.toString()}\nLongitud: ${selectedCityProvider.getCitylongitude}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () => AssistantMethods
                                                    .airQualityDialogSearch(
                                                        context,
                                                        selectedCityProvider),
                                                child: const SizedBox(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    child: Text(
                                                        "Ver calidad del aire"),
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          //EN CASO DE QUE NO HAYA HABIDO RESPUESTA, SIGNIFICA O QUE HUBO UN ERROR O NO SE ENCONTRARON COINCIDENCIAS, MOSTRAMOS EL TEXTO.
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: Text(textoAviso ?? ""),
                              ),
                            )
            ]),
          ),
        ),
      ),
    );
  }
}
