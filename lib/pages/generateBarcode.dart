import 'package:flutter/material.dart';
import "package:barcode_widget/barcode_widget.dart";
class GenerateBarcodePage extends StatefulWidget {
  const GenerateBarcodePage({super.key});

  @override
  State<GenerateBarcodePage> createState() => _GenerateBarcodePageState();
}

class _GenerateBarcodePageState extends State<GenerateBarcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
Container(
  padding: const EdgeInsets.symmetric(horizontal: 15) ,
  child:   ClipRRect(
  
    borderRadius: BorderRadius.circular(10),
  
    child:   BarcodeWidget(
  
    
  
    barcode: Barcode.code128(),
  
    
  
    data: "hello Flutter",
  
    
  
    drawText: false,
  
    
  
    width: double.maxFinite,
  
    
  
    height: 80,
  
    
  
    ),
  
  ),
)

      ],),
    );
  }
}