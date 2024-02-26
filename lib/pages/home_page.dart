import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

//import 'package:shared_preferences/shared_preferences.dart';
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
  String _scanBarcode = ''; // Initialize as an empty string

  

  @override
  void initState() {
    super.initState();
  }

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

  // Check the scanned barcode in Firebase
  if (_scanBarcode.isNotEmpty) {
    checkBarcodeInFirebase(_scanBarcode);
    // You can also save the scanned barcode to shared preferences here if needed.
  }
}


  // Method to save the scanned barcode result to shared preferences
Future<void> checkBarcodeInFirebase(String barcode) async {
  
  try {
// Replace 'your_collection' and 'barcode_field' with your Firestore collection and field names.
  final CollectionReference barcodesCollection =
      FirebaseFirestore.instance.collection('barcodes');


    final QuerySnapshot barcodeSnapshot = await barcodesCollection
        .where('data', isEqualTo: barcode)
        .get();

    if (barcodeSnapshot.docs.isNotEmpty) {
      // Barcode exists in Firebase database.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Barcode Found'),
            content: Text("The item: '$barcode' was found in the database."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Barcode not found in Firebase database.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Barcode Not Found'),
            content: Text("The barcode: '$barcode' was not found in the database.\n"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print('Error checking barcode: $e');
  }
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
            Text("Scan barcode below\n by pressing the\n scan button",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              //fontStyle: Bold,
            ),
            
            ),
            SizedBox(height: 45,),
            MyButton1(
              onTap: scanBarcodeNormal,
              buttonText: 'Scan Barcode',
            ),
            
            const SizedBox(height: 30),
            Text(
              'last scanned result: $_scanBarcode\n',
            ),
          ],
        ),
      ),
    );
  }
}