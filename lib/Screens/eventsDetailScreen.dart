import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:nilay_dtuotg_2/models/events.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //otherwise context error
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/events.dart';
import 'package:progress_indicators/progress_indicators.dart';

class EventsDetailScreen extends StatefulWidget {
  static const routeName = '/EventsDetailScreen';
  EventsDetailScreen({Key key}) : super(key: key);

  @override
  _EventsDetailScreenState createState() => _EventsDetailScreenState();
}

class _EventsDetailScreenState extends State<EventsDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initialized = false;
  bool waiting = true;
  Map<String, dynamic> resp;
  EventDetails _eventDetails;
  ScreenArguments args;
  @override
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
                if (mounted)
                  setState(() {
                    _eventDetails.registered = registered;
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
            backgroundColor: Colors.cyan[100],
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.cyan,
              elevation: 3,
              title: Text(
                '${_eventDetails.name}',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Assets/newframe.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 22, horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Color(0xffF2EFE4), // Colors.cyan,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 54),
                        child: Image.network(
                          resp['image'].toString().replaceFirst("http", 'https'),
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
                                    Text('😢 Can\'t load image ',
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
                    ),
                    Row(
                      children: [
                        Card(
                          color: Colors.amber[100],
                          child: Container(
                            margin:
                                EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 44),
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
                          _eventDetails.description.toString().substring(
                              0,
                              _eventDetails.description
                                          .toString()
                                          .indexOf('~\$') ==
                                      -1
                                  ? _eventDetails.description.toString().length
                                  : _eventDetails.description
                                      .toString()
                                      .indexOf('~\$')),
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                    if (_eventDetails.description.toString().indexOf('~\$') != -1)
                      Card(
                        color: Color(0xffF2EFE4), // Colors.redAccent[100],
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                          padding:
                              EdgeInsets.symmetric(vertical: 33, horizontal: 44),
                          child: Text(
                            _eventDetails.description.toString().substring(
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
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Open Sans',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    if (_eventDetails.description.toString().indexOf('\$~') != -1)
                      Card(
                        color: Color(0xffF2EFE4), // Colors.redAccent[100],
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                          padding:
                              EdgeInsets.symmetric(vertical: 33, horizontal: 44),
                          child: Link(
                            uri: Uri.parse(
                                _eventDetails.description.toString().substring(
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
                                label: Text('Link '),
                                icon: Icon(Icons.read_more),
                              );
                            },
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
