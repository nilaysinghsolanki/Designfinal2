import 'package:flutter/material.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ProfileDetailsScreem extends StatefulWidget {
  static const routeName = '/ProfileDetailsScreem';
  @override
  _ProfileDetailsScreemState createState() => _ProfileDetailsScreemState();
}

class _ProfileDetailsScreemState extends State<ProfileDetailsScreem> {
  bool initialized = false;
  Map<String, dynamic> data;
  @override
  void didChangeDependencies() async {
    if (!initialized) {
      BuildContext ctx =
          Provider.of<MaterialNavigatorKey>(context, listen: false)
              .materialNavigatorKey
              .currentContext;
      data = await Server_Connection_Functions().getProfileData(ctx);
      print(data['image']);
      setState(() {
        initialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your profile'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: !initialized
          ? Center(
              child: FadingText('Loading...'),
            )
          : SingleChildScrollView(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                    child: Image.network(
                      data['image'],
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        // Appropriate logging or analytics, e.g.
                        // myAnalytics.recordError(
                        //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                        //   exception,
                        //   stackTrace,
                        // );
                        return ListTile(
                          title: Text('😢 Can\'t load image'),
                          leading: Icon(Icons.image_rounded),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(data['name'].toString()),
                  ),
                  ListTile(
                    title: Text(data['roll_no'].toString()),
                  ),
                  ListTile(
                    title: Text(data['branch'].toString()),
                  ),
                  ListTile(
                    title: Text(data['batch'].toString()),
                  ),
                  ListTile(
                    title: Text(data['year'].toString()),
                  ),
                  ListTile(
                    title: Text(data['who_sent'].toString()),
                  ),
                ],
              ),
            ),
    );
  }
}
