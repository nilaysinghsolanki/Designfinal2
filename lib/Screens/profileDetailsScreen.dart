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
        title: Text('Your profile',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 20)),
        backgroundColor: Colors.cyan,
      ),
      body: !initialized
          ? Center(
              child: FadingText('Loading...'),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/newframe.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        return Card(
                          color: Colors.cyan,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 44),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 55,
                                ),
                                Text('😢 Can\'t load image',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Open Sans',
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.redAccent[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text('name - ' + data['name'].toString(),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20)),
                    ),
                  ),
                  Card(
                    color: Colors.amber[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text('roll no. ' + data['roll_no'].toString(),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20)),
                    ),
                  ),
                  Card(
                    color: Colors.redAccent[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text('Branch ' + data['branch'].toString(),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20)),
                    ),
                  ),

                  Card(
                    color: Colors.amber[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text('Batch ' + data['batch'].toString(),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20)),
                    ),
                  ),

                  Card(
                    color: Colors.redAccent[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text('year ' + data['year'].toString(),
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20)),
                    ),
                  ),

                  // Card(
                  //   color: Colors.amber[100],
                  //   child: Container(
                  //     margin:
                  //         EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                  //     child: Text('roll no. ' + data['roll_no'].toString(),
                  //         style: TextStyle(
                  //             color: Colors.grey[800],
                  //             fontWeight: FontWeight.w900,
                  //             fontStyle: FontStyle.italic,
                  //             fontFamily: 'Open Sans',
                  //             fontSize: 20)),
                  //   ),
                  // ),
                  // ListTile(
                  //   title: Text(data['who_sent'].toString()),
                  // ),
                ],
              )),
            ),
    );
  }
}
