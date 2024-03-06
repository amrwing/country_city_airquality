import 'package:flutter/material.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  int limite = 30;
  final _focusNode = FocusNode();
  final finder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //INSTANCIAMOS PROVIDER

    //OBTENEMOS SU VALOR
    return Material(
      child: Scaffold(
        appBar:
            AppBar(title: const Text("Cities"), backgroundColor: Colors.indigo),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
                mainAxisAlignment:
                    (MediaQuery.of(context).viewInsets.bottom == 0)
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
                                  "Search a city",
                                )
                              ]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2))),
                      controller: finder,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text("Search"),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
