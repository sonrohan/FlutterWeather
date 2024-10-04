import 'package:dio/dio.dart';

class WeatherService {
  final Dio _dio = Dio();

  final String _apiKey = 'uFPgqdV5WLEMCChYqEfNAkEdsA3iOpRX';
  final String _apiUrl = 'https://api.tomorrow.io/v4/weather/realtime';

  Future<WeatherResponse> fetchWeather(double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        _apiUrl,
        queryParameters: {
          'location': '$latitude,$longitude',
          'apikey': _apiKey,
          'units': 'imperial',
        },
      );

      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.statusCode}, ${e.response?.data}');
      } else {
        throw Exception('Error: ${e.message}');
      }
    }
  }
}

class WeatherResponse {
  final WeatherData data;

  WeatherResponse({
    required this.data,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      data: WeatherData.fromJson(json['data'])
    );
  }
}

class WeatherData {
  final String time;
  final WeatherValues values;

  WeatherData({
    required this.time,
    required this.values,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      time: json['time'],
      values: WeatherValues.fromJson(json['values']),
    );
  }
}

class WeatherValues {
  final double temperature;
  final double apparentTemperature;

  WeatherValues({
    required this.temperature,
    required this.apparentTemperature,
  });

  factory WeatherValues.fromJson(Map<String, dynamic> json) {
    return WeatherValues(
      temperature: json['temperature'],
      apparentTemperature: json['temperatureApparent'],
    );
  }
}