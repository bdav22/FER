import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:senior_design/pages/takePicturePage.dart';

class HomePage extends StatelessWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 233, 254),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Image.asset('lib/assets/FER.png'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TakePictureScreen(camera: camera)));
                    },
                    child: Text(
                      'Take A Photo',
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
