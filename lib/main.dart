import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ualberta_campus_map/Feature.dart';
import 'package:ualberta_campus_map/Campus.dart';
import 'package:ualberta_campus_map/campus_locations/north_campus_locations.dart';
import 'package:ualberta_campus_map/campus_locations/south_campus_locations.dart';
import 'package:ualberta_campus_map/campus_locations/stjean_locations.dart';
import 'package:ualberta_campus_map/campus_locations/augustana_locations.dart';

void main() => runApp(CampusMap());

class CampusMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.green,
      title: "UAlberta Campus Map",
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  createState() => _MapPageState();
}

// TODO: Refactor code to ease navigation of code
class _MapPageState extends State<MapPage>{
  //  Campus name list, current campus, current location
  static final List<Campus> campuses = <Campus>[NorthCampusLocations.northCampus, SouthCampusLocations.southCampus, AugustanaLocations.augustanaCampus, StJeanLocations.stJean];
  Campus cCampus = campuses[0];
  Location loc = Location();
  Text avail;
  Text notAvail = Text("Sorry! This campus is not yet supported.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,),);

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
      // TODO: Change to dynamically add markers from Feature list instead of hard-coding
      MarkerLayerOptions(markers: [
        Marker(
          point: NorthCampusLocations.northCampus.getPos(),
          builder: (context) => GestureDetector(
            child: Icon(Icons.account_balance, size: 30.0, color: Colors.green,),
            onTap: () {
              showModalBottomSheet(context: context, builder: (_) {
                // TODO: Create modal content class
                return Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text("North Campus", style: TextStyle(fontWeight: FontWeight.bold,),),
                      subtitle: Text("Edmonton, AB"),
                      // TODO: Implement favourite system
                      trailing: Icon(Icons.favorite_border),
                      onTap: (){print("yikes");},
                    ),
                    ListTile(
                      title: Text("The original campus that blends the historic with cutting" +
                          " edge: University of Alberta's North Campus is located in the province’s " +
                          "capital of Edmonton, on the edge of the North Saskatchewan River valley. " +
                          "It covers 50 city blocks, with abundant green spaces among its 150 buildings."),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text("Hours: 9:00 am - 10:00 pm"),
                    ),
                    ListTile(
                      leading: Icon(Icons.apps),
                      title: Text("Type:   Campus"),
                    )
                  ],),
                );
              });
            }
            // TODO: Add additional info (and formatting of modal)
          ),

        ),
        Marker(
          point: NorthCampusLocations.features[0].getPos(),
          builder: (_) => Icon(Icons.location_city, size: 30.0, color: Colors.amber,),
        ),
        Marker(
          point: NorthCampusLocations.features[1].getPos(),
          builder: (_) => Icon(Icons.business, size: 30.0, color: Colors.amber,),
        ),
        Marker(
          point: SouthCampusLocations.southCampus.getPos(),
          builder: (_) => Icon(Icons.account_balance, size: 30.0, color: Colors.green,),
        ),
        Marker(
          point: AugustanaLocations.augustanaCampus.getPos(),
          builder: (_) => Icon(Icons.account_balance, size: 30.0, color: Colors.green,),
        ),
        Marker(
          point: StJeanLocations.stJean.getPos(),
          builder: (_) => Icon(Icons.account_balance, size: 30.0, color: Colors.green,),
        ),
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
      appBar: AppBar(title: Text("UAlberta Campus Map",), backgroundColor: Colors.green,),
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
                      if(cCampus.getAvail()){
                        avail = null;
                        Navigator.pop(context);
                      } else {
                        avail = notAvail;
                      }
                    });
                  },
                  items: campuses.map((Feature campus) {
                    return DropdownMenuItem<Feature>(
                      value: campus,
                      child: Text(campus.getTitle()),
                    );
                  }).toList(),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: IconButton(
                    icon: Icon(Icons.location_searching),
                    onPressed: (){
                      controller.move(cCampus.getPos(), cCampus.getZoom());
                      Navigator.pop(context);
                    },
                    tooltip: 'Centre map on current campus.',
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: avail,
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text("Locations on campus:", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: const EdgeInsets.only(left: 40.0),
              child: null,
              // TODO: display campus features here
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Center map on your location.',
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