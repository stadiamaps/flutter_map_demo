import 'package:fleaflet_demo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

class StadiaVectorTileLayer extends StatefulWidget {
  final String apiKey;

  const StadiaVectorTileLayer(
      {super.key, required this.apiKey});

  @override
  State<StatefulWidget> createState() => _StadiaVectorTileLayerState();
}

class _StadiaVectorTileLayerState extends State<StadiaVectorTileLayer> {
  final Client client = Client();

  Future<Widget> _fetchMapLayer() async {
    var json = await fetchAssetJson(context, "assets/style.json");
    var theme = ThemeReader(logger: null).read(json);
    var urlTemplate =
        "https://tiles.stadiamaps.com/data/openmaptiles/{z}/{x}/{y}.pbf?api_key=${widget.apiKey}";

    return VectorTileLayer(
      theme: theme,
      tileProviders: TileProviders({
        'openmaptiles': MemoryCacheVectorTileProvider(
            delegate: NetworkVectorTileProvider(
                urlTemplate: urlTemplate, maximumZoom: 14),
            maxSizeBytes: 1024 * 1024 * 2)
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<Widget> mapLayerFuture = _fetchMapLayer();
    return FutureBuilder<Widget>(
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
  }
}
