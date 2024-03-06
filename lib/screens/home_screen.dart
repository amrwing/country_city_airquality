import 'package:contamination_cities/api/request_methods.dart';
import 'package:contamination_cities/global/global_api_information.dart';
import 'package:contamination_cities/providers/coutries_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController finder = TextEditingController();
  bool isLoading = false;
  String? textoAviso;

  @override
  void initState() {
    super.initState();
  }

  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    //PROVIDER
    final selectedCountry = Provider.of<SelectedCountryProvider>(context);

    return Material(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Countries",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: (MediaQuery.of(context).viewInsets.bottom == 0)
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              const Text(
                "Find Out About Countries",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  focusNode: _focusNode,
                  onTapOutside: (_) => _focusNode.unfocus(),
                  decoration: InputDecoration(
                      label: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.search),
                            Text(
                              "Search a country",
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
                    });
                    final value = await RequestMethods.solicitarDatosDePais(
                        finder.text.trim());
                    if (value == "Not found") {
                      //NO SE ENCONTRARON COINCIDENCIAS
                      selectedCountry.setName = "";
                      selectedCountry.setCapital = "";
                      selectedCountry.setCurrency = "";
                      selectedCountry.setIsoKey = "";
                      selectedCountry.setPopulation = -1;
                      textoAviso = "Country not found";
                      setState(() {
                        isLoading = false;
                      });
                    } else if (value is List<dynamic> && value.isNotEmpty) {
                      textoAviso = null;
                      selectedCountry.setName = value[0]['name'];
                      selectedCountry.setCapital = value[0]['capital'];
                      selectedCountry.setCurrency =
                          value[0]['currency']['name'];
                      selectedCountry.setIsoKey = value[0]['iso2'];
                      selectedCountry.setPopulation = value[0]['population'];
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
                    selectedCountry.setName = "";
                    selectedCountry.setCapital = "";
                    selectedCountry.setCurrency = "";
                    selectedCountry.setIsoKey = "";
                    selectedCountry.setPopulation = -1;
                    textoAviso = null;
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: const Text("Search"),
              ),
              (isLoading)
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (selectedCountry.getName != "")
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "[${selectedCountry.getIsoKey}]${selectedCountry.getName}",
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
                                              " ${selectedCountry.getPopulation.toInt().toString()} people")
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
                                              Icon(
                                                  Icons.location_city_outlined),
                                              Text(" Capital"),
                                            ],
                                          ),
                                          Text(
                                            selectedCountry.getCapital,
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
                                            onPressed: () async {
                                              //Realizamos la consulta de la api

                                              final value = await RequestMethods
                                                  .solicitarCiudadesDePais(
                                                      selectedCountry.getIsoKey,
                                                      30);
                                              //Si el valor retornado es una lista y no está vacía, entonces encontró las ciudades
                                              if (value is List<dynamic> &&
                                                  value.isNotEmpty) {
                                                //Asignamos las ciudades a un archivo global para poder usarla en la proxima pantalla
                                                listaCiudadesPrincipal = value;
                                                // ignore: use_build_context_synchronously
                                                context.push("/cities_screen");
                                              } else {
                                                //LA RESPUESTA ES UN ERROR
                                                textoAviso = "Error $value";
                                              }
                                            },
                                            child: const SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text("Check Cities"),
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
            ],
          ),
        ),
      ),
    ));
  }
}
