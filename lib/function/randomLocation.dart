import 'dart:math';

class RandomLocation {
  final random = Random();

  ///declear varieble [r] radius
  var r = 210 / 111300; // = 2000 meters
  Map getLocation({double lat, double lng}) {
    ///random 2 double then init varieble [u] and [v]
    double u = random.nextDouble();
    double v = random.nextDouble();

    ///calurate latitude and longitude within [r]
    ///by get current location + random double
    var w = r * sqrt(u);
    var t = 2 * pi * v;
    var x = w * cos(t);
    var inLng = w * sin(t);
    var inLat = x / cos(lng);
    double ranLat() {
      return lat + inLat;
    }

    double ranLng() {
      return lng + inLng;
    }

    ///return as map
    return {'lat': ranLat(), 'lng': ranLng()};
  }
}
