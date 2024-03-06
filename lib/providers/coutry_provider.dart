import 'package:flutter/material.dart';

class SelectionCountryProvider extends ChangeNotifier {
  Map<String, dynamic> _information = {};
  Map<String, dynamic> get getCountryInfo {
    return _information;
  }

  set setCountryInformation(Map<String, dynamic> valor) {
    _information = valor;
    notifyListeners();
  }
}
