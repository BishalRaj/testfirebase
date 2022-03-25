import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyFirebaseApp());
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);

  @override
  State<MyFirebaseApp> createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("lado"),
        ),
        body: Row(
          children: [
            ElevatedButton(onPressed: selectFile, child: Text('Get Image')),
            ElevatedButton(onPressed: uploadFile, child: Text('Upload File'))
          ],
        ),
      ),
    );
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => _file = File(path));
  }

  void uploadFile() {
    if (_file == null) return;
    final fileName = Path.basename(_file!.path);
    final destination = 'files/$fileName';

    uploadImageToFIrebase(destination, _file!);

    // FirebaseApi.uploadFile(destination, _file!);
  }

  static UploadTask? uploadImageToFIrebase(destination, _file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(_file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

// class FirebaseApi {
//   static UploadTask? uploadFile(String destination, File file) {
//     try {
//       final ref = FirebaseStorage.instance.ref(destination);
//       return ref.putFile(file);
//     } on FirebaseException catch (e) {
//       return null;
//     }
//   }
// }
