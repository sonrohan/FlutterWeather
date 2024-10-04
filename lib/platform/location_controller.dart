import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var locationMessage = "Getting location...".obs;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
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
      locationMessage.value =
          'Location permissions are permanently denied, we cannot request permissions.';
      return;
    }

    // If permissions are granted, get the position
    try {
      Position position = await Geolocator.getCurrentPosition();
      locationMessage.value =
          "Lat: ${position.latitude}, Lon: ${position.longitude}";
    } catch (e) {
      locationMessage.value = e.toString();
    }
  }
}