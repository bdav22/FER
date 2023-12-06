import 'package:flutter/material.dart';

class LearnMorePage extends StatelessWidget {
  const LearnMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 233, 254),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: const Text(
          'FER and Our Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                '     Facial Expression Recognition is a rapidly growing and extremely beneficial technology. There are many applications for expression recognition, including security, healthcare, disability assistance, and mood classification. The problem that facial expression recognition solves is the inability for a computer system to recognize feelings and emotion. Facial expression recognition provides a way for a computer to identify and record emotions via deep learning. Our goal is to use this software to create a mobile application capable of recognizing facial expressions in photo or video.',
                style: TextStyle(color: Colors.blue.shade900, fontSize: 16),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                  '     Facial Recognition has increased in popularity over the past few years. This is due to an increase in home and mobile devices being equipped with IR depth sensors that are capable of performing 3D scans of faces to determine shape, structure, and other fine details. This technology can be used by anyone, whether it is to unlock a phone, identify a disability, or identify different expressions. This benefits people who prioritize easy access to secure systems via biometrics, anybody who would like to study different emotions, and many more.',
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 16)),
              const SizedBox(
                height: 15,
              ),
              Text(
                  '     In our design, we aim to develop a multi-platform mobile application using Dart and the Flutter Framework. This application will provide an intuitive UI to take a photo, which will then be processed by a custom Python script that sends the image through a deep neural network which identifies the emotion. The neural network will be trained by a large data set of different expressions. The script will return the expression which will then be displayed on the screen with the picture. Our aim is to expand upon this software to then recommend music of the same emotion detected.',
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
