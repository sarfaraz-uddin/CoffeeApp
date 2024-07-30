import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/components/text_field.dart';
import 'package:coffeeapp/model/coffee.dart';
import 'package:coffeeapp/pages/home_page.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.coffee});
  final Coffee coffee;

  @override
  State<EditPage> createState() => _AddpageState();
}

class _AddpageState extends State<EditPage> {
  XFile? image;

  void showToastAndNavigate(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController(text: widget.coffee.name);
    final TextEditingController price = TextEditingController(text: widget.coffee.price);
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      "Edit items",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () async {
                    // Show a confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Item"),
                        content: Text("Are you sure you want to delete this item?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Perform deletion
                              await FirebaseFirestore.instance.collection('coffee').doc(widget.coffee.name).delete();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ),
              Stack(
                children: [
                  image == null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.cyan[300], image: DecorationImage(image: NetworkImage(widget.coffee.imagePath), fit: BoxFit.contain)),
                        )
                      : Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 80,
                    child: TextButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final img = await picker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            image = img;
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upload a photo',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NormalTextField(
                   readonly:  true,
                  controller: name,
                  text: 'name',
                  iconData: Icons.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NormalTextField(
                  controller: price,
                  text: 'Price',
                  iconData: Icons.money,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                  await firebaseFirestore.collection('coffee').doc(widget.coffee.name).update(
                    {"name": name.text, "image": widget.coffee.imagePath, "price": price.text},
                  ).then((value) {
                    if (image == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  });
                  if (image != null) {
                    var photo = File(image!.path);

                    UploadTask? uploadTask;
                    var ref = FirebaseStorage.instance.ref().child('coffee').child(widget.coffee.name);
                    ref.putFile(photo);
                    uploadTask = ref.putFile(photo);
                    final snap = await uploadTask.whenComplete(() {});
                    final urls = await snap.ref.getDownloadURL();
                    var items = firebaseFirestore.collection('coffee').doc(widget.coffee.name);
                    await items.update({'image': urls}).then((value) {
                      showToastAndNavigate("Item edited successfully!");
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const HomePage(),
                      //   ),
                      // );
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: 200,
                  decoration: BoxDecoration(color: Colors.brown[700], borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
