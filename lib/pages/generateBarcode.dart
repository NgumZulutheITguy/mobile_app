import 'package:flutter/material.dart';
import "package:barcode_widget/barcode_widget.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/pages/history_page.dart';
import '../components/my-textfield.dart';
import '../components/my_button.dart';

class GenerateBarcodePage extends StatefulWidget {
  const GenerateBarcodePage({super.key});

  @override
  State<GenerateBarcodePage> createState() => _GenerateBarcodePageState();
}

class _GenerateBarcodePageState extends State<GenerateBarcodePage> {
  final generateController = TextEditingController();
  final priceController = TextEditingController();
  String barcodeData = "";

  @override
  void initState() {
    super.initState();
    
    // Add a listener to the text field controller
    generateController.addListener(() {
      setState(() {
        barcodeData = generateController.text;
      });
    });
  }

  @override
  void dispose() {
   
    generateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Barcode Page',
        style: TextStyle(color: Colors.orange),)),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Generate your barcode here",
              style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: barcodeData, 
                    drawText: false,
                    width: double.maxFinite,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: generateController,
                hintText: "write barcode here",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: priceController,
                hintText: "item price",
                obscureText: false,
              ),
              const SizedBox(height: 15),
               
        MyButton1(
          buttonText: 'Save Barcode',
          onTap: () async {
            try {
              // Get the current user
              User? user = FirebaseAuth.instance.currentUser;
        
              if (user != null) {
          // Access the Firestore instance
          FirebaseFirestore firestore = FirebaseFirestore.instance;
        
          // Define the data to be stored
          Map<String, dynamic> barcodeData = {
            'data': generateController.text,
            'price': priceController.text, // Use the barcodeData variable from your text field
            'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
            'userId': user.uid, // Associate the data with the user
          };
        
          // Add the data to Firestore
          await firestore.collection('barcodes').add(barcodeData);
        
          // Display a success message or navigate to another screen
          // (e.g., a screen displaying a list of saved barcodes)
          
              Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HistoryPage(), // Replace with your destination page
          ),
              );
        //show for the user
              } 
            } catch (error) {
              // Display an error message using AlertDialog
              showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error saving barcode data: $error'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
              );
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
