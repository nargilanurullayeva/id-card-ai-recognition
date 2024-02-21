import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data.dart';
import 'package:my_app/listt.dart';

class Users {
  Users(this.id_number, this.name, this.surname, this.gender, this.birth_date);
  final String id_number;
  final String name;
  final String surname;
  final String gender;
  final String birth_date;
}

ekle(File file, Map map) async {
  try {
    var filename = map['id_number'];
    var imagefile = FirebaseStorage.instance
        .ref()
        .child("id_card_img")
        .child("/$filename.jpg");
    UploadTask task = imagefile.putFile(file);
    TaskSnapshot snapshot = await task;
    final card_db = FirebaseDatabase.instance.ref("users/$filename");
    await card_db.set(map).whenComplete(() {
      print("veri eklendi");
    });
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

readCardDb() async {
  usersList = [];
  final card_db = FirebaseDatabase.instance.ref();
  final snapshot = await card_db.child('users').get();
  if (snapshot.exists) {
    Map<dynamic, dynamic> valfromdb = snapshot.value as Map<dynamic, dynamic>;

    valfromdb.forEach((key, value) {
      usersList.add(Users(value["id_number"], value["name"], value["surname"],
          value["gender"], value["birth_date"]));
      print(value["surname"]);
      print(usersList.toList());
    });
  } else {
    print('No data available.');
  }
}
