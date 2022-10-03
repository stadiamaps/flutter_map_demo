import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

Future<String> fetchBodyString(Client client, String url) async {
  final res = await client.get(Uri.parse(url));
  return res.body;
}

Future<dynamic> fetchJson(Client client, String url) async {
  final body = await fetchBodyString(client, url);
  return compute(jsonDecode, body);
}
