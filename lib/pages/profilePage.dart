import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/my_button.dart';
import 'package:mobile_app/components/text_box.dart';

import '../components/mapPage.dart';




class ProfilePage extends StatefulWidget {
     final Function()? onTap;

  const ProfilePage({super.key,
  required this.onTap,
  });

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
       // backgroundColor: Colors.orange,
        title: Text("Edit $field"), // Add a space after "Edit"
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Enter new $field",
           // hintStyle: const TextStyle(color: Colors.grey),
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
      appBar: AppBar(
        backgroundColor:  Colors.black,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.orange),
        ),
       // backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
         
          
          Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>?;

                    // Provide default values for the fields in case they are null
                    final username = userData?['username'] ?? currentUser.email;

                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        // Profile pic
                        const Icon(
                          Icons.person,
                          color: Colors.orange,
                          size: 150,
                         // color: Colors.orange,
                        ),
                      
                       
                        // User details
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'My Details',
                            style: TextStyle(color: Colors.black,
                            fontSize: 30),
                          ),
                        ),
                        
                        // Username
                        MyTextBox(
                          text: username,
                          sectionName: 'Username',
                          onPressed: () => editField('username'),
                        ),
                        SizedBox(height: 60,),
                        Text("Click the button below to access\n the map and locate other stores",
                        style: TextStyle(
              color: Colors.black,
              fontSize: 20,)),
                        SizedBox(height: 30,),
                         MyButton1(
                            buttonText: "Map",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MapPage(),
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
        ],
      ),
    );
  }
}
