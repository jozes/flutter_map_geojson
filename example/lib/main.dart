import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

String testGeoJson = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [
          [  
            [ 
              [ 
                14.475314661954956,
                45.99528512959203
              ],
              [
                14.48295359322937,
                45.997073943280554
              ],
              [
                14.48544268319519,
                45.99498698835544
              ],
              [
                14.485614344572143,
                45.992124750758606
              ],
              [
                14.485356852506714,
                45.99033577708827
              ],
              [
                14.478318736051635,
                45.98801002486849
              ],
              [ 
                14.475314661954956,
                45.99528512959203
              ]
            ]
          ],

          [  
            [ 
              [ 
                14.486300990079956,
                45.997670201660156
              ],
              [
                14.493510767911987,
                45.99933969094237
              ],
              [
                14.49668650338562,
                45.99361551797875
              ],
              [
                14.488532587980346,
                45.991409168229445
              ],
              [
                14.486043498014526,
                45.990872475261
              ],
              [
                14.486043498014526,
                45.99516587329015
              ],
              [ 
                14.4832110852948,
                45.99737207327347
              ],
              [ 
                14.486300990079956,
                45.997670201660156
              ]
            ],
            [
              [ 
                14.48706543480164,
                45.99650302788219
              ],
              [
                14.490992188799442,
                45.997486860913625
              ],
              [
                14.492451310503544,
                45.99505705971195
              ],
              [
                14.488138318407596,
                45.99395392456707
              ],
              [ 
                14.48706543480164,
                45.99650302788219
              ]
            ],
            [
              [ 
                14.4890395406366,
                45.99229686071988
              ],
              [
                14.493502736437382,
                45.993429843946096
              ],
              [
                14.49281609092957,
                45.99435410255712
              ],
              [
                14.488524556505741,
                45.99319132308913
              ],
              [ 
                14.4890395406366,
                45.99229686071988
              ]
            ]
          ]
        ]
      },
      "properties": {
        "gid": 14,
        "obmocje": "Test polygon"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "MultiPoint",
        "coordinates": 
        [
          [14.482672, 45.989040],
          [14.489469, 45.990370]
        ]
      },
      "properties": {
        "section": "Multipoint M-10"
      }
    },    
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": 
        [14.481, 45.982]
      },
      "properties": {
        "section": "Point M-4"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Circle",
        "coordinates": 
        [14.481, 45.982]
      },
      "properties": {
        "section": "Multipoint M-10",
        "radius": 250
      }
    }
  ]
}
''';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Map GeoJson Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // instantiate parser, use the defaults
  GeoJsonParser geoJsonParser = GeoJsonParser(
      defaultMarkerColor: Colors.red,
      defaultPolygonBorderColor: Colors.red,
      defaultPolygonFillColor: Colors.red.withOpacity(0.1),
      defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  bool loadingData = false;

  bool myFilterFunction(Map<String, dynamic> properties) {
    if (properties['section'].toString().contains('Point M-4')) {
      return false;
    } else {
      return true;
    }
  }

  // this is callback that gets executed when user taps the marker
  void onTapMarkerFunction(Map<String, dynamic> map) {
    // ignore: avoid_print
    print('onTapMarkerFunction: $map');
  }

  Future<void> processData() async {
    // parse a small test geoJson
    // normally one would use http to access geojson on web and this is
    // the reason why this funcyion is async.
    geoJsonParser.parseGeoJsonAsString(testGeoJson);
  }

  @override
  void initState() {
    geoJsonParser.setDefaultMarkerTapCallback(onTapMarkerFunction);
    geoJsonParser.filterFunction = myFilterFunction;
    loadingData = true;
    Stopwatch stopwatch2 = Stopwatch()..start();
    processData().then((_) {
      setState(() {
        loadingData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GeoJson Processing time: ${stopwatch2.elapsed}'),
          duration: const Duration(milliseconds: 5000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: FlutterMap(
          mapController: MapController(),
          options: const MapOptions(
            initialCenter: LatLng(45.993807, 14.483972),
            //center: LatLng(45.720405218, 14.406593302),
            initialZoom: 14,
          ),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c']),
            //userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            loadingData
                ? const Center(child: CircularProgressIndicator())
                : PolygonLayer(
                    polygons: geoJsonParser.polygons,
                  ),
            if (!loadingData) PolylineLayer(polylines: geoJsonParser.polylines),
            if (!loadingData) MarkerLayer(markers: geoJsonParser.markers),
            if (!loadingData) CircleLayer(circles: geoJsonParser.circles),
          ],
        ));
  }
}
