import 'package:android_intent/android_intent.dart';
import 'package:easyfood/domain/launcher.dart';
import 'package:easyfood/domain/location.dart';
import 'package:platform/platform.dart';

class MapNavigator {

  static navigate(Location currentLocation, Location destinationLocation){

    String origin=currentLocation.latitude.toString() + "," + currentLocation.longitude.toString();
    String destination=destinationLocation.latitude.toString() + ","+destinationLocation.longitude.toString();  // lat,long like 123.34,68.56
    String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate";

    if (new LocalPlatform().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(url),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
    else {
        Launcher(url).open();
    }
  }

}