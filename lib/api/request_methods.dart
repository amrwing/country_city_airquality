import 'dart:convert';
import 'package:contamination_cities/api/api_key.dart';
import 'package:contamination_cities/api/urls.dart';
import 'package:http/http.dart' as http;

class RequestMethods {
  //METODO QUE HACE LA SOLICITUD A LA API DE PAÍS
  static Future<dynamic> solicitarDatosDePais(String pais) async {
    final response =
        await http.get(Uri.parse("${urlCountry}name=$pais"), headers: {
      'X-Api-Key': apiKey,
    });
    //CODIGO 200 - SE REALIZÓ LA CONSULTA CON EXITO
    if (response.statusCode == 200) {
      //SI EL BODY ESTÁ VACÍO NO ENCONTRÓ COINCIDENCIAS
      if (json.decode(response.body).isEmpty) {
        return "Not found";
        //SI NO ESTÁ VACÍO, RETORNA EL VALOR
      } else {
        return json.decode(response.body);
      }
      //CODIGO DE ERROR EN CASO DE QUE ALGO FALLE
    } else {
      return response.statusCode;
    }
    //SI EL TEXTFIELD ESTÁ VACÍO
  }

  static Future<dynamic> solicitarCiudadEspecifica(
      String city, String countryIso2) async {
    final response = await http
        .get(Uri.parse("${urlCity}name=$city&country=$countryIso2"), headers: {
      'X-Api-Key': apiKey,
    });
    //CODIGO 200 - SE REALIZÓ LA CONSULTA CON EXITO
    if (response.statusCode == 200) {
      //SI EL BODY ESTÁ VACÍO NO ENCONTRÓ COINCIDENCIAS
      if (json.decode(response.body).isEmpty) {
        return "Not found";
        //SI NO ESTÁ VACÍO, RETORNA EL VALOR
      } else {
        return json.decode(response.body);
      }
      //CODIGO DE ERROR EN CASO DE QUE ALGO FALLE
    } else {
      return response.statusCode;
    }
    //SI EL TEXTFIELD ESTÁ VACÍO
  }

  //METODO QUE HACE LA SOLICITUD A LA API DE CIUDADES
  static Future<dynamic> solicitarCiudadesDePais(String pais, int limit) async {
    final response = await http
        .get(Uri.parse("${urlCity}country=$pais&limit=$limit"), headers: {
      'X-Api-Key': apiKey,
    });
    //CODIGO 200 - SE REALIZÓ LA CONSULTA CON EXITO
    if (response.statusCode == 200) {
      //SI EL BODY ESTÁ VACÍO NO ENCONTRÓ COINCIDENCIAS
      if (json.decode(response.body).isEmpty) {
        return "Not found";
        //SI NO ESTÁ VACÍO, RETORNA EL VALOR
      } else {
        return json.decode(response.body);
      }
      //CODIGO DE ERROR EN CASO DE QUE ALGO FALLE
    } else {
      return response.statusCode;
    }
    //SI EL TEXTFIELD ESTÁ VACÍO
  }

  //METODO QUE HACE LA SOLICITUD A LA API DE CIUDADES
  static Future<dynamic> solicitarInformacionDeAire(
      String ciudad, double latitud, double longitud) async {
    final response = await http.get(
        Uri.parse("${urlAirQuality}city=$ciudad&lat=$latitud&lon=$longitud"),
        headers: {
          'X-Api-Key': apiKey,
        });
    //CODIGO 200 - SE REALIZÓ LA CONSULTA CON EXITO
    if (response.statusCode == 200) {
      //SI EL BODY ESTÁ VACÍO NO ENCONTRÓ COINCIDENCIAS
      if (json.decode(response.body).isEmpty) {
        return "Not found";
        //SI NO ESTÁ VACÍO, RETORNA EL VALOR
      } else {
        return json.decode(response.body);
      }
      //CODIGO DE ERROR EN CASO DE QUE ALGO FALLE
    } else {
      return response.statusCode;
    }
    //SI EL TEXTFIELD ESTÁ VACÍO
  }
}
