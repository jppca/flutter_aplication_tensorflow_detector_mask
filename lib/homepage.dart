/*Home Page*/
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

//My imports
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //required instances
  late CameraImage cameraImage;
  late CameraController cameraController;

  //required vars
  bool isWorking = false;
  bool isCamera = false;
  String result = "";

//start the camera and load whatever is needed
  initCamera(int cameraSelected) {
    cameraController =
        CameraController(camera![cameraSelected], ResolutionPreset.max);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController.startImageStream((imageFromStream) {
            if (!isWorking) {
              isWorking = true;
              cameraImage = imageFromStream;
              runModelOnFrame();
            }
          });
        });
      }
    });
  }

//run the model on each captured frame
  runModelOnFrame() async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 1,
      threshold: 0.1,
      asynch: true,
    );
    result = "";

    recognitions?.forEach((element) {
      result += element["label"] + "\n";
    });

    setState(() {
      result;
      isWorking = false;
    });
  }

//tensorflow lite model load
  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  void initState() {
    super.initState();
    initCamera(0);
    isCamera = false;
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: result.isEmpty
                ? const Text("ENFOQUE EL ROSTRO")
                : Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      result,
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
            centerTitle: true,
          ),
          body: Container(
            child: (!cameraController.value.isInitialized)
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: CameraPreview(cameraController),
                  ),
          ),
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (!isCamera) {
                  isCamera = true;
                  initCamera(1);
                } else {
                  isCamera = false;
                  initCamera(0);
                }
              });
            },
            child: const Icon(Icons.cameraswitch_outlined),
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }
}
