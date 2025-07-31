import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:io';

class CameraScreen2 extends StatefulWidget {
  @override
  _CameraScreen2State createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  bool loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      print("Modelo cargado con éxito.");
    } catch (e) {
      print("Error al cargar el modelo: $e");
    }
  }

  Future<void> classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        _output = output;
        loading = false;
      });
    } catch (e) {
      print("Error al clasificar la imagen: $e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      loading = true;
    });
    classifyImage(_image!);
  }

  Future<void> pickGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      loading = true;
    });
    classifyImage(_image!);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            loading
                ? Container(
                    width: 300,
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/camera.png'),
                        SizedBox(height: 50),
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: _image != null ? Image.file(_image!) : Container(),
                        ),
                        SizedBox(height: 20),
                        _output != null
                            ? Text(
                                '${_output![0]['label']}',
                                style: TextStyle(fontSize: 20),
                              )
                            : Container(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: pickGalleryImage,
                  child: Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}