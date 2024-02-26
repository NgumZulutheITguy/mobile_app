import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Add this line to import Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line to import Firestore
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/components/my_button.dart';
import '../components/my_drawer.dart';

//import '../components/historyTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#fc7f03', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  // Method to save the scanned barcode result to Firestore
  Future<void> saveBarcodeToFirestore(String barcode) async {
    String uid = FirebaseAuth.instance.currentUser!
        .uid; // Get the current user's UID from Firebase Auth
    CollectionReference barcodeCollection =
        FirebaseFirestore.instance.collection('barcodes');

    try {
      await barcodeCollection.doc(uid).set({
        'barcode_data': barcode,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Barcode data saved to Firestore!');
    } catch (e) {
      print('Error saving barcode data: $e');
    }
  }

  // Modify the scanBarcodeNormal method to save the scanned barcode to Firestore
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#fc7f03',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    // Save the scanned barcode to shared preferences
    if (_scanBarcode.isNotEmpty) {
      saveBarcodeToSharedPreferences(_scanBarcode);

      // Save the scanned barcode to Firestore
      saveBarcodeToFirestore(_scanBarcode);
    }
  }

  // Method to save the scanned barcode result to shared preferences
  Future<void> saveBarcodeToSharedPreferences(String barcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('barcode_data', barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            user.email!,
            style: TextStyle(color: Colors.orange[500]),
          ),
          backgroundColor: Colors.black,
        ),
        drawer: const MyDrawer(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                onTap: scanBarcodeNormal,
                buttonText: 'Scan Barcode',
              ),
              const SizedBox(height: 16),
              MyButton(
                onTap: startBarcodeScanStream,
                buttonText: 'Barcode Scan stream',
              ),
              const SizedBox(height: 16),
              Text(
                'Scan result : $_scanBarcode\n',
              ),
             
            ],
          ),
        ));
  }
}
