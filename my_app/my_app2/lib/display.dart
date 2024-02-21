import 'package:flutter/material.dart';
import 'package:my_app/data.dart';
import 'package:my_app/database.dart';
import 'package:my_app/listt.dart';
import 'package:my_app/main.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_formfield.dart';

class DisplayData extends StatefulWidget {
  final Users data;
  final String imageURL;
  const DisplayData({super.key, required this.imageURL, required this.data});
  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Content"),
          primary: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_right),
              tooltip: 'Home Page',
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                readCardDb();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.09),
                child: Image.network(widget.imageURL),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: "  Id Number:   ${widget.data.id_number}",
                  readOnly: true,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: "  Name:   ${widget.data.name}",
                  readOnly: true,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: "  Surname:   ${widget.data.surname}",
                  readOnly: true,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: "  Gender:   ${widget.data.gender}",
                  readOnly: true,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: "  Birth Date:   ${widget.data.birth_date}",
                  readOnly: true,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
