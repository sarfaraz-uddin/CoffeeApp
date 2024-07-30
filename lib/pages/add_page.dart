import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/components/text_field.dart';
import 'package:coffeeapp/pages/home_page.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddpageState();
}

class _AddpageState extends State<AddPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  XFile? image;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
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
                      "Add items",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  image == null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.cyan[300], image: const DecorationImage(image: AssetImage('lib/images/mutton.png'), fit: BoxFit.contain)),
                        )
                      : Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.file(
                            File(image!.path),
                            // image!.path,
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
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upload a photo',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NormalTextField(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: <String>['drinks', 'chicken', 'buff', 'veg', 'snacks', 'Desserts'] // Add your categories here
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey), // Adjust border color as needed
                    ),
                    filled: true,
                    fillColor: Colors.grey[300], // Background color of the dropdown field
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    suffixIcon: Icon(Icons.arrow_drop_down), // Icon indicating dropdown
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // try {
                  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore
                  //       .instance;
                  //   await firebaseFirestore.collection('coffee')
                  //       .doc(name.text)
                  //       .set(
                  //     {
                  //       "name": name.text,
                  //       "image": '',
                  //       "price": price.text,
                  //       "category": selectedCategory
                  //     },
                  //   );
                  //   var photo = File(image!.path);
                  //
                  //   UploadTask? uploadTask;
                  //   var ref = FirebaseStorage.instance.ref()
                  //       .child('coffee')
                  //       .child(name.text);
                  //   ref.putFile(photo);
                  //   uploadTask = ref.putFile(photo);
                  //   final snap = await uploadTask.whenComplete(() {});
                  //   final urls = await snap.ref.getDownloadURL();
                  //   var items = firebaseFirestore.collection('coffee').doc(
                  //       name.text);
                  //   await items.update({'image': urls}).then((value) {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const HomePage(),
                  //       ),
                  //     );
                  //   });
                  // }catch(error){
                  //   print('Error adding item:$error');
                  // }
                  // Inside your onTap handler

                    try {
                      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                      // Upload image to Firebase Storage
                      var photo = File(image!.path);
                      var ref = FirebaseStorage.instance.ref().child('coffee').child(name.text);
                      var uploadTask = ref.putFile(photo);

                      // Get download URL after upload is complete
                      var snapshot = await uploadTask;
                      var downloadUrl = await snapshot.ref.getDownloadURL();

                      // Update Firestore document with image URL
                      await firebaseFirestore.collection('coffee').doc(name.text).set({
                        "name": name.text,
                        "image": downloadUrl, // Store image URL in Firestore
                        "price": price.text,
                        "category": selectedCategory
                      });
                      Fluttertoast.showToast(
                        msg: "Item added successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );

                      // Navigate back to home page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    } catch (error) {
                      print('Error adding item: $error');
                      Fluttertoast.showToast(
                        msg: "Error adding item: $error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: 200,
                  decoration: BoxDecoration(color: Colors.brown[700], borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    "Add",
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
