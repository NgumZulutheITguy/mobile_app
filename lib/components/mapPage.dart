import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;

  void _changeMapType() {
    setState(() {
      // Toggle between MapType.normal and MapType.satellite
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  var markers = {
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(-29.851389, 31.007222),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), 
      // Set the custom marker icon
      infoWindow: InfoWindow(
          title: 'Contra 1',
          snippet: 'Main warehouse',
          ),
    ),
 Marker(
      markerId: MarkerId('2'),
      position: LatLng(-29.852500, 31.003611),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), 
      // Set the custom marker icon
      infoWindow: InfoWindow(
          title: 'Contra 2',
          snippet: 'Sub  warehouse',
          ),
    ),

    Marker(
      markerId: MarkerId('3'),
      position: LatLng(-29.849444, 31.010833),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), 
      // Set the custom marker icon
      infoWindow: InfoWindow(
          title: 'Contra 3',
          snippet: 'Sub  warehouse',
          ),
    ),

  };

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition:
                CameraPosition(target: LatLng(-29.851389, 31.007222), zoom: 11),

            myLocationEnabled: true, // Enable the My Location button
            myLocationButtonEnabled: true, // Show the My Location button

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
          )),
          Positioned(
            top: 20.0, // Adjust the top value to position the button vertically
            right:
                20.0, // Adjust the right value to position the button horizontally
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: _changeMapType, // Call the function to change map type
              child: Icon(Icons.map, size: 30.0),
            ),
          ),
        ],
      ),
    );
  }
}
