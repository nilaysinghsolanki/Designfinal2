import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/link.dart';
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

import '../plus_controller.dart';

class EventDetailsDesign extends StatefulWidget {
  const EventDetailsDesign({Key key}) : super(key: key);
  static const routeName = '/eventdetailsdesign';

  @override
  _EventDetailsDesignState createState() => _EventDetailsDesignState();
}

class _EventDetailsDesignState extends State<EventDetailsDesign> {
  Color eventdetailsbgcolor = Color(0xffF2EFE4);
  bool initialized = false;
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Artboard _riveArtboard;
  String accessTokenValue;
  bool waiting = true;
  Map<String, dynamic> resp;
  EventDetails _eventDetails;
  ScreenArguments args;

  bool registration_animation_start = false;


  @override



  void initState()  {




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
  void registrationAnimation1() {


    if (_eventDetails.registered==true) {
      setState(() {
        _riveArtboard
            .addController(_plusAnimation = PlusAnimation('idle_registered'));

        print("////////////started2");
      });
    } else  {
      setState(() {
        _riveArtboard
            .addController(_plusAnimation = PlusAnimation('idle_unregistered'));

        print("////////////reversed2");
      });
    }
    registration_animation_start = _eventDetails.registered;
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
          event_image: resp['image'],
          latitude: num.parse(resp['latitude']));
      print('//////$resp');
      setState(() {
        waiting = false;
        initialized = true;

      });
    }


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    registrationAnimation1();
  }



  Widget build(BuildContext context) {

    bool registered;



    return initialized ?Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '${_eventDetails.name}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: eventdetailsbgcolor,
        elevation: 0,
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : Container(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  '${_eventDetails.event_image.toString()}'))),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: eventdetailsbgcolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Text(_eventDetails.description
                                .toString()
                                .substring(
                                0,
                                _eventDetails.description
                                    .toString()
                                    .indexOf('~\$') ==
                                    -1
                                    ? _eventDetails.description
                                    .toString()
                                    .length
                                    : _eventDetails.description
                                    .toString()
                                    .indexOf('~\$')))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              "Incentives",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Text(
                              _eventDetails.description
                                  .toString()
                                  .substring(
                                  _eventDetails.description
                                      .toString()
                                      .indexOf('~\$') ==
                                      -1
                                      ? 0
                                      : _eventDetails.description
                                      .toString()
                                      .indexOf('~\$') +
                                      2,
                                  _eventDetails.description
                                      .toString()
                                      .indexOf('\$~') ==
                                      -1
                                      ? 0
                                      : _eventDetails.description
                                      .toString()
                                      .indexOf('\$~')),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Link(
                          uri: Uri.parse(_eventDetails.description
                              .toString()
                              .substring(
                            _eventDetails.description
                                .toString()
                                .indexOf('\$~') ==
                                -1
                                ? 0
                                : _eventDetails.description
                                .toString()
                                .indexOf('\$~') +
                                2,
                          )),
                          target: LinkTarget.blank,
                          builder: (ctx, openLink) {
                            return TextButton.icon(
                              onPressed: openLink,
                              label: Text('${_eventDetails.type}'),
                              icon: Icon(Icons.read_more),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          "Other links",
                          style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: FloatingActionButton(
                        splashColor: Colors.transparent,
                        focusElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () async {
                          if (_plusAnimation.isActive == false) {
                            if (!_eventDetails.registered) {
                              _riveArtboard.addController(_plusAnimation =
                                  PlusAnimation('Animation'));
                              print("lol");
                            } else if (_eventDetails.registered) {
                              _riveArtboard.addController(_plusAnimation =
                                  PlusAnimation('idle_unregistered'));
                              print('lilil');
                            }


                            BuildContext bc =
                                Provider
                                    .of<MaterialNavigatorKey>(context,
                                    listen: false)
                                    .get()
                                    .currentContext;
                            var scf = Provider.of<SCF>(args.context,
                                listen: false)
                                .get();
                            registered = _eventDetails.registered
                                ? await scf.unregisterForEvent(
                                _eventDetails.id, bc)
                                : await scf.registerForEvent(
                                _eventDetails.id, bc);
                            // if (_eventDetails.registered != registered) {
                            //   //still not being added or removed from schedule
                            //  Provider.of<EventsData>(bc, listen: false)
                            //    .changeFavoriteStatus(_eventDetails.id);
                            // }

                            setState(() {
                              _eventDetails.registered = registered;
                            });
                          }
                        },
                        child: Rive(
                          artboard: _riveArtboard,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ):Container(
      color: Colors.white,
      child: Center(
          child: JumpingText(
            'loading.....',
            style: TextStyle(
                color: Colors.blueGrey[900],
                fontStyle: FontStyle.italic,
                fontSize: 50,
                fontWeight: FontWeight.w900),
          )),
    );

  if(_eventDetails.registered==null)return Container(color:Colors.purple);
  }
}
