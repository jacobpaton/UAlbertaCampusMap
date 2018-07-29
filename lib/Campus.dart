import 'Feature.dart';
import 'package:latlong/latlong.dart';

class Campus extends Feature {
  List<Feature> _features;
  bool _avail;

  Campus(LatLng pos, String title, double zoom, List<Feature> features, bool avail) : super(pos, title, zoom){
    this._features = features;
    this._avail = avail;
  }

  List<Feature> getFeatures() {
    return _features;
  }

  bool getAvail(){
    return _avail;
  }
}