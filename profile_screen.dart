import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sellers/screens/settings_page.dart';
import 'signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _transportFeeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadDetailerData();
  }

  Future<void> _loadDetailerData() async {
    final user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      final doc = await _firestore.collection('companies').doc(_userId).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'];
        _locationController.text = data['location'];
        _transportFeeController.text = data['transportFee'];
        _arrivalTimeController.text = data['arrivalTime'];
        _imageUrl = data['imageUrl'];
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    if (_userId != null) {
      final storageRef =
          _storage.ref().child('company_images').child(_userId! + '.jpg');
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask.whenComplete(() {});

      _imageUrl = await snapshot.ref.getDownloadURL();
    }
  }

  Future<void> _updateDetailer() async {
    if (_userId != null) {
      await _uploadImage();
      await _firestore.collection('companies').doc(_userId!).update({
        'name': _nameController.text,
        'location': _locationController.text,
        'transportFee': _transportFeeController.text,
        'arrivalTime': _arrivalTimeController.text,
        'imageUrl': _imageUrl ?? '',
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    CircularProgressIndicator();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
              // Navigate to settings screen or perform action
            },
            icon: Icon(Icons.settings),
          ),
        ],
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
                      : (_imageUrl != null
                          ? Image.network(_imageUrl!, fit: BoxFit.cover)
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                              size: 100,
                            )),
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
                onPressed: _updateDetailer,
                child: Text('Save Changes'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




















// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// // Import your SignUpScreen
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sellers/screens/settings_page.dart';
// import 'package:sellers/screens/signup_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late TextEditingController _userNameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _passwordController;

//   File? selectedImage;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   late String _userId;
//   String? _imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _userNameController = TextEditingController();
//     _phoneController = TextEditingController();
//     _passwordController = TextEditingController();
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       _userId = user.uid;
//       DocumentSnapshot userData =
//           await _firestore.collection('customers').doc(_userId).get();
//       setState(() {
//         _userNameController.text = userData['userName'];
//         _phoneController.text = userData['phone'];
//         _imageUrl = userData['profilePicture'];
//       });
//     }
//   }

//   Future<void> _updateUserData() async {
//     try {
//       await _firestore.collection('customers').doc(_userId).update({
//         'userName': _userNameController.text,
//         'phone': _phoneController.text,
//         'profilePicture': _imageUrl,
//       });
//       displayToastMessage('Profile updated successfully', context);
//     } catch (e) {
//       displayToastMessage('Error updating profile: $e', context);
//     }
//   }

//   Future<void> _uploadProfilePicture() async {
//     try {
//       final Reference ref =
//           _storage.ref().child('profile_pictures').child('$_userId.jpg');
//       await ref.putFile(selectedImage!);
//       _imageUrl = await ref.getDownloadURL();
//       displayToastMessage('Profile picture updated successfully', context);
//       setState(() {}); // Update UI to reflect new image
//     } catch (e) {
//       displayToastMessage('Error uploading profile picture: $e', context);
//     }
//   }

//   void displayToastMessage(String message, BuildContext context) {
//     Fluttertoast.showToast(msg: message);
//   }

//   void showImagePickerOption(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 5,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImage(ImageSource.gallery);
//                       Navigator.pop(context);
//                     },
//                     child: SizedBox(
//                       child: Column(
//                         children: const [
//                           Icon(
//                             Icons.image,
//                             size: 70,
//                           ),
//                           Text("Gallery"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImage(ImageSource.camera);
//                       Navigator.pop(context);
//                     },
//                     child: SizedBox(
//                       child: Column(
//                         children: const [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 70,
//                           ),
//                           Text("Camera"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? returnImage = await _picker.pickImage(source: source);
//     if (returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//     });
//     _uploadProfilePicture();
//   }

//   Future<void> _signOut() async {
//     try {
//       await _auth.signOut();
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => SignupScreen()),
//         (route) => false, // Prevents going back to previous screens
//       );
//     } catch (e) {
//       print('Error signing out: $e');
//       // Handle sign-out errors
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SettingsPage(),
//                 ),
//               );
//               // Navigate to settings screen or perform action
//             },
//             icon: Icon(Icons.settings),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: selectedImage != null
//                         ? FileImage(selectedImage!)
//                         : _imageUrl != null
//                             ? NetworkImage(_imageUrl!)
//                             : AssetImage('assets/dazzles.png') as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: -0,
//                     left: 140,
//                     child: IconButton(
//                       onPressed: () {
//                         showImagePickerOption(context);
//                       },
//                       icon: Icon(Icons.add_a_photo),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   showImagePickerOption(context);
//                 },
//                 child: Text('Change Profile pic'),
//               ),
//             ),
//             SizedBox(height: 8),
//             TextField(
//               controller: _userNameController,
//               decoration: InputDecoration(
//                 labelText: 'User Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone No',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               width: 350,
//               child: ElevatedButton(
//                 style: ButtonStyle(),
//                 onPressed: _updateUserData,
//                 child: Text(
//                   'Save Changes',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   onPressed: _signOut,
//                   child: Text('Sign Out'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Text('profile page'),
//     );
//   }
// }
