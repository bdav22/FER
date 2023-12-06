import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  //keep track of what camera is being used, 0 for back 1 for front
  int _currentCameraIndex = 1;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  //method to toggle front vs back camera
  Future<void> _toggleCamera() async {
    //get all available cameras
    final cameras = await availableCameras();
    setState(() {
      //circular transition between the cameras
      _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
    });

    //get the new camera
    final newCamera = cameras[_currentCameraIndex];

    //dispose of the old controller

    //create a new controller
    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
    );

    //init it
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Take A Photo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(alignment: Alignment.bottomCenter, children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: CameraPreview(_controller),
                  ),
                ],
              ),
              Container(
                color: Colors.blue.shade900.withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: CircleBorder(),
                            shadowColor: Colors.blue,
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.blue.shade100),
                        onPressed: () async {
                          try {
                            await _initializeControllerFuture;
                            final image = await _controller.takePicture();
                            if (!mounted) return;
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPictureScreen(imagePath: image.path),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.blue,
        foregroundColor: Colors.blue.shade900,
        backgroundColor: Colors.white,
        onPressed: _toggleCamera,
        child: const Icon(Icons.switch_camera),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 233, 254),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FER Result',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              color: Colors.transparent,
              width: displayWidth,
              height: displayHeight,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.fill,
              )),
          Container(
            color: Colors.blue.shade900.withOpacity(0.5),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Woohoo! You Are ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "Happy",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
