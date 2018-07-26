import 'Feature.dart';
import 'package:latlong/latlong.dart';

class Campus extends Feature {
  List<Feature> _features;

  Campus(LatLng pos, String title, double zoom, List<Feature> features) : super(pos, title, zoom){
    this._features = features;
  }

  List<Feature> getFeatures() {
    return _features;
  }
}