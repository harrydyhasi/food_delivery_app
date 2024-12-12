import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidgetController extends GetxController {
  var currentPosition =
      const LatLng(10.8231, 106.6297).obs; // Default to HCM City, Vietnam

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      log('Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        log('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        log('Permission after request: $permission');
        if (permission == LocationPermission.denied) {
          log('Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permission permanently denied. Please enable it in settings.');
        return;
      }

      log('Fetching current position...');
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          log('Timeout occurred while fetching location');
          // Option 1: Throw an exception
          throw TimeoutException('Location request timed out');
        },
      );

      log('Position: ${position.latitude}, ${position.longitude}, Accuracy: ${position.accuracy}');
      currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      log('Error occurred while getting location: $e');
    }
  }
}
