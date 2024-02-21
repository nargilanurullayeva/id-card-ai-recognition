import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:my_app/database.dart';
import 'package:my_app/display.dart';
import 'package:my_app/main.dart';

List<Users> usersList = [];
Future<String> getImageURL(String imageName) async {
  try {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("id_card_img")
        .child(imageName);
    String imageURL = await ref.getDownloadURL();
    return imageURL;
  } catch (e) {
    print('Error getting image from Firebase Storage: $e');
    return "gelmedi resim";
  }
}

class ListVal extends StatefulWidget {
  ListVal({super.key});
  @override
  State<ListVal> createState() => _ListValState();
}

class _ListValState extends State<ListVal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> loadImage(String imageName) async {
    String imageURL = await getImageURL(imageName);
    if (imageURL != null) {
      // Use the imageURL to display or manipulate the image
      print('Image URL: $imageURL');
      return imageURL;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Data"),
        primary: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_right),
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          DataTable(
            columnSpacing: 20.0,
            dataRowHeight: 50.0,
            headingRowColor: MaterialStatePropertyAll(Colors.green[200]),
            columns: [
              DataColumn(label: Text('Id Number')),
              DataColumn(label: Text('Name Surname')),
              DataColumn(label: Text('Birth Date')),
              DataColumn(label: Text(" "))
            ],
            rows: usersList.asMap().entries.map((entry) {
              int index = entry.key;
              Users person = entry.value;

              bool isEven = index % 2 == 0;
              Color color =
                  isEven ? Colors.white : Color.fromARGB(255, 223, 255, 219);

              return DataRow(
                color: MaterialStateColor.resolveWith((states) => color),
                cells: [
                  DataCell(Text(person.id_number)),
                  DataCell(Text(person.name + " " + person.surname)),
                  DataCell(Text(person.birth_date)),
                  DataCell(
                    InkWell(
                      onTap: () async {
                        // Handle the cell tap or click event
                        print("Cell tapped: ${person.name}");
                        var imageURL =
                            await getImageURL(person.id_number + ".jpg");
                        print("resim " + imageURL.toString());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayData(
                                      imageURL: imageURL.toString(),
                                      data: person,
                                    )));
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  )
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
