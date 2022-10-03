import 'package:flutter_map/flutter_map.dart';

class StadiaRasterTileLayer extends TileLayer {
  // You can find a list of styles at https://docs.stadiamaps.com/themes/
  // (see the URLs tab)
  StadiaRasterTileLayer(
      {super.key, required String styleName, required String apiKey})
      : super(
          urlTemplate:
              "https://tiles.stadiamaps.com/tiles/$styleName/{z}/{x}/{y}{r}.png?api_key={api_key}",
          additionalOptions: {"api_key": apiKey},
          maxZoom: 20,
          maxNativeZoom: 20,
        );
}
