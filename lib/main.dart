import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:senior_design/pages/homePage.dart';
import 'package:senior_design/pages/takePicturePage.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

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
