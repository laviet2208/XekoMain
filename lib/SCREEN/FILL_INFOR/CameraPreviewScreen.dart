import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewScreen extends StatefulWidget {
  final CameraController controller;

  CameraPreviewScreen({required this.controller});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: CameraPreview(widget.controller),
            ),
            ElevatedButton(
              onPressed: () {
                _takePictureAndReturn(context);
              },
              child: Text('Chụp ảnh'),
            ),
          ],
        ),
      ),
    );
  }

  void _takePictureAndReturn(BuildContext context) async {
    try {
      final XFile file = await widget.controller.takePicture();
      Navigator.of(context).pop(file.path);
    } catch (e) {
      print(e);
    }
  }
}
