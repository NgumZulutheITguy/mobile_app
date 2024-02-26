import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../components/historyTile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _scannedDataList = []; // List to store the scanned data

  Stream<QuerySnapshot> _loadScannedDataStream() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference barcodeCollection =
        FirebaseFirestore.instance.collection('barcodes');
    return barcodeCollection
        .doc(uid)
        .collection('scanned_data')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Method to retrieve the scanned data from Firestore
  void _loadScannedData() async {
    String uid = FirebaseAuth.instance.currentUser!
        .uid; // Get the current user's UID from Firebase Auth
    CollectionReference barcodeCollection =
        FirebaseFirestore.instance.collection('barcodes');

    try {
      QuerySnapshot snapshot = await barcodeCollection
          .doc(uid)
          .collection('scanned_data')
          .orderBy('timestamp', descending: true)
          .get();
      List<String> scannedDataList =
          snapshot.docs.map((doc) => doc['barcode_data'] as String).toList();
      setState(() {
        _scannedDataList = scannedDataList;
      });
    } catch (e) {
      print('Error retrieving scanned data: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _loadScannedDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _scannedDataList = snapshot.data!.docs
                        .map((doc) => doc['barcode_data'] as String)
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _scannedDataList.length,
                      itemBuilder: (context, index) {
                        return HistoryTile(
                          onPressed: () {},
                          sectionName: 'Scanned Data',
                          text: _scannedDataList[index],
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
