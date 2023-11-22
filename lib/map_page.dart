import 'package:fleaflet_demo/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geojson_vi/geojson_vi.dart';
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
  final PopupController _popupController = PopupController();

  // Loads and parses a GeoJSON file from the internet asynchronously,
  // then builds up a set of markers with the parsed points.
  Future<Widget> _fetchMarkers(Client client) async {
    final List<Marker> markers = [];
    final json = await fetchBodyString(client,
        'https://maplibre.org/maplibre-gl-js/docs/assets/earthquakes.geojson');
    final collection = GeoJSONFeatureCollection.fromJSON(json);

    for (final feature in collection.features) {
      final geom = feature?.geometry;
      if (geom is GeoJSONPoint) {
        markers.add(Marker(
            point: LatLng(geom.coordinates[1], geom.coordinates[0]),
            builder: (context) => const CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.sensors,
                    color: Colors.yellow,
                  ),
                )));
      }
    }

    if (kDebugMode) {
      print("Loaded ${markers.length} markers from GeoJSON");
    }

    // return MarkerLayer(markers: markers);
    return MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
      // size: const Size(40, 40),
      anchorPos: AnchorPos.align(AnchorAlign.center),
      markers: markers,
      popupOptions: PopupOptions(
          popupController: _popupController,
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
              )),
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

    return PopupScope(
        popupController: _popupController,
        child: FlutterMap(
          options: MapOptions(
              center: const LatLng(37.77, -122.43),
              zoom: 7,
              keepAlive: true,
              interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation |
                  InteractiveFlag.pinchMove |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom,
              onTap: (_, __) => _popupController.hideAllPopups()),
          nonRotatedChildren: [
            RichAttributionWidget(attributions: [
              TextSourceAttribution("Stadia Maps",
                  onTap: () => launchUrl(Uri.parse("https://stadiamaps.com/")),
                  prependCopyright: true),
              TextSourceAttribution("OpenMapTiles",
                  onTap: () =>
                      launchUrl(Uri.parse("https://openmaptiles.org/")),
                  prependCopyright: true),
              TextSourceAttribution("OSM Contributors",
                  onTap: () => launchUrl(
                      Uri.parse("https://www.openstreetmap.org/about/")),
                  prependCopyright: true),
            ])
          ],
          children: [
            widget.basemapLayer,
            markerLayerBuilder,
          ],
        ));
  }
}
