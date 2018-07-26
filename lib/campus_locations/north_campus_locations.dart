import 'package:latlong/latlong.dart';
import 'package:ualberta_campus_map/Campus.dart';
import 'package:ualberta_campus_map/Feature.dart';

class NorthCampusLocations {
  static Campus northCampus = Campus(LatLng(53.523219, -113.526319), "North Campus", 15.0, features);
  static List<Feature> features = [
    Feature(LatLng(53.522559, -113.530915), "Lister Centre", 15.0),
    Feature(LatLng(53.525342, -113.527386), "Student Union Building", 15.0)];
  static Feature listerCentre = Feature(LatLng(53.522559, -113.530915), "Lister Centre", 15.0);
  static Feature sub = Feature(LatLng(53.525342, -113.527386), "Student Union Building", 15.0);
}
