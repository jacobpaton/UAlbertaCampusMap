import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ualberta_campus_map/Feature.dart';
import 'package:ualberta_campus_map/campus_locations/north_campus_locations.dart';
import 'package:ualberta_campus_map/campus_locations/south_campus_locations.dart';
import 'package:ualberta_campus_map/campus_locations/stjean_locations.dart';
import 'package:ualberta_campus_map/campus_locations/augustana_locations.dart';

void main() => runApp(CampusMap());

class CampusMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UAlberta Campus Map",
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{
  //  Campus name list, current campus, current location
  static final List<Feature> campuses = <Feature>[NorthCampusLocations.northCampus, SouthCampusLocations.southCampus, AugustanaLocations.augustanaCampus, StJeanLocations.stJean];
  Feature cCampus = campuses[0];
  Location loc = Location();

  static MapController controller = MapController();
  FlutterMap map = FlutterMap(
    mapController: controller,
    options: MapOptions(
      center: NorthCampusLocations.northCampus.getPos(),
      zoom: 15.0,
      minZoom: 1.0,
      maxZoom: 20.0,
    ),
    layers: [
      TileLayerOptions(
        urlTemplate: "https://api.mapbox.com/v4/"
            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
        additionalOptions: {
          'accessToken': 'pk.eyJ1IjoiamFjb2JwYXRvbiIsImEiOiJjamptZnU0MTQxbnBmM3BtZDhvcTlpdDN2In0.Oq3p85e9IqiLdhdQtuIq2w',
          'id': 'mapbox.streets',
        }
      ),
      MarkerLayerOptions(markers: [
        Marker(
          point: NorthCampusLocations.northCampus.getPos(),
          builder: (_) => Icon(Icons.location_on, size: 35.0, color: Colors.green,),

        ),
        Marker(
          point: NorthCampusLocations.listerCentre.getPos(),
          builder: (_) => Icon(Icons.home, size: 35.0, color: Colors.amber,),
        )
      ])
    ]
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UAlberta Campus Map")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("UAlberta Campus Map", style: TextStyle(fontSize: 16.0, color: Colors.white,),),
                ],
              ),
              decoration: BoxDecoration(color: Colors.green,),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Campus: ", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                DropdownButton<Feature>(
                  hint: Text("Select a campus"),
                  value: cCampus,
                  onChanged: (Feature newCampus) {
                    setState(() {
                      cCampus = newCampus;
                      controller.move(cCampus.getPos(), cCampus.getZoom());
                    });
                  },
                  items: campuses.map((Feature campus) {
                    return DropdownMenuItem<Feature>(
                      value: campus,
                      child: Text(campus.getTitle()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            loc.getLocation.then((currentLocation){
              double lat = currentLocation['latitude'];
              double lng = currentLocation['longitude'];
              controller.move(LatLng(lat, lng), 16.0);
            });
          },
          child: Icon(Icons.my_location),
      ),
      body: map,
    );
  }
}