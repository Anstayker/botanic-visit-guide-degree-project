import 'package:flutter_compass/flutter_compass.dart';

class CompassWrapper {
  Stream<double> watchHeading() {
    return (FlutterCompass.events ?? Stream<CompassEvent>.empty())
        .map((event) => event.heading)
        .where((heading) => heading != null)
        .map((heading) => heading!);
  }
}
