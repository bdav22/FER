import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  bool loading = false;

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

  // Set up the URL for your server endpoint
  String serverUrl = 'http://hoangdao297.pythonanywhere.com/get_result';

  Future<String> getFromServer() async {
    try {
      print('running');
      // Make the GET request
      final response = await http.get(Uri.parse(serverUrl));

      // Check for successful response
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception(
            'Failed to get data from server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error sending GET request: $error');
    }
  }

  sendImage(File image) async {
    try {
      var uri = Uri.parse(serverUrl);
      var request = http.MultipartRequest('POST', uri);

      // Add image file part
      var part = http.MultipartFile.fromBytes(
        'img',
        image.readAsBytesSync(),
        filename: image.path.split('/').last,
      );
      request.files.add(part);

      // Execute the request
      print('sending');
      var response = await request.send();
      var responseBody = await response.stream.transform(utf8.decoder).join();

      // Handle response based on status code

      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(responseBody);

        // Print the parsed JSON data
        print('Image sent successfully. JSON response: $parsedJson');
        return parsedJson;
      } else {
        print('Unable to determine face. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending image: $error');
    }
  }

  Future getExpression(url) async {
    http.Response Response = await http.get(url);
    print(Response.body);
    return Response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
                              setState(() {
                                loading = true;
                              });
                              await _initializeControllerFuture;
                              final image = await _controller.takePicture();
                              if (!mounted) return;
                              // //send image to http
                              // sendImage(image.path);
                              // //get expression from http
                              // getExpression(serverUrl);

                              //adding heic to jpg converter and python script
                              // String? jpegPath =
                              //     await HeicToJpg.convert(image.path);

                              var emotion = await sendImage(File(image.path));
                              setState(() {
                                loading = false;
                              });
                              // getExpression(serverUrl);
                              emotion != null
                                  ? await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayPictureScreen(
                                                imagePath: image.path,
                                                emotion: emotion['emotion']),
                                      ),
                                    )
                                  : Fluttertoast.showToast(
                                      msg:
                                          "Unable to detect face. Please try again",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.7),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                              ;
                              // getExpression(serverUrl);
                            } catch (e) {}
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
      ),
      loading == true
          ? Scaffold(
              backgroundColor: Colors.black.withOpacity(0.5),
              body: const Center(child: CircularProgressIndicator()))
          : const SizedBox(width: 0),
    ]);
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String emotion;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.emotion});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Woohoo! You Are ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      emotion,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
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

// Future<File> fixExifRotation(String imagePath) async {
//     final originalFile = File(imagePath);
//     List<int> imageBytes = await originalFile.readAsBytes();

//     final originalImage = img.decodeImage(imageBytes);

//     final height = originalImage.height;
//     final width = originalImage.width;

//     // Let's check for the image size
//     // This will be true also for upside-down photos but it's ok for me
//     if (height >= width) {
//       // I'm interested in portrait photos so
//       // I'll just return here
//       return originalFile;
//     }

//     // We'll use the exif package to read exif data
//     // This is map of several exif properties
//     // Let's check 'Image Orientation'
//     final exifData = await readExifFromBytes(imageBytes);

//     img.Image fixedImage;

//     if (height < width) {
//       logger.logInfo('Rotating image necessary');
//       // rotate
//       if (exifData['Image Orientation'].printable.contains('Horizontal')) {
//         fixedImage = img.copyRotate(originalImage, 90);
//       } else if (exifData['Image Orientation'].printable.contains('180')) {
//         fixedImage = img.copyRotate(originalImage, -90);
//       } else if (exifData['Image Orientation'].printable.contains('CCW')) {
//         fixedImage = img.copyRotate(originalImage, 180);
//       } else {
//         fixedImage = img.copyRotate(originalImage, 0);
//       }
//     }

//     // Here you can select whether you'd like to save it as png
//     // or jpg with some compression
//     // I choose jpg with 100% quality
//     final fixedFile =
//         await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

//     return fixedFile;
//   }
