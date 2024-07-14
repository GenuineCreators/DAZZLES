import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:sellers/widgets/bottom_navbar.dart';

class DetailersScreen extends StatefulWidget {
  @override
  _DetailersScreenState createState() => _DetailersScreenState();
}

class _DetailersScreenState extends State<DetailersScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _transportFeeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    final user = _auth.currentUser;
    if (user != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('company_images')
          .child(user.uid + '.jpg');

      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask.whenComplete(() {});

      _imageUrl = await snapshot.ref.getDownloadURL();
    }
  }

  Future<void> _saveDetailer() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _uploadImage();
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.uid)
          .set({
        'name': _nameController.text,
        'location': _locationController.text,
        'transportFee': _transportFeeController.text,
        'arrivalTime': _arrivalTimeController.text,
        'imageUrl': _imageUrl ?? '',
      });
      CircularProgressIndicator();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Detailer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Take a photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_album),
                              title: Text('Choose from gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 100,
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _transportFeeController,
                decoration: InputDecoration(labelText: 'Transport Fee'),
              ),
              TextField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(labelText: 'Arrival Time'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDetailer,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
