import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

List todos = [];

class Database {
  // ignore: deprecated_member_use
  final database = FirebaseDatabase(
    databaseURL:
        'https://todo-3e19e-default-rtdb.asia-southeast1.firebasedatabase.app/',
    app: Firebase.app(),
  ).ref();

  addTodo(String title, description, String? image) async {
    try {
      var key = database.child('todos').push().key;
      await database.child('todos').child(key!).set({
        'title': title,
        'description': description,
        'image': image ?? '',
        'key': key,
        "checked": false,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        Get.snackbar('Success', 'Todo added successfully');
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  getTodos() async {
    try {
      await database.child('todos').once().then((value) {
        Map data = value.snapshot.value as Map;
        log(data.toString());
        todos = data.values.toList();
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  updateTodo(key, value) async {
    try {
      await database.child('todos').child(key).update({
        'checked': value,
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  deleteTodo(key) async {
    try {
      await database.child('todos').child(key).remove();
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
