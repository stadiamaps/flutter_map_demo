import 'package:fleaflet_demo/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geojson/geojson.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  final Widget basemapLayer;

  const MapPage({super.key, required this.basemapLayer});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Client client = Client();

  // Loads and parses a GeoJSON file from the internet asynchronously,
  // then builds up a set of markers with the parsed points.
  Future<Widget> _fetchMarkers(Client client) async {
    final List<Marker> markers = [];
    final json = await fetchBodyString(client,
        'https://maplibre.org/maplibre-gl-js-docs/assets/earthquakes.geojson');
    final geo = GeoJson();
    final popupState = PopupState();

    geo.processedPoints.listen((event) {
      markers.add(Marker(
          point: event.geoPoint.point,
          builder: (context) => const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.sensors,
                  color: Colors.yellow,
                ),
              )));
    });
    geo.endSignal.listen((_) => geo.dispose());

    await geo.parse(json);

    if (kDebugMode) {
      print("Loaded ${markers.length} markers from GeoJSON");
    }

    // return MarkerLayer(markers: markers);
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
      // size: const Size(40, 40),
      anchor: AnchorPos.align(AnchorAlign.center),
      markers: markers,
      popupOptions: PopupOptions(
          // NOTE: We would love to display a more useful popup here, but
          // the Dart GeoJSON package drops the freeform properties during
          // parsing.
          popupBuilder: (context, marker) => Card(
                child: SizedBox(
                  width: 256,
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Earthquake Location'),
                    subtitle: Text(
                        "${marker.point.latitude}, ${marker.point.longitude}"),
                  ),
                ),
              ),
          popupState: popupState),
      builder: (context, markers) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.blue),
          child: Center(
            child: Text(
              markers.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final markersFuture = _fetchMarkers(client);

    var markerLayerBuilder = FutureBuilder<Widget>(
      future: markersFuture,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        } else {
          return const Center(child: Text('Loading earthquake data...'));
        }
      },
    );

    return FlutterMap(
      options: MapOptions(
        center: LatLng(59.438484, 24.742595),
        zoom: 8,
        keepAlive: true,
        interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation |
                  InteractiveFlag.pinchMove |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'Stadia Maps © OpenMapTiles © OpenStreetMap contributors',
          onSourceTapped: () async {
            if (!await launchUrl(
                Uri.parse("https://stadiamaps.com/attribution"))) {
              if (kDebugMode) {
                print('Could not launch url');
              }
            }
          },
        )
      ],
      children: [
        widget.basemapLayer,
        markerLayerBuilder,
      ],
    );
  }
}
