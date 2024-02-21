import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/data.dart';
import 'package:my_app/database.dart';
//import 'package:my_app/listData.dart';
import 'package:my_app/listt.dart';
import 'package:my_app/upload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Id Card Reader',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  Future alresim() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  Future<void> resimAl() async {
    await getImage();
    setState(() {
      selectedImage;
    });
  }

  Future<bool> fetchData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous function
    final cvp = await uploadImage();

    setState(() {
      isLoading = false;
    });
    return cvp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 255, 255, 255), width: 2),
              ),
              child: Center(
                child: selectedImage == null
                    ? const Text("Please select a image to upload")
                    : Image.file(selectedImage!),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Upload button
                TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () async {
                      final cvp = await fetchData();
                      if (cvp == true) {
                        UploadData uploadData =
                            UploadData(imageFile: selectedImage, map: map);
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadImage(
                                      uploadData: uploadData,
                                    )));
                      } else {
                        // ignore: prefer_const_constructors
                        final snackBar = SnackBar(
                          content: const Text('TC Kimlik Değildir!'),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        // ignore: avoid_print
                        print("map is empty");
                      }
                    },
                    icon: const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Upload",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  width: 20,
                ),

                /// List Button
                TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () async {
                      await readCardDb();
                      print(usersList);
                      if (usersList.isNotEmpty) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => ListVal()));
                      }
                    },
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "List",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            if (isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(), // Display a linear progress indicator
                  SizedBox(height: 8),
                  Text('Loading data...'), // Display a custom loading message
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resimAl,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
