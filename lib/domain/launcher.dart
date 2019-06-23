import 'package:url_launcher/url_launcher.dart';

class Launcher {

  final String url;

  Launcher(this.url);

  void open() async
  {
    // guard clause
    if(this.url.isEmpty)
    {
      return;
    }

    if (await canLaunch(this.url)) {
      await launch(this.url);
    } else {
      throw 'Could not open url .';
    }
  }

}