import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherApiClient{
  Future<Weather>? getCurrentWeather(String? location) async{
    var endpoint = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$location&appid=21cbaef043e9204dfe27bc8e85381067&units=metric&lang=ru");
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    return Weather.fromJson(body);
  }
}