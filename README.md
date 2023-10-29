<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

GeoJson is becoming defacto standard for retrieving spatial data like points, lines and polygons.
GeoJson Format specification is defined in RFC7964 - see https://www.rfc-editor.org/rfc/rfc7946
This package parses GeoJson data and creates spatial objects like [Marker]s, [Polyline]s and [Polygon]s, 
which are defined in [flutter_map] package.

The creation of these objects is done by default callback functions. However, one can and probably should 
write his own callback functions which are implementing the necessary customization of creating spatial objects by specifying 
the color, stroke, label text and other parameters.  


## Features

The GeoJson parser creates three (four) lists of spatial objects - separate lists of [Marker]s, [Polyline]s and [Polygon]s (and Circles) which are input data for creating layers in flutter_map.
The parser supports parsing the following geometries:

- Point - transformed into [Marker]s
- Circle - transformed into [CircleMarker]s - not part of the spec, but handy to have.  Specify radius in the properties.
- Multipoint - transformed into multiple [Marker]s with same ID property
- LineString - tranformed in [Polyline]
- MultiLineString - transformed into multiple [Polyline]s
- Polygon - transformed into [Polygon]
- MultiPolygon - transformed into multiple [Polygon]s with same ID property


## Getting started

Add the package in pubspec.yaml file:

```dart
flutter_map_geojson ^1.0.5
```

Import it in the code:

```dart
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
```


## Usage


```dart
 // initiate parser 
 GeoJsonParser myGeoJson = GeoJsonParser();
 
 // parse GeoJson data - GeoJson is stored as [String]
 myGeoJson.parseGeoJsonAsString(testGeoJson);

 // after parsing the results are stored in 
 // myGeoJson.markers -> List<Marker>
 // myGeoJson.polylines -> List<Polyline>
 // myGeoJson.ploygons -> List<Polygon>

 // now create flutter_map layers

 FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            center: LatLng(45.993807, 14.483972),
            zoom: 14,
          ),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c']),
            PolygonLayer(polygons: myGeoJson.polygons),
            PolylineLayer(polylines: myGeoJson.polylines),
            MarkerLayer(markers: myGeoJson.markers)
          ],
        ));
```

The default [Marker], [Polyline] [CircleMarkers] and [Polygon] creation callback functions can be replaced with user-defined highly customized
functions. A good starting point are default callback functions which can be custimized to the needs of the project. The default callback functions have only basic functionality to display the spatial objects on the map. The default callback functions support changing the colors, stroke and fill color and marker icon. All these can be defined in default constructor or via setters. 
One can also apply a filtering function which returns only spatial features that have certian propertis. The filtering function returns a boolean value. For more details see the example program.

For creating tappable polylines one can use package flutter_map_tappable_polyline.

