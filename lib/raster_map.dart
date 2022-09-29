import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class RasterMap extends StatefulWidget {
  final String apiKey;

  const RasterMap({super.key, required this.apiKey});

  @override
  State<RasterMap> createState() => _RasterMapState();
}

class _RasterMapState extends State<RasterMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: LatLng(59.438484, 24.742595),
          zoom: 14,
          keepAlive: true
      ),
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
      children: [
        TileLayer(
          urlTemplate:
          "https://tiles.stadiamaps.com/tiles/outdoors/{z}/{x}/{y}{r}.png?api_key={api_key}",
          additionalOptions: {
            "api_key": widget.apiKey
          },
          maxZoom: 20,
          maxNativeZoom: 20,
        )
      ],
    );
  }
}