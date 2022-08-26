import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:path_provider/path_provider.dart' as path_provider;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? image;
  final ImagePicker _imagePicker = ImagePicker();
  Future selectImage(option) async {
    XFile? pickedFile;
    if (option == 1) {
      pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "Imagen no selecionada");
      }
    });
    //Navigator.of(context).pop();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return _buidScaffold(context);
  }

  Widget _buidScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imagenes"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _getOptions(),
                const SizedBox(
                  height: 30,
                ),
                _showImage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () => {selectImage(1)},
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: Colors.black,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Column(children: const [
                Icon(
                  Icons.camera_alt,
                  color: Colors.redAccent,
                  size: 60,
                ),
                Text(
                  "Cámara",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textScaleFactor: 1.5,
                ),
              ]),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {selectImage(2)},
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: Colors.black,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Column(children: const [
                Icon(
                  Icons.image,
                  color: Colors.redAccent,
                  size: 60,
                ),
                Text(
                  "Galeria",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textScaleFactor: 1.5,
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showImage() {
    Widget imgOut = const Center();
    if (image != null) {
      imgOut = Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Colors.white,
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                    aspectRatio: 18.0 / 13.0,
                    child: Image.file(image!, fit: BoxFit.fill)),
              ),
              Center(
                child: ButtonBar(
                  children: <Widget>[
                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(),
                    TextButton(
                      child: Column(
                        children: const [Icon(Icons.upload), Text("Enviar")],
                      ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });

                        ///_sendImage(image!);
                      },
                    ),
                    Column(
                      children: [
                        TextButton(
                          child: Column(
                            children: const [
                              Icon(Icons.cancel),
                              Text("Cancelar")
                            ],
                          ),
                          onPressed: () {
                            image = null;
                            loading = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return imgOut;
  }
}
