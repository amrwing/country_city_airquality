import 'package:contamination_cities/api/request_methods.dart';
import 'package:contamination_cities/global/global_api_information.dart';
import 'package:contamination_cities/providers/coutries_provider.dart';
import 'package:contamination_cities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controlador de textfield
  TextEditingController finder = TextEditingController();
  //Si este parametro es "true", se mostrará un circular loading en el lugar donde tendrá que aparecer la busqueda
  bool isLoading = false;
  //Si texto aviso != null, aparecerá el mensaje que se asigno, mencionando el estado de la busqueda (si no encuentra coincidencias o si hubo un error en el request)
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
          "Países",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
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
                "Calidad del aire alrededor del mundo\nPrimero, encontremos el país\n",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (val) {
                    //SI SE DETECTA QUE EL TEXTFIED ESTÁ VACÍO, ENTONCES SIGNIFICA QUE EL ESTATUS DE BUSQUEDA NO ESTÁ ACTIVO
                    //Entonces vaciamos los valores del provider y cancelamos el circular loading
                    if (val.trim() == "") {
                      selectedCountry.setName = "";
                      selectedCountry.setCapital = "";
                      selectedCountry.setCurrency = "";
                      selectedCountry.setIsoKey = "";
                      selectedCountry.setPopulation = -1;
                      setState(() {
                        isLoading = false;
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
                              "Buscar país",
                            )
                          ]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2))),
                  controller: finder,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    //Si el textfield NO está vacío entronces comienza el estatus de busqueda
                    if (finder.text.trim() != "") {
                      setState(() {
                        //Activamos el estatus de busqueda ya que empezamos a buscar
                        isLoading = true;
                      });
                      //Hacemos un await del request
                      final value = await RequestMethods.solicitarDatosDePais(
                          finder.text.trim());
                      //si el valor que recibimos contiene el valor "not found", significa que no hubo coincidencia (revisar el método para ver los posibles casos de respuesta)
                      if (value == "Not found") {
                        //NO SE ENCONTRARON COINCIDENCIAS
                        //Para cumplir con la condición de muestreo de la busqueda, tendremos que reinciiar el estado del país seleccionado
                        //Cuando los valores del selectedCountry son vacíos, significa que no hay ningun elemento en busqueda
                        selectedCountry.setName = "";
                        selectedCountry.setCapital = "";
                        selectedCountry.setCurrency = "";
                        selectedCountry.setIsoKey = "";
                        selectedCountry.setPopulation = -1;
                        textoAviso = "País no encontrado";
                        //Desactivamos el circularloading por que no encontramos nada y actualizamos
                        setState(() {
                          isLoading = false;
                        });
                        //Si la respuesta es una lista y no está vacía (segun la estructura de las respuestas de la api) significa que se encontró una coincidencia
                      } else if (value is List<dynamic> && value.isNotEmpty) {
                        //No habrá aviso de advertencia
                        textoAviso = null;
                        //Asignamos los valores de la respuesta en el estado de país seleccionado
                        selectedCountry.setName = value[0]['name'];
                        selectedCountry.setCapital = value[0]['capital'];
                        selectedCountry.setCurrency =
                            value[0]['currency']['name'];
                        selectedCountry.setIsoKey = value[0]['iso2'];
                        selectedCountry.setPopulation = value[0]['population'];
                        //Como se encontró una coincidencia, ocultamos el circular loading
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
                    //CUANDO ESTÁ VACÍO NO MUESTRA NADA
                    setState(() {});
                  },
                  child: const Text("Buscar")),
              (isLoading)
                  ? const CirculoDeCarga()
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
                                              " ${selectedCountry.getPopulation.toInt().toString()} personas")
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
                                              try {
                                                //Realizamos la consulta de la api y mostramos un dialog mientras se genera la respuesta
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ));
                                                final value =
                                                    await RequestMethods
                                                        .solicitarCiudadesDePais(
                                                            selectedCountry
                                                                .getIsoKey,
                                                            30);
                                                //Si el valor retornado es una lista y no está vacía, entonces encontró las ciudades
                                                if (value is List<dynamic> &&
                                                    value.isNotEmpty) {
                                                  //Asignamos las ciudades a un archivo global para poder usarla en la proxima pantalla
                                                  listaCiudadesPrincipal =
                                                      value;
                                                  // ignore: use_build_context_synchronously
                                                  context.pop();
                                                  // ignore: use_build_context_synchronously
                                                  context
                                                      .push("/cities_screen");
                                                } else {
                                                  //LA RESPUESTA ES UN ERROR
                                                  textoAviso = "Error $value";
                                                  // ignore: use_build_context_synchronously
                                                  context.pop();
                                                }
                                              } catch (e) {
                                                // ignore: use_build_context_synchronously
                                                context.pop();
                                                rethrow;
                                              }
                                            },
                                            child: const SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text("Ver ciudades"),
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
            ],
          ),
        ),
      ),
    ));
  }
}
