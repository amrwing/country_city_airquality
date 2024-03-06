import 'package:flutter/material.dart';

class SelectedCountryProvider extends ChangeNotifier {
  String? _name = "";
  String? _capitalCity = "";
  String? _iso2 = "";
  String? _currency = "";
  double? _population = 0;

  //GETTER DE NOMBRE DEL PAIS SELECCIONADO
  String get getName {
    return _name ?? "";
  }

  //SETTER DE NOMBRE DEL PAIS SELECCIONADO
  set setName(String n) {
    _name = n;
    notifyListeners();
  }

  //GETTER DE ISOKEY DEL PAIS SELECCIONADO
  String get getIsoKey {
    return _iso2 ?? "";
  }

  //SETTER DE ISOKEY DEL PAIS SELECCIONADO
  set setIsoKey(String isokey) {
    _iso2 = isokey;
    notifyListeners();
  }

  //GETTER DE CAPITAL CITY DEL PAIS SELECCIONADO
  String get getCapital {
    return _capitalCity ?? "";
  }

  //SETTER DE CAPITAL CITY DEL PAIS SELECCIONADO
  set setCapital(String cap) {
    _capitalCity = cap;
    notifyListeners();
  }

  //GETTER DE DIVISA DEL PAIS SELECCIONADO
  String get getCurrency {
    return _currency ?? "";
  }

  //SETTER DE DIVISA DEL PAIS SELECCIONADO
  set setCurrency(String curr) {
    _currency = curr;
    notifyListeners();
  }

  //GETTER DE POBLACION DEL PAIS SELECCIONADO
  double get getPopulation {
    return _population ?? -1;
  }

  //SETTER DE POBLACION DEL PAIS SELECCIONADO
  set setPopulation(double pop) {
    _population = pop;
    notifyListeners();
  }
}
