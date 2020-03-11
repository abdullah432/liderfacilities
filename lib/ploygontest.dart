// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class TestMapPolyline extends StatefulWidget {
//   @override
//   _TestMapPolylineState createState() => _TestMapPolylineState();
// }

// class _TestMapPolylineState extends State<TestMapPolyline> {
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyline = {};

//   GoogleMapController controller;

//   List<LatLng> latlngSegment1 = List();
//   List<LatLng> latlngSegment2 = List();
//   static LatLng _lat1 = LatLng(13.035606, 77.562381);
//   static LatLng _lat2 = LatLng(13.070632, 77.693071);
//   static LatLng _lat3 = LatLng(12.970387, 77.693621);
//   static LatLng _lat4 = LatLng(12.858433, 77.575691);
//   static LatLng _lat5 = LatLng(12.948029, 77.472936);
//   static LatLng _lat6 = LatLng(13.069280, 77.455844);
//   LatLng _lastMapPosition = _lat1;

//   @override
//   void initState() {
//     super.initState();
//     //line segment 1
//     latlngSegment1.add(_lat1);
//     latlngSegment1.add(_lat2);
//     latlngSegment1.add(_lat3);
//     latlngSegment1.add(_lat4);

//     //line segment 2
//     latlngSegment2.add(_lat4);
//     latlngSegment2.add(_lat5);
//     latlngSegment2.add(_lat6);
//     latlngSegment2.add(_lat1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         //that needs a list<Polyline>
//         polylines: _polyline,
//         markers: _markers,
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _lastMapPosition,
//           zoom: 11.0,
//         ),
//         mapType: MapType.normal,
//       ),
//     );
//   }

//   void _onMapCreated(GoogleMapController controllerParam) {
//     setState(() {
//       controller = controllerParam;
//       _markers.add(Marker(
//         // This marker id can be anything that uniquely identifies each marker.
//         markerId: MarkerId(_lastMapPosition.toString()),
//         //_lastMapPosition is any coordinate which should be your default
//         //position when map opens up
//         position: _lastMapPosition,
//         infoWindow: InfoWindow(
//           title: 'Awesome Polyline tutorial',
//           snippet: 'This is a snippet',
//         ),
//       ));

//       _polyline.add(Polyline(
//         polylineId: PolylineId('line1'),
//         visible: true,
//         //latlng is List<LatLng>
//         points: latlngSegment1,
//         width: 2,
//         color: Colors.blue,
//       ));

//       //different sections of polyline can have different colors
//       _polyline.add(Polyline(
//         polylineId: PolylineId('line2'),
//         visible: true,
//         //latlng is List<LatLng>
//         points: latlngSegment2,
//         width: 2,
//         color: Colors.red,
//       ));
//     });
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TestMapPolyline extends Page {
  TestMapPolyline() : super(const Icon(Icons.linear_scale), 'Place polygon');

  @override
  Widget build(BuildContext context) {
    return const PlacePolygonBody();
  }
}

class PlacePolygonBody extends StatefulWidget {
  const PlacePolygonBody();

  @override
  State<StatefulWidget> createState() => PlacePolygonBodyState();
}

class PlacePolygonBodyState extends State<PlacePolygonBody> {
  PlacePolygonBodyState();

  GoogleMapController controller;
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _polygonIdCounter = 1;
  PolygonId selectedPolygon;

  // Values when toggling polygon color
  int strokeColorsIndex = 0;
  int fillColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polygon width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPolygonTapped(PolygonId polygonId) {
    setState(() {
      selectedPolygon = polygonId;
    });
  }

  void _remove() {
    setState(() {
      if (polygons.containsKey(selectedPolygon)) {
        polygons.remove(selectedPolygon);
      }
      selectedPolygon = null;
    });
  }

  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygonIdCounter++;
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      strokeWidth: 5,
      fillColor: Colors.green,
      points: _createPoints(),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

  void _toggleGeodesic() {
    final Polygon polygon = polygons[selectedPolygon];
    setState(() {
      polygons[selectedPolygon] = polygon.copyWith(
        geodesicParam: !polygon.geodesic,
      );
    });
  }

  void _toggleVisible() {
    final Polygon polygon = polygons[selectedPolygon];
    setState(() {
      polygons[selectedPolygon] = polygon.copyWith(
        visibleParam: !polygon.visible,
      );
    });
  }

  void _changeStrokeColor() {
    final Polygon polygon = polygons[selectedPolygon];
    setState(() {
      polygons[selectedPolygon] = polygon.copyWith(
        strokeColorParam: colors[++strokeColorsIndex % colors.length],
      );
    });
  }

  void _changeFillColor() {
    final Polygon polygon = polygons[selectedPolygon];
    setState(() {
      polygons[selectedPolygon] = polygon.copyWith(
        fillColorParam: colors[++fillColorsIndex % colors.length],
      );
    });
  }

  void _changeWidth() {
    final Polygon polygon = polygons[selectedPolygon];
    setState(() {
      polygons[selectedPolygon] = polygon.copyWith(
        strokeWidthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(52.4478, -3.5402),
                zoom: 7.0,
              ),
              polygons: Set<Polygon>.of(polygons.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: (selectedPolygon == null) ? null : _remove,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed:
                              (selectedPolygon == null) ? null : _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('toggle geodesic'),
                          onPressed: (selectedPolygon == null)
                              ? null
                              : _toggleGeodesic,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change stroke width'),
                          onPressed:
                              (selectedPolygon == null) ? null : _changeWidth,
                        ),
                        FlatButton(
                          child: const Text('change stroke color'),
                          onPressed: (selectedPolygon == null)
                              ? null
                              : _changeStrokeColor,
                        ),
                        FlatButton(
                          child: const Text('change fill color'),
                          onPressed: (selectedPolygon == null)
                              ? null
                              : _changeFillColor,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final double offset = _polygonIdCounter.ceilToDouble();
    points.add(_createLatLng(51.2395 + offset, -3.4314));
    points.add(_createLatLng(53.5234 + offset, -3.5314));
    points.add(_createLatLng(52.4351 + offset, -4.5235));
    points.add(_createLatLng(52.1231 + offset, -5.0829));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}

abstract class Page extends StatelessWidget {
  const Page(this.leading, this.title);

  final Widget leading;
  final String title;
}