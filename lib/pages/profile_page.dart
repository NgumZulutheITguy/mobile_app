import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/calcButtons.dart';
import 'package:mobile_app/components/mapPage.dart';


import '../components/text_box.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection("users");

  // Edit field
  Future<void> editField(String field) async {


    String? newValue = ""; // Make newValue nullable to handle null values
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red,
        title: Text("Edit $field"), // Add a space after "Edit"
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Cancel
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          // Save
          TextButton(
            child: const Text('Save'),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // Update in Firestore
    if (newValue != null && newValue!.trim().isNotEmpty) {
      // Check for null and non-empty string
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>?;
      
                  // Provide default values for the fields in case they are null
                  final username = userData?['username'] ?? currentUser.email;
                  
      
                  return ListView(
                    children: [
                      const SizedBox(height: 35),
                      // Profile pic
                      const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // User email
                      Text(
                        currentUser.email ?? 'Email not available',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.orange),
                      ),
                      // User details
                      const SizedBox(
                        height: 20,
                      ),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          'My Details',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      // Username
                      MyTextBox(
                        text: username,
                        sectionName: 'Username',
                        onPressed: () => editField('username'),
                      ),
                      // Role
                            MyButton(
  buttonText: "Map",
  buttonTapped: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapPage(), // Replace 'MapPage()' with your desired destination page
      ),
    );
  },
)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            
    
          ],
        ),
      ),
      
      
    );
  }
}
