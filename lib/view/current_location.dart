import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocat extends StatefulWidget {
  const CurrentLocat({Key? key}) : super(key: key);

  @override
  State<CurrentLocat> createState() => _CurrentLocatState();
}

class _CurrentLocatState extends State<CurrentLocat> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

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
        onPressed: () async {
          Position position = await _determinePosition();

          _controller!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.clear();

          markers.add(Marker(
              markerId: MarkerId("current Location"),
              position: LatLng(position.latitude, position.longitude)));

          setState(() {});
        },
        child: Icon(Icons.my_location),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        zoomControlsEnabled: false,
        markers: markers.toSet(),
        onTap: (Cordinate) {
          _controller!.animateCamera(CameraUpdate.newLatLng(Cordinate));
          addMarker(Cordinate);
        },
      ),
    );
  }
}
