import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_data.dart';

//       Class: Mobile Application Development
//        Name: Dat Tran
//        Date: March 2, 2024
//    Homework: Week 9
//      Points: 100 pts
//         Due: March 30, 2024

// Estimate Completion time: 3 Hours
// Actual Completition time: 2 Hours

class WeatherlinkData {
  static const _apiKey = '';
  static const _apiSecret = '';

  Map<String, String> headers = {
    'X-Api-Secret': _apiSecret,
    'Content-Type': 'application/json'
  };

  final httpClient = http.Client();

  Future<String> getStationId() async {
    const requestUrl =
        'https://api.weatherlink.com/v2/stations?api-key=$_apiKey';

    final response =
        await httpClient.get(Uri.parse(requestUrl), headers: headers);

    return _parseStationId(response.body);
  }

  Future<WeatherData> getWeather() async {
    var stationId = await getStationId();

    String apiUrl =
        "https://api.weatherlink.com/v2/current/$stationId?api-key=$_apiKey";

    final response = await httpClient.get(Uri.parse(apiUrl), headers: headers);

    return WeatherData.fromWeatherlink(jsonDecode(response.body));
  }

  String _parseStationId(String body) {
    final json = jsonDecode(body);
    try {
      return json['stations'].first['station_id'].toString();
    } on NoSuchMethodError {
      return 'Error';
    }
  }
}
