import 'package:flutter/material.dart';
import 'package:my_app/data.dart';
import 'package:my_app/database.dart';
import 'package:my_app/main.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_formfield.dart';

class ReadImage extends StatefulWidget {
  final UploadData uploadData;
  const ReadImage({super.key, required this.uploadData});
  @override
  State<ReadImage> createState() => _ReadImageState();
}

class _ReadImageState extends State<ReadImage> {
  final _name = TextEditingController();
  final _idNumber = TextEditingController();
  final _surname = TextEditingController();
  final _gender = TextEditingController();
  final _birthDate = TextEditingController();
  String get name => _name.text.trim();
  String get surname => _surname.text.trim();
  String get idNumber => _idNumber.text.trim();
  String get gender => _gender.text.trim();
  String get birthDate => _birthDate.text.trim();

  updateMap() {
    map = {
      'id_number': idNumber.toString(),
      'name': name.toString(),
      'surname': surname.toString(),
      'gender': gender.toString(),
      'birth_date': birthDate.toString(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("uploading...");
    _name.text = widget.uploadData.map!['name'].toString();
    _surname.text = widget.uploadData.map!['surname'].toString();
    _idNumber.text = widget.uploadData.map!['id_number'].toString();
    _gender.text = widget.uploadData.map!['gender'].toString();
    _birthDate.text = widget.uploadData.map!['birth_date'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Save Data"),
          primary: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_right),
              tooltip: 'Home Page',
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
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
                child: Image.file(widget.uploadData.imageFile!),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Id Number",
                hintText: "idnumber",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _idNumber,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Name",
                hintText: "username",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _name,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Surname",
                hintText: "surname",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _surname,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Gender",
                hintText: "gender",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _gender,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Birth Date",
                hintText: "birthdate",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _birthDate,
              ),
              const SizedBox(
                height: 16,
              ),
              AuthButton(
                onTap: () async {
                  var mesaj = "";
                  updateMap();
                  final cvp = await ekle(selectedImage!, map);
                  if (cvp == true) {
                    mesaj = "Data added successfully";
                  } else {
                    mesaj = "Error loading";
                  }
                  final snackBar = SnackBar(
                    content: Text(mesaj.toString()),
                    duration: const Duration(seconds: 20),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                        // Some code to undo the change.
                      },
                    ),
                  );

                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                text: 'Save',
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
  }
}
