import 'package:latlong/latlong.dart';

class Feature {
  LatLng _pos;
  String _title;
  double _zoom;

  Feature(LatLng pos, String title, double zoom){
    this._pos = pos;
    this._title = title;
    this._zoom = zoom;
  }

  LatLng getPos(){
    return _pos;
  }

  String getTitle(){
    return _title;
  }

  double getZoom(){
    return _zoom;
  }
}