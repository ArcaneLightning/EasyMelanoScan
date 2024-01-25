import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pytorch_mobile/model.dart';
// import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melanoma_detection/camera_upload/classifier.dart';
import 'package:melanoma_detection/center/center.dart';
import 'package:melanoma_detection/camera_upload/classifier.dart';
// import 'package:pytorch_lite/pytorch_lite.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

const _labelsFileName = 'assets/labels/labels.txt';
const _modelFileName = 'models/vgg16.tflite';
class _UploadScreenState extends State<UploadScreen> {
  
  File ? _selectedImage;

  bool _isAnalyzing = false;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _label = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier? _classifier;


  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier;
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto() async {
    final pickedFile = _selectedImage;

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);

    _analyzeImage(imageFile);
  }


  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier!.predict(imageInput);

    final result = resultCategory[0].score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final Label = resultCategory[0].label;
    final accuracy = resultCategory[0].score;

    final softmax = _classifier!.Softmax([resultCategory[0].score.abs(), resultCategory[1].score.abs()]);
    final f_acc = double.parse(softmax[0].toStringAsFixed(1)) * 100;

    final maxAcc = _classifier!.getAcc([resultCategory[0].score.abs(), resultCategory[1].score.abs()]);
    final acc = double.parse(maxAcc[0].toStringAsFixed(1)) * 100;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _label = Label;
      _accuracy = acc;
    });

    addData(
      id: FirebaseAuth.instance.currentUser!.uid,
      pl: '${_selectedImage!.path}-$_label',
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Run Classification",
        onPressed: (_selectedImage == null) ? null : () => _onPickPhoto(),
        child: const Icon(FontAwesomeIcons.play),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(title: const Text("Camera/Upload"), centerTitle: true, backgroundColor: Colors.white,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _label != "" ? Text(_label.toUpperCase(), style: TextStyle(fontSize: 50, color: _label == "malignant" ? Colors.red : Colors.green)) : const Text("No Prediction Yet"),
            _accuracy != 0.0 ? Text("Confidence: ${_accuracy}%") : const Text("No confidence yet!"),
            _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please Select an Image!"),
            const SizedBox(height: 25),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  icon: const Icon(FontAwesomeIcons.camera),
                  label: const Text("Camera")
                ),
                const SizedBox(
                  width: 25
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(FontAwesomeIcons.file),
                  label: const Text("File Upload")
                ),
              ],
            ),
            const SizedBox(height: 25)
          ],
        )
      )
    );
  }

  Future _pickImage(ImageSource source) async {
    setState(() {
      _label = "";
      _accuracy = 0.0;
    });
    final returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) {return;}

    var croppedImage = await ImageCropper().cropImage(sourcePath: returnedImage.path);
    if (croppedImage == null) {return;}

    final croppedImagePath = File(croppedImage.path);
    img.Image image = img.decodeImage(croppedImagePath.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 100);  // Adjust quality as needed
    File resizeFile = croppedImagePath;
    resizeFile.writeAsBytesSync(compressedBytes);
    

    setState(() {
      _selectedImage = resizeFile;
    });
  }

  Future _uploadFile(String path, String disease) async {
    final ref = FirebaseStorage.instance.ref()
      .child('images')
      .child(disease + DateTime.now().toIso8601String() + basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    debugPrint(fileUrl);
  }

  Future addData({required String id, required String pl}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    docUser.update({
      'picturesLabels': FieldValue.arrayUnion([pl]),
    });
  }

  String? documentsPath;
  String? prediction;

}