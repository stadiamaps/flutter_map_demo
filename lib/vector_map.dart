import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';
import 'package:http/http.dart';

class VectorMap extends StatefulWidget {
  final String apiKey;

  const VectorMap({super.key, required this.apiKey});

  @override
  State<VectorMap> createState() => _VectorMapState();
}

class _VectorMapState extends State<VectorMap> {
  @override
  Widget build(BuildContext context) {
    final Future<Widget> mapLayerFuture =
        _fetchMapLayer(Client(), widget.apiKey);

    var builder = FutureBuilder<Widget>(
      future: mapLayerFuture,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        } else {
          return const Center(child: Text('Loading style...'));
        }
      },
    );

    return FlutterMap(
      options: MapOptions(
          center: LatLng(59.438484, 24.742595), zoom: 14, keepAlive: true),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'Stadia Maps © OpenMapTiles © OpenStreetMap contributors',
          onSourceTapped: () async {
            if (!await launchUrl(Uri.parse("https://stadiamaps.com/attribution"))) {
              if (kDebugMode) {
                print('Could not launch url');
              }
            }
          },
        )
      ],
      children: [builder],
    );
  }
}

VectorTileProvider _cachingTileProvider(String urlTemplate) {
  return MemoryCacheVectorTileProvider(
      delegate:
          NetworkVectorTileProvider(urlTemplate: urlTemplate, maximumZoom: 14),
      maxSizeBytes: 1024 * 1024 * 2);
}

Future<Widget> _fetchMapLayer(Client client, String apiKey) async {
  // TODO: Refactor out
  var res = await client
      .get(Uri.parse('https://tiles.stadiamaps.com/styles/outdoors.json'));
  var json = await compute(jsonDecode, res.body);
  var theme = ThemeReader(logger: null).read(json);
  var urlTemplate =
      "https://tiles.stadiamaps.com/data/openmaptiles/{z}/{x}/{y}.pbf?api_key=$apiKey";

  return VectorTileLayer(
    theme: theme,
    tileProviders:
        TileProviders({'openmaptiles': _cachingTileProvider(urlTemplate)}),
  );
}
