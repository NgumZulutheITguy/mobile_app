import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date and time formatting

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../components/historyTile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  //final TextEditingController _searchController = TextEditingController();
  Future<void> deleteBarcodes(id) async {
    FirebaseFirestore.instance.collection("barcodes").doc(id).delete();
    Fluttertoast.showToast(msg: "Item deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'History',
            style: TextStyle(color: Colors.orange),
          ),
          backgroundColor: Colors.black,
        ),
        body:

            // TextField(
            //   controller: _searchController,
            //   onChanged: (value) {
            //     setState(() {});
            //   },
            //   decoration: InputDecoration(
            //     labelText: "Search",
            //     suffixIcon: GestureDetector(
            //       onTap: (){},
            //       child: const Icon(Icons.search),
            //     ),
            //   ),
            // ),
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('barcodes')
              .where('userId',
                  isEqualTo: user?.uid) // Filter documents by user ID
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasData) {
                final documents = snapshot.data!.docs;

                if (documents.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>?;

                    if (data != null) {
                      final barcodeData = data['data'] ?? 'N/A';
                      final itemPrice = data['price'] ?? '';
                      final timestamp = data['timestamp'] as Timestamp;
                      final documentId = documents[index].id;
                     

      String formattedTimestamp = '';
      DateTime dateTime = timestamp.toDate();
      formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    

                      return HistoryTile(
                        onTap: () async {
                          // Handle the delete

                          await deleteBarcodes(snapshot.data!.docs[index].id);
                        },
                        sectionName: 'barcodes',
                        text:
                            'ID: $documentId\nData: $barcodeData\nPrice:R $itemPrice\ntimestamp: $formattedTimestamp',
                      );
                    }
                    return null;
                  },
                );
              } else {
                return const Center(child: Text('Data is null.'));
              }
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading data: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
