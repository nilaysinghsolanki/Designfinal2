import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../plus_controller.dart';
import '../providers/info_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:nilay_dtuotg_2/models/events.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //otherwise context error
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../plus_controller.dart';
import '../providers/info_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/events.dart';
import 'package:progress_indicators/progress_indicators.dart';

class EventsDetailScreen extends StatefulWidget {
  static const routeName = '/EventsDetailScreen';
  EventsDetailScreen({Key key}) : super(key: key);
  bool initialized = false;
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Color newcolor = Colors.transparent;

  Artboard _riveArtboard;
  String accessTokenValue;


  @override


  _EventsDetailScreenState createState() => _EventsDetailScreenState();
}

class _EventsDetailScreenState extends State<EventsDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initialized = false;


  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Color newcolor = Colors.transparent;

  Artboard _riveArtboard;
  RiveAnimationController alpha;
  bool waiting = true;
  Map<String, dynamic> resp;
  EventDetails _eventDetails;
  ScreenArguments args;
  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/Registration_animation.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.
        setState(() => _riveArtboard = artboard);

      },
    );
  }
  void registrationAnimation1(){

      
      _riveArtboard
          .addController(_plusAnimation = PlusAnimation('Animation'));
      if (_eventDetails.registered) {
        setState(() {
          _plusAnimation.start();
          _riveArtboard
              .addController(_plusAnimation = PlusAnimation('idle_registered'));

          print("////////////started");
        });
      }
      else {
        setState(() {
          _plusAnimation.reverse();
          print("////////////reversed");
        });
      }
      print("//////////////////////Registration_animation1_worked");
    }



  void didChangeDependencies() async {
    args = ModalRoute.of(context).settings.arguments;
    int eventID = args.id;
    if (!initialized) {
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      var accessTokenValue = accessToken[0];
      Map<String, String> headersEventDetails = {
        "Content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $accessTokenValue"
      };
      http.Response response = await http.get(
        Uri.https('dtuotg.azurewebsites.net', 'events/details/$eventID'),
        headers: headersEventDetails,
      );
      print('/////////$eventID');
      int statusCode = response.statusCode;
      resp = json.decode(response.body);
      print('//////$resp');
      _eventDetails = EventDetails(
          id: resp['id'],
          owner: resp['owner'] == null ? ' ' : ' ',
          name: resp['name'],
          longitute: num.parse(resp['longitude']),
          description: resp['description'],
          duration: resp['duration'],
          registered: resp['registered'],
          type: resp['type_event'],
          count: resp['count'],
          dateTime: DateTime.parse(resp['date_time']),
          latitude: num.parse(resp['latitude']));
      print('//////$resp');
      initialized = true;
      setState(() {
        waiting = false;
      });

    }


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    registrationAnimation1();
    bool registered_animation_play;
    void registrationAnimation(){


    }

    return waiting
        ? Scaffold(
            backgroundColor: Colors.cyan[200],
            body: Center(
              child: FadingText('Loading...'),
            ),
          )
        : Scaffold(

            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              onPressed: () async {
                BuildContext bc =
                    Provider.of<MaterialNavigatorKey>(context, listen: false)
                        .get()
                        .currentContext;
                var scf = Provider.of<SCF>(args.context, listen: false).get();
                bool registered = _eventDetails.registered
                    ? await scf.unregisterForEvent(_eventDetails.id, bc)
                    : await scf.registerForEvent(_eventDetails.id, bc);
                // if (_eventDetails.registered != registered) {
                //   //still not being added or removed from schedule
                //  Provider.of<EventsData>(bc, listen: false)
                //    .changeFavoriteStatus(_eventDetails.id);
                // }


                  setState(() {
                    _eventDetails.registered = registered;

                    registrationAnimation1();
                    print("////////////////Registration_animation_worked");
                   });

              },
              label: Text(
                _eventDetails.registered ? 'registered' : 'register',
                style: TextStyle(
                  color:
                      _eventDetails.registered ? Colors.redAccent : Colors.blue,
                ),
              ),
              icon: Icon(
                _eventDetails.registered
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    _eventDetails.registered ? Colors.redAccent : Colors.blue,
              ),
            ),

            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 3,
              title: Text(
                '${_eventDetails.name}',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("Assets/newframe.png"),
    fit: BoxFit.cover,
    ),
    ),



              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FloatingActionButton(elevation: 0,backgroundColor: Colors.transparent,onPressed: () async {
                    BuildContext bc =
                        Provider.of<MaterialNavigatorKey>(context, listen: false)
                            .get()
                            .currentContext;
                    var scf = Provider.of<SCF>(args.context, listen: false).get();
                    bool registered = _eventDetails.registered
                        ? await scf.unregisterForEvent(_eventDetails.id, bc)
                        : await scf.registerForEvent(_eventDetails.id, bc);
                    // if (_eventDetails.registered != registered) {
                    //   //still not being added or removed from schedule
                    //  Provider.of<EventsData>(bc, listen: false)
                    //    .changeFavoriteStatus(_eventDetails.id);
                    // }
                    if (mounted)
                      setState(() {
                        _eventDetails.registered = registered;
                        print("/////////////////Registered");

                      });
                  },
              child:
              Rive(
                artboard: _riveArtboard,
              ),
                  ),
                  Image.network(
                    resp['image'],
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      // Appropriate logging or analytics, e.g.
                      // myAnalytics.recordError(
                      //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                      //   exception,
                      //   stackTrace,
                      // );
                      return Container(

                      );
                    },
                  ),
                  Row(
                    children: [
                      Card(
                        color: Colors.amber[100],
                        child: Container(


                          child: Text('Date',
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
                          margin:
                              EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                          padding: EdgeInsets.symmetric(
                              vertical: 11, horizontal: 11),
                          child: Text(
                              '${_eventDetails.dateTime.day} / ${_eventDetails.dateTime.month} / ${_eventDetails.dateTime.year}',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Open Sans',
                                  fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    color: Color(0xffF2EFE4), // Colors.redAccent[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 33, horizontal: 44),
                      child: Text(
                        '${_eventDetails.description}',
                        style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.amber[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text(
                        'Happening in - DTU',
                        style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.redAccent[100],
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Text(
                        'People registered  ${_eventDetails.count.toString()}',
                        style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
/*  Container(
        child: Center(
            child: waiting
                ? CircularProgressIndicator()
                : ListView(
                    children: [
                      ListTile(
                        title: Text('id:  ${_eventDetails.id.toString()}'),
                      ),
                      ListTile(
                        title: Text('owner ${_eventDetails.owner}'),
                      ),
                      ListTile(
                        title: Text('name ${_eventDetails.name}'),
                      ),
                      ListTile(
                        title: Text(
                            'latitude ${_eventDetails.latitude.toString()}'),
                      ),
                      ListTile(
                        title: Text(
                            'longitude ${_eventDetails.longitute.toString()}'),
                      ),
                      ListTile(
                        title: Text('description ${_eventDetails.description}'),
                      ),
                      ListTile(
                        title: Text(
                            'day${_eventDetails.dateTime.day}month${_eventDetails.dateTime.month}'),
                      ),
                      ListTile(
                        title: Text('duration ${_eventDetails.duration}'),
                      ),
                      ListTile(
                        title: Text('type ${_eventDetails.type}'),
                      ),
                      ListTile(
                        onTap: () async {
                          BuildContext bc = Provider.of<MaterialNavigatorKey>(
                                  context,
                                  listen: false)
                              .get()
                              .currentContext;
                          var scf =
                              Provider.of<SCF>(args.context, listen: false)
                                  .get();
                          bool registered = _eventDetails.registered
                              ? await scf.unregisterForEvent(
                                  _eventDetails.id, bc)
                              : await scf.registerForEvent(
                                  _eventDetails.id, bc);
                          // if (_eventDetails.registered != registered) {
                          //   //still not being added or removed from schedule
                          //  Provider.of<EventsData>(bc, listen: false)
                          //    .changeFavoriteStatus(_eventDetails.id);
                          // }
                          if (mounted)
                            setState(() {
                              _eventDetails.registered = registered;
                            });
                        },
                        tileColor: _eventDetails.registered
                            ? Colors.redAccent
                            : Colors.blue,
                        title: Text(
                            'registered ${_eventDetails.registered.toString()}'),
                      ),
                      ListTile(
                        title: Text('count ${_eventDetails.count.toString()}'),
                      )
                    ],
                  )),
      ) */
