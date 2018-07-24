import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ualberta_campus_map/campus_locations/north_campus_locations.dart';
import 'package:ualberta_campus_map/campus_locations/south_campus_locations.dart';

Location loc = new Location();

class HomePage extends StatefulWidget {
  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> campuses = <String>["North Campus", "South Campus", "Saint-Jean", "Augustana"];
  String selectedCampus = "North Campus";

  static MapController controller = new MapController();
  FlutterMap map = FlutterMap(
    mapController: controller,
    options: new MapOptions(
      center: new LatLng(53.523210, -113.526319),
      zoom: 15.0,
      minZoom: 1.0,
      maxZoom: 20.0,
    ),
    layers: [
      new TileLayerOptions(
        urlTemplate:
        "https://api.mapbox.com/v4/"
            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
        additionalOptions: {
          'accessToken': 'pk.eyJ1IjoiamFjb2JwYXRvbiIsImEiOiJjamptZnU0MTQxbnBmM3BtZDhvcTlpdDN2In0.Oq3p85e9IqiLdhdQtuIq2w',
          'id': 'mapbox.streets',
        },
      ),
      new MarkerLayerOptions(markers: [Marker(
        point: new LatLng(53.523210, -113.526319),
        builder: (_) =>
        new Icon(Icons.location_on, size: 35.0, color: Colors.green,),
        ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("UAlberta Campus Map"),),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("UAlberta Campus Map", style: new TextStyle(fontSize: 16.0),),
            ),
            new Row(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Text("Campus: ", style: new TextStyle(fontWeight: FontWeight.bold),),
                ),
                new DropdownButton(
                    value: selectedCampus,
                    items: campuses.map((String campus) {
                      return new DropdownMenuItem<String>(
                        value: campus,
                        child: new Text(campus));
                      }).toList(),
                    onChanged: (_) {}),
              ],
            ),
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
      loc.getLocation.then((currentLocation) {
      double lat = currentLocation['latitude'];
      double lng = currentLocation['longitude'];
      controller.move(new LatLng(lat, lng), 16.0);
    });
    },
    child: Icon(Icons.my_location),),
      body: map,
    );
  }
}