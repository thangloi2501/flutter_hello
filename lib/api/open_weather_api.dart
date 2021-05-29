import 'dart:convert';

import 'package:flutter_hello/model/current_weather.dart';
import 'package:http/http.dart' as http;

class OpenWeatherApi {
  static const _API_KEY = "8e36389b92cf69879c4bbf5647fa0ed9";

  Future<CurrentWeather> getCurrentWeather(String location) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$location&APPID=$_API_KEY";
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);
    return new CurrentWeather.fromJson(responseJson);
  }
}
