import 'dart:convert';

import 'package:contamination_cities/api/api_key.dart';
import 'package:contamination_cities/api/urls.dart';
import 'package:contamination_cities/providers/coutry_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> listaPaises = [];
  int limite = 15;
  Future<dynamic> solicitarDatosDePais() async {
    final response =
        await http.get(Uri.parse("${urlCountry}&limit=$limite"), headers: {
      'X-Api-Key': apiKey,
    });
    //CODIGO 200 - SE REALIZÓ LA CONSULTA CON EXITO
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return "Error";
    }
  }

  @override
  void initState() {
    super.initState();
    solicitarDatosDePais().then((value) {
      if (value != "Error") {
        listaPaises = value;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //INSTANCIAMOS PROVIDER
    final countryProvider = Provider.of<SelectionCountryProvider>(context);
    //OBTENEMOS SU VALOR
    return Material(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Países"),
            backgroundColor: Colors.blue[50],
          ),
          //TODO IMPLEMENTAR DATOS DE RESPUESTA DE API
          body: (listaPaises.isNotEmpty)
              ? ListView.builder(
                  itemCount: listaPaises.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      trailing: ElevatedButton(
                          //TODO PERSONALIZAR BOTON
                          style: const ButtonStyle(),
                          onPressed: () {
                            countryProvider.setCountryInformation =
                                listaPaises[index];
                            //TODO EVENTO DE VISUALIZACIÓN DE NUEVA SECCIÓN
                          },
                          child: const Icon(Icons.arrow_forward)),
                      leading: const Icon(Icons.location_city),
                      title: Text(
                        "[${listaPaises[index]['iso2']}] ${listaPaises[index]['name']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      subtitle: Text(
                          "Divisa: ${listaPaises[index]['currency']["name"]}"),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.black54,
                ))),
    );
  }
}
