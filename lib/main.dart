import 'package:fleaflet_demo/raster_tile_layer.dart';
import 'package:fleaflet_demo/vector_tile_layer.dart';
import 'package:flutter/material.dart';

import 'map_page.dart';

const _stadiaMapsApiKey = "YOUR-API-KEY";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.architecture)),
              ]),
            ),
            body: TabBarView(children: [
              MapPage(
                  basemapLayer: StadiaRasterTileLayer(
                      styleName: "outdoors", apiKey: _stadiaMapsApiKey)),
              const MapPage(
                  basemapLayer: StadiaVectorTileLayer(
                      styleName: "outdoors", apiKey: _stadiaMapsApiKey)),
            ]),
          )),
    );
  }
}
