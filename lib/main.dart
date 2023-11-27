// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:senior_design/pages/homePage.dart';

import 'dart:async';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  //print all cameras
  for (CameraDescription camera in cameras) {
    print("Camera name: ${camera.name}");
  }

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
        theme: ThemeData.dark(),
        home: HomePage(
          camera: firstCamera,
        )),
  );
}
