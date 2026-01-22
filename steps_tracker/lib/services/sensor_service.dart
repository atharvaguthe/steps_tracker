import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:latlong2/latlong.dart';

class SensorService {
  StreamSubscription<StepCount>? _stepSub;
  StreamSubscription<Position>? _locSub;

  void startTracking({
    required Function(int) onStepUpdate,
    required Function(LatLng) onLocationUpdate,
  }) {
    // Listen to Step Counter
    _stepSub = Pedometer.stepCountStream.listen((event) {
      onStepUpdate(event.steps);
    });

    // Listen to GPS
    _locSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((pos) {
      onLocationUpdate(LatLng(pos.latitude, pos.longitude));
    });
  }

  void stopTracking() {
    _stepSub?.cancel();
    _locSub?.cancel();
  }
}