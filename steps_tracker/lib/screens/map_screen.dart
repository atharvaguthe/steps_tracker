import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/sensor_service.dart'; // Links to the service file

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final SensorService _sensors = SensorService();
  final List<LatLng> _path = [];
  int _steps = 0;
  bool _isRecording = false;

  void _handleToggle() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _sensors.startTracking(
        onStepUpdate: (s) => setState(() => _steps = s),
        onLocationUpdate: (loc) => setState(() => _path.add(loc)),
      );
    } else {
      _sensors.stopTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step & Path Tracker")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(0, 0),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourname.steptracker',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: _path, color: Colors.blue, strokeWidth: 4),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Steps: $_steps | Points: ${_path.length}"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleToggle,
        label: Text(_isRecording ? "STOP" : "START"),
        backgroundColor: _isRecording ? Colors.red : Colors.green,
      ),
    );
  }
}
