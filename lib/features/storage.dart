import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloudinary_flutter/image/cld_image.dart';
// import 'package:cloudinary_flutter/cloudinary_object.dart';
// import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:uuid/uuid.dart';

final storageMethodsProvider = Provider(
  (ref) => StorageMethods(
      auth: FirebaseAuth.instance, storage: FirebaseStorage.instance),
);

class StorageMethods {
  const StorageMethods({required this.auth, required this.storage});
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, File file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = storage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadPost(File file) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dn84hbcew/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'qwertyuio'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url'];
    }
    return "Failed";
  }
}
