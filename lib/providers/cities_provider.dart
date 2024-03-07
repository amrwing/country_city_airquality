import 'package:flutter/material.dart';

class SelectedCityProvider extends ChangeNotifier {
  //COUNTRY INDEX IS THE INDEX ON THE COUNTRY LIST PROVIDED BY THE API
  String _cityName = "";
  // String _country = ""; este dato ya lo posee el provider de Countries
  int _population = -1;
  double _latitude = 0.0;
  double _longitude = 0.0;
  //GETTER DEL NOMBRE DE LA CIUDAD
  String get getCityName {
    return _cityName;
  }

  //SETTER DEL NOMBRE DE LA CIUDAD
  set setCityName(String cityNa) {
    _cityName = cityNa;
    notifyListeners();
  }

  //GETTER DE LA POBLACIÓN DE LA CIUDAD
  int get getCityPopulation {
    return _population;
  }

  //SETTER DE LA POBLACIÓN DE LA CIUDAD
  set setCityPopulation(int cityPop) {
    _population = cityPop;
    notifyListeners();
  }

  //GETTER DE LA LATITUD DE LA CIUDAD
  double get getCityLatitude {
    return _latitude;
  }

  //SETTER DE LA LATITUD DE LA CIUDAD
  set setCityLatitude(double cityLat) {
    _latitude = cityLat;
    notifyListeners();
  }

  //GETTER DE LA LATITUD DE LA CIUDAD
  double get getCitylongitude {
    return _longitude;
  }

  //GETTER DE LA LATITUD DE LA CIUDAD
  set setCitylongitude(double cityLong) {
    _longitude = cityLong;
    notifyListeners();
  }
}
