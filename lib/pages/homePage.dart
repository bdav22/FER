import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_design/pages/learnMorePage.dart';
import 'package:senior_design/pages/takePicturePage.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double buttonRadius = 25;

  List expressions = [
    ['lib/assets/happy.png', 'happy'],
    ['lib/assets/sad.png', 'sad'],
    ['lib/assets/angry.png', 'angry'],
    ['lib/assets/surprised.png', 'surprised'],
    ['lib/assets/neutral.png', 'neutral'],
    ['lib/assets/Disgust.png', 'disgust']
  ];
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 233, 254),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Image.asset('lib/assets/FER.png'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Container(
          //   height: displayHeight,
          //   child: Image.asset(
          //     'lib/assets/faceBackground.jpg',
          //     fit: BoxFit.cover,
          //     opacity: AlwaysStoppedAnimation(0.5),
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LearnMorePage(),
                      ));
                    },
                    child: Ink(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      width: displayWidth - 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(buttonRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Learn More About FER',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal,
                                fontSize: 17),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade500,
                          )
                        ],
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  'Detectable Expressions',
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                    itemCount: expressions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                          width: 150,
                          margin:
                              EdgeInsetsDirectional.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                expressions[index][0],
                                width: 110,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                expressions[index][1],
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        )),
              ),
              const SizedBox(height: 25),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   height: 2,
              //   color: Color.fromRGBO(200, 200, 254, 1),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TakePictureScreen(camera: widget.camera)));
                    },
                    child: Ink(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      width: displayWidth - 50,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(buttonRadius)),
                      child: const Center(
                        child: Text(
                          'Take A Photo',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
