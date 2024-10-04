import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/platform/networking/weather_service.dart';

class WeatherController extends GetxController {
  var locationMessage = 'Getting location...'.obs;
  var weatherMessage = 'Fetching weather...'.obs;

  final WeatherService _weatherService = WeatherService();

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage.value = 'Location services are disabled.';
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMessage.value = 'Location permissions are denied.';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationMessage.value = 'Location permissions are permanently denied, we cannot request permissions.';
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      locationMessage.value = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      await fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      locationMessage.value = 'Error getting location: $e';
    }
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    try {
      WeatherResponse weatherData = await _weatherService.fetchWeather(latitude, longitude);
      double temperature = weatherData.data.values.temperature;

      weatherMessage.value = 'Temp: $temperature°C';
    } catch (e) {
      weatherMessage.value = 'Error fetching weather: $e';
    }
  }
}