import 'package:fleaflet_demo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class StadiaVectorTileLayer extends StatefulWidget {
  final String styleName;
  final String apiKey;

  const StadiaVectorTileLayer(
      {super.key, required this.styleName, required this.apiKey});

  @override
  State<StatefulWidget> createState() => _StadiaVectorTileLayerState();
}

class _StadiaVectorTileLayerState extends State<StadiaVectorTileLayer> {
  final Client client = Client();

  Future<Widget> _fetchMapLayer() async {
    var style = await fetchMapStyle(widget.styleName, widget.apiKey);

    return VectorTileLayer(
      theme: style.theme,
      tileProviders: style.providers,
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
