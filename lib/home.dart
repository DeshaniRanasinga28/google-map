import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _position = const LatLng(6.9271 , 79.8612); //Colombo
  LatLng _lastPosition = _position;

  MapType _currentMapType = MapType.terrain;

  final Set<Marker> _marker = {};


  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  void _onMapType(){
    print("map type");
    setState(() {
      _currentMapType = _currentMapType == MapType.terrain
          ? MapType.satellite
          : MapType.terrain;

    });
  }

  void _onCameraMove(CameraPosition position){
    _lastPosition = position.target;
  }

  void _onAddMarker(){
    _marker.clear();
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: _lastPosition,
          draggable: false,
          infoWindow: InfoWindow(
              title: "Position",
              snippet: "$_lastPosition"
          ),
          icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _position,
                  zoom: 15.0
                ),
              mapType: _currentMapType,
              markers: _marker,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.map,
                        size: 36.0,
                        color: Colors.blueAccent,
                      ),
                      onPressed: _onMapType,
                    ),
                    SizedBox(height: 10.0),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.add_location,
                        size: 36.0,
                        color: Colors.blueAccent,
                      ),
                      onPressed: _onAddMarker,
                    ),
                  ],
                )
              ),
            ),
          ],
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}