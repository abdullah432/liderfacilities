import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:liderfacilites/models/custom_google_map.dart';

class TestMapPolyline extends StatefulWidget {
  @override
  _TestMapPolylineState createState() => _TestMapPolylineState();
}

class _TestMapPolylineState extends State<TestMapPolyline> {

  final Set<Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;

  String encodedPoly;
  LatLng latLng1;
  LatLng latLng2;

  @override
  void initState() {
    latLng1 = LatLng(33.6376147, 73.039058);
    latLng2 = LatLng(33.61329219101094, 73.038329444482565);
    _add();
    super.initState();
  }

  void _add() async{
    encodedPoly = await CustomGoogleMap.getRouteCoordinates(latLng1, latLng2);

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    _mapPolylines.add(Polyline(
        polylineId: polylineId,//pass any string here
        width: 3,
        geodesic: true,
        points: CustomGoogleMap.convertToLatLng(CustomGoogleMap.decodePoly(encodedPoly)),
        color: Colors.amber));

    setState(() {
      // _mapPolylines[polylineId] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: _add)],
      ),
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(33.6376147, 73.039058), zoom: 13.0),
        polylines: _mapPolylines,
      ),
    );
  }


}
