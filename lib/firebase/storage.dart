import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

String? imageUrl;

class Storage {
  static uploadImage(image) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child('images/${image.path.split('/').last}')
          .putFile(image)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          imageUrl = value;
        });
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
