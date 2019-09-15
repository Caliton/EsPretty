import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  List<CameraDescription> cameras;

  CameraController controller;

  Future<List<CameraDescription>> _listCamera() async {
    final camera = await availableCameras();
    return camera;
  }

  @override
  initState() {
    super.initState();
    Future.sync(_listCamera).then((List<CameraDescription> camera) {
      setState(() {
        cameras = camera;
        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text(
                'Vish! A Camera ainda não conseguiu se carregar!\n Volte e tente mais uma vez.'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotinha'),
      ),
      body: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller)),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            String text = '';
            final imagePath = join(
              (await getApplicationDocumentsDirectory()).path,
              'photo-${DateTime.now()}.png',
            );
            await controller.takePicture(imagePath);

            final TextRecognizer textRecognizer =
                FirebaseVision.instance.textRecognizer();
            final FirebaseVisionImage visionImage =
                FirebaseVisionImage.fromFile(File(imagePath));
            final VisionText visionText =
                await textRecognizer.detectInImage(visionImage);
            text = visionText.text;

            Navigator.pop(context, [imagePath, text]);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
