import 'package:contamination_cities/api/request_methods.dart';
import 'package:contamination_cities/global/global_api_information.dart';
import 'package:contamination_cities/helpers/assistant_methods.dart';
import 'package:contamination_cities/providers/providers.dart';
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
  bool _searchStatus = false;
  bool isLoading = false;
  String? textoAviso;
  @override
  Widget build(BuildContext context) {
    //INSTANCIAMOS PROVIDER
    final selectedCityProvider = Provider.of<SelectedCityProvider>(context);
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
                    if (val.trim() == "") {
                      selectedCityProvider.setCityName = "";
                      selectedCityProvider.setCityPopulation = -1;
                      selectedCityProvider.setCityLatitude = 0.0;
                      selectedCityProvider.setCitylongitude = 0.0;
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
              ElevatedButton(
                  onPressed: () async {
                    if (finder.text.trim() != "") {
                      setState(() {
                        isLoading = true;
                        _searchStatus = true;
                      });

                      final value =
                          await RequestMethods.solicitarCiudadEspecifica(
                              finder.text.trim(),
                              selectedCountryProvider.getIsoKey);
                      if (value == "Not found") {
                        //NO SE ENCONTRARON COINCIDENCIAS
                        selectedCityProvider.setCityName = "";
                        selectedCityProvider.setCityPopulation = -1;
                        selectedCityProvider.setCityLatitude = 0.0;
                        selectedCityProvider.setCitylongitude = 0.0;
                        textoAviso = "Ciudad no encontrada";
                        setState(() {
                          isLoading = false;
                        });
                      } else if (value is List<dynamic> && value.isNotEmpty) {
                        textoAviso = null;
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
                      selectedCityProvider.setCityName = "";
                      selectedCityProvider.setCityPopulation = -1;
                      selectedCityProvider.setCityLatitude = 0.0;
                      selectedCityProvider.setCitylongitude = 0.0;
                      textoAviso = null;
                      setState(() {
                        isLoading = false;
                      });
                      setState(() {
                        _searchStatus = false;
                      });
                    }
                  },
                  child: const Text("Buscar")),
              const Divider(
                thickness: 2,
              ),
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
                  : (_searchStatus && isLoading)
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (selectedCityProvider.getCityName != "")
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
