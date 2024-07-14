import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/screens/settings_page.dart';
import 'package:customers/screens/signup_screen.dart'; // Import your SignUpScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  File? selectedImage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late String _userId;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      DocumentSnapshot userData =
          await _firestore.collection('customers').doc(_userId).get();
      setState(() {
        _userNameController.text = userData['userName'];
        _phoneController.text = userData['phone'];
        _imageUrl = userData['profilePicture'];
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      await _firestore.collection('customers').doc(_userId).update({
        'userName': _userNameController.text,
        'phone': _phoneController.text,
        'profilePicture': _imageUrl,
      });
      displayToastMessage('Profile updated successfully', context);
    } catch (e) {
      displayToastMessage('Error updating profile: $e', context);
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      final Reference ref =
          _storage.ref().child('profile_pictures').child('$_userId.jpg');
      await ref.putFile(selectedImage!);
      _imageUrl = await ref.getDownloadURL();
      displayToastMessage('Profile picture updated successfully', context);
      setState(() {}); // Update UI to reflect new image
    } catch (e) {
      displayToastMessage('Error uploading profile picture: $e', context);
    }
  }

  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? returnImage = await _picker.pickImage(source: source);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
    });
    _uploadProfilePicture();
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
        (route) => false, // Prevents going back to previous screens
      );
    } catch (e) {
      print('Error signing out: $e');
      // Handle sign-out errors
    }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : _imageUrl != null
                            ? NetworkImage(_imageUrl!)
                            : AssetImage('assets/dazzles.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: -0,
                    left: 140,
                    child: IconButton(
                      onPressed: () {
                        showImagePickerOption(context);
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  showImagePickerOption(context);
                },
                child: Text('Change Profile pic'),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: _updateUserData,
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _signOut,
                  child: Text('Sign Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




















// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:customers/screens/settings_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';

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
//                 onPressed: _updateUserData,
//                 child: Text(
//                   'Save Changes',
//                   style: TextStyle(
//                     color: Colors.white,
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
//                   onPressed: () {
//                     // Implement sign out functionality
//                   },
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
