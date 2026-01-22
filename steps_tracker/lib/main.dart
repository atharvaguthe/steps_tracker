import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/map_screen.dart'; // Links to your UI file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request all needed permissions at once
  await [
    Permission.location, 
    Permission.activityRecognition
  ].request();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapScreen(),
  ));
}