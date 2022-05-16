import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMap1 extends StatefulWidget {
  @override
  State<GoogleMap1> createState() => _GoogleMap1State();
}

class _GoogleMap1State extends State<GoogleMap1> {
  GoogleMapController? _controller;

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(21.2090554, 72.8407351));

  final List<Marker> markers = [];

  addMarker(Cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers.add(
        Marker(
          position: Cordinate,
          markerId: MarkerId(id.toString()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller!.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: markers.toSet(),
        onTap: (Cordinate) {
          _controller!.animateCamera(CameraUpdate.newLatLng(Cordinate));
          addMarker(Cordinate);
        },
      ),
    );
  }
}
