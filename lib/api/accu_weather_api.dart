import 'dart:convert';

import 'package:flutter_hello/model/city.dart';
import 'package:http/http.dart' as http;

class AccuWeatherApi {
  static const _API_KEY = "UR5yIEk6kRN8jyA3NKfiX09cLkJunzE9";

  Future<List<City>> getCities(int maxItem) async {
    final url =
        "http://dataservice.accuweather.com/locations/v1/topcities/$maxItem?apikey=$_API_KEY&language=en-us&details=false";
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);
    return City.fromJsonList(responseJson);
  }
}
