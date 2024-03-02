import 'package:flutter/material.dart';

import '../model/weather_data.dart';
import '../services/weatherlink_data.dart';

class WeatherViewModel extends ChangeNotifier {
  late WeatherData _weatherData;

  bool isLoading = true;

  IconData get icon {
    return Icons.wb_sunny_outlined;
  }

  int get currentTemp {
    return _weatherData.temperature;
  }

  int get feelsLike {
    return _weatherData.feelsLikeTemperature;
  }

  String get windDirection {
    var dir = _weatherData.windDirection;
    const degree360 = 360;

    List<String> directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];

    //make sure direction (degree) stay positive
    while (dir < 0) {
      dir += degree360;
    }

    //get the mod
    dir %= degree360;

    //convert degree to index
    int index = (dir ~/ 22.5).toInt();

    return directions[index];
  }

  int get windSpeed {
    return _weatherData.windSpeed;
  }

  int get humidity {
    return _weatherData.humidity.round();
  }

  DateTime get lastUpdated {
    return _weatherData.lastUpdated;
  }

  WeatherViewModel() {
    refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();

    final weatherFuture = WeatherlinkData().getWeather();
    final timingFuture = Future.delayed(const Duration(milliseconds: 800));
    _weatherData = (await Future.wait([weatherFuture, timingFuture]))[0];

    isLoading = false;
    notifyListeners();
  }

  Future<String> getStationId() {
    return WeatherlinkData().getStationId();
  }
}
