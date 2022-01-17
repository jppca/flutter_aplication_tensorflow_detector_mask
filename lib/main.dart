/*Main*/
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

//My imports
import 'package:flutter_aplication_tensorflow_detector_mask/homepage.dart';
import 'package:flutter_aplication_tensorflow_detector_mask/splachpage.dart';

List<CameraDescription>? camera;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splashpage(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Detector de Mascarilla',
            home: HomePage(),
          );
        }
      },
    );
  }
}
