import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

Future<String> fetchBodyString(Client client, String url) async {
  final res = await client.get(Uri.parse(url));
  return res.body;
}

Future<Style> fetchMapStyle(String name, String apiKey) => StyleReader(
        uri:
            'https://tiles.stadiamaps.com/styles/${name}.json?api_key={key}',
        apiKey: apiKey)
    .read();

Future<dynamic> fetchAssetJson(BuildContext context, String key) async {
  final text = await DefaultAssetBundle.of(context).loadString(key);
  return compute(jsonDecode, text);
}
