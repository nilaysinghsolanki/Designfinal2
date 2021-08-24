import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:nilay_dtuotg_2/Screens/galleryView.dart';
import 'package:nilay_dtuotg_2/Screens/patchProfileData.dart';
import 'package:nilay_dtuotg_2/Screens/patchProfileData.dart';
import 'package:nilay_dtuotg_2/Screens/storyViewScreen.dart';
import 'package:nilay_dtuotg_2/Screens/testingScreen.dart';
import 'package:nilay_dtuotg_2/models/lecture.dart';
import 'package:nilay_dtuotg_2/widgets/skeleton_container.dart';
import 'package:nilay_dtuotg_2/widgets/utils.dart';
import './Screens/tabsScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Screens/enterDetailsScreen.dart';
import 'package:flutter/rendering.dart';
import './Screens/addEventScreen.dart';
import './Screens/invite_screen.dart';
import 'package:flutter/services.dart';
import './Screens/eventsDetailScreen.dart';
import 'package:nilay_dtuotg_2/Screens/authScreen.dart';
import 'package:nilay_dtuotg_2/Screens/homeTab.dart';
import 'package:nilay_dtuotg_2/Screens/loadingScreen.dart';
import 'package:nilay_dtuotg_2/Screens/scheduleTab.dart';
import 'package:nilay_dtuotg_2/plus_controller.dart';
import 'package:path/path.dart' as path;
import './models/events.dart';
import './Screens/profileDetailsScreen.dart';
import 'package:provider/provider.dart';
import './providers/info_provider.dart';
import './providers/server_connection_functions.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:progress_indicators/progress_indicators.dart';

import './models/screenArguments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'Screens/eventsdetailsDESIGN.dart';

void main() => runApp(MyApp());

var event_name;
var event_description;
bool hostorprofile=false;


List<Widget> Events = [];
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
/////////////////////COLORS


////////////////////////////PAGESNAVIGATION
bool _events_pressed = false;
bool _internship_pressed=false;
bool _project_pressed=false;
bool _adding_to_app_pressed = false;

class MyApp extends StatelessWidget {

  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;


  Artboard _riveArtboard;
  bool _events_pressed = false;
  bool _adding_to_app_pressed = false;
  GlobalKey materialNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context1) {
     ThemeData DarkTheme=ThemeData.dark();

    return MultiProvider(
      providers: [
        Provider.value(
            value: MaterialNavigatorKey(
                materialNavigatorKey: materialNavigatorKey)),
        ChangeNotifierProvider.value(value: TimeTableData()),
        Provider.value(value: SCF(Server_Connection_Functions())),
        ChangeNotifierProvider.value(value: TabsScreenContext()),
        ChangeNotifierProvider.value(value: EventsImages()),
        ChangeNotifierProvider.value(value: OwnerIdData()),
        ChangeNotifierProvider.value(value: AddEventScreenData()),
        ChangeNotifierProvider.value(value: Event()),
        ChangeNotifierProvider.value(value: EventsData()),
        ChangeNotifierProvider.value(value: ProjectData()),
        ChangeNotifierProvider.value(value: UsernameData()),
        ChangeNotifierProvider.value(value: ProfileData()),
        ChangeNotifierProvider.value(value: AccessTokenData()),
        ChangeNotifierProvider.value(value: EmailAndUsernameData())
      ],
      child: MaterialApp(


        debugShowCheckedModeBanner: false,
        navigatorKey: materialNavigatorKey, // GlobalKey()

        routes: {
          StoryViewScreen.routeName: (context) => StoryViewScreen(),
          GalleryView.routeName: (context) => GalleryView(),
          TestingScreen.routeName: (context) => TestingScreen(),
          '/ProfileDetailsScreen': (context) => ProfileDetailsScreem(),
          'patchProfileScreen': (context) => PatchProfileScreen(),
          'inviteScreen': (context) => InviteScreen(),
          'AddEventScreen': (context) => AddEventScreen(),
          '/EventsDetailScreen': (context) => EventsDetailScreen(
                key: _scaffoldKey,
              ),
          '/AuthScreen': (context) => AuthScreen(),
          '/EnterDetailsScreen': (context) => EnterDetailsScreen(),
          '/TabsScreen': (context) => TabsScreen(),
          '/schedule': (context1) => ScheduleTab(),
          '/homeScreen': (context1) => HomeScreen(),
          '/loading': (context1) => LoadingScreen(),
          '/eventdetailsdesign': (context) =>EventDetailsDesign(
                key: _scaffoldKey,
              ),
        },
        title: 'Rive Flutter Demo',
        home: LoadingScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> ScatteredListtiles = [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Builder(
        builder: (_) => ListTile(
          onTap: () async {
            var result = await Provider.of<AccessTokenData>(_, listen: false)
                .deleteAccessToken();

            print('./////logout result $result');
            if (result) Navigator.of(_).pushNamed('/AuthScreen');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.logout, color: Colors.black,),

          ),
          title: Text(
            "log out",

          ),
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

      ),
      child: Builder(
        builder: (_) => ListTile(
          onTap: () async {
            print('.patch profile..');
            Navigator.of(_).pushNamed('/patchProfileScreen');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,

          ),
          title: Text(
            "edit profile",
            style: TextStyle(


                fontSize: 20),
          ),
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), ),
      child: Builder(
        builder: (_) => ListTile(
          onTap: () {
            Navigator.of(_).pushNamed('/schedule');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Hero(tag: "tag1",child: Icon(Icons.calendar_today, color: Colors.black,)),

          ),
          title: Text(
            "Schedule",
            style: TextStyle(


                fontSize: 20),
          ),
        ),
      ),
    ),
    Builder(
      builder: (_) => ListTile(
        onTap: () {
          Navigator.of(_).pushNamed('inviteScreen');
        },
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Hero(tag: "inviteherotag",child: Icon(Icons.face_retouching_natural,color: Colors.black, )),

        ),
        title: Text(
          "invite friends",
          style: TextStyle(


              fontSize: 20),
        ),
      ),
    ),
    ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.motorcycle_rounded, color: Colors.black,),

      ),
      title: Text(
        "Catch-A-Ride",
        style: TextStyle(


            fontSize: 20),
      ),
    ),
    ListTile(

      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.report, ),

      ),
      title: Text(
        "Emergency",
        style: TextStyle(


            fontSize: 20),
      ),
    ),
    ListTile(

      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.work,color: Colors.black, ),

      ),
      title: Text(
        "Active Projects",
        style: TextStyle(


            fontSize: 20),
      ),
    ),
    Container(

      alignment: Alignment.bottomCenter,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,

        ),
        title: Text("I have a B-Plan , for selling DTU"),

        subtitle:
            Text("-Every Entrepreneur at E-cell"),
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    

    return Container(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/newframe.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: ListView(
                children: ScatteredListtiles,
              ),
            ),
          ), // Populate the Drawer in the next step.
        ),
        body: MyRiveAnimation(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////HOMEPAGE
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool initialized = false;
  PlusAnimation _plusAnimation;



  Artboard _riveArtboard;
  List<Event> evesForSchedule = [];
  List<Event> sheduled = [];
  double width = 500;
  int weekDayIndex = 1;
  bool loading=true;

  double height = 200;
  List<Event> sheduledToday = [];
  List<Event> eventsedRegester =[];
  List<Event> eventfiltered =[];
  List<NetworkImage> CachedImages=[];

  @override
  void initState() {

    super.initState();
    scf = Provider.of<SCF>(context, listen: false).get();
    eventsedRegester=Provider.of<EventsData>(context,listen:false).getEvents();
    eventsedRegester.forEach((element) {
      if(element.eventType=="University"){
        print("/////////////////////EVENT TYPE IS HERE ${element.eventType}");
        eventfiltered.add(element);
      }
    });

    // TODO: implement initState
    super.initState();
    LoadData();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/BT_animation.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard
            .addController(_plusAnimation = PlusAnimation('Animation 1'));
        _plusAnimation.instance.animation.loop = Loop.loop;
      },
    );
  }
  Future LoadData() async {



    setState(() {
      loading=false;
    });



  }

  var scf;
  bool eventsInitialized = false;

  void didChangeDependencies() async {

    print('home init');
    if (!eventsInitialized) {
      if (!Provider.of<EventsData>(context, listen: false)
          .getOnceDownloaded()) {
        scf = Provider.of<SCF>(context, listen: false).get();
        await scf.fetchListOfEvents(context);
        Provider.of<EventsData>(context, listen: false).setOnceDownloaded(true);

        // Provider.of<EventsImages>(context, listen: false).fetchList(
        //     Provider.of<EventsData>(context, listen: false).getEvents(),
        //     Provider.of<AccessTokenData>(context, listen: false)
        //         .getAccessToken());
      }


      setState(() {
        eventsInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    List<Widget> ScatteredListtiles = [
      Column(
        children: [
          SingleChildScrollView(
            child: !eventsInitialized
                ? Rive(
                  artboard: _riveArtboard,
                  alignment: Alignment.bottomCenter,
                  useArtboardSize: true,
                )
                : ListTile(
                    trailing: Text("Projects"),
                  ),
          ),
        ],
      ),
      DateTime.now().hour <= 17 && DateTime.now().hour >= 8
          ? TimeTableHomeScreenListTile()
          : ListTile(),
       loading ==false?Center(
            child: CarouselSlider.builder(
                  itemCount: eventfiltered.length,
                  itemBuilder: (context, itemIndex, pageViewIndex) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/eventdetailsdesign',
                            arguments: ScreenArguments(
                                id: eventfiltered[itemIndex].id,
                                scf: scf,
                                context: context));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: eventfiltered.length!=0?CachedNetworkImageProvider(eventfiltered[itemIndex]
                                    .event_image
                                    .toString()): AssetImage("Assets/newframe.png"))),
                        child: eventfiltered.length==0?Container(child: Text("No Upcoming events")):Container(),
                      ),
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: eventfiltered.length!=0?true:false,
                      enlargeCenterPage: false,
                      autoPlayInterval: Duration(seconds: 5),
                      height: 500,
                      viewportFraction: 1)),
          )
          : Rive(
            artboard: _riveArtboard,
            alignment: Alignment.bottomCenter,
            useArtboardSize: true,
          ),
      ListTile(
        title: Text("Internship/Job Opportunities"),
        trailing: Icon(Icons.work_outline),
      ),
    ];

    return Flexible(
      child: StaggeredGridView.countBuilder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        crossAxisCount: 4,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) =>
            AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: 0,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            horizontalOffset: 100.0,
            child: FlipAnimation(
              flipAxis: FlipAxis.y,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),

                ),
                child: Center(child: ScatteredListtiles[index]),
              ),
            ),
          ),
        ),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(2, index.isEven ? 4 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}

class TimeTableHomeScreenListTile extends StatefulWidget {
  const TimeTableHomeScreenListTile({
    Key key,
  }) : super(key: key);

  @override
  _TimeTableHomeScreenListTileState createState() =>
      _TimeTableHomeScreenListTileState();
}

class _TimeTableHomeScreenListTileState
    extends State<TimeTableHomeScreenListTile> {
  bool initialized = false;

  int weekDayIndex = 1;
  List<Lecture> lectures = [];
  Lecture _lecture;
  DateTime _selectedDay = DateTime.now();
  int lectureStart;
  int lectureEnd;

  @override
  void didChangeDependencies() async {
    if (!initialized) {
      weekDayIndex = DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday;
      await Provider.of<TimeTableData>(context, listen: false)
          .fetchAndSetData(context);
      lectures =
          Provider.of<TimeTableData>(context, listen: false).get(weekDayIndex);
      if (lectures.isNotEmpty) {
        lectures.forEach((element) {
          int hour = element.time.hour;
          int length = element.length;
          bool happeningNow = false;

          if (element.time.hour == TimeOfDay.now().hour) {
            happeningNow = true;
          } else {
            if ((element.time.hour < TimeOfDay.now().hour) &&
                ((element.time.hour + element.length) > TimeOfDay.now().hour)) {
              happeningNow = true;
            }
          }
          if (happeningNow) {
            _lecture = element;
          }
        });
      }
      setState(() {
        initialized = true;
      });
       lectureStart =
      _lecture.time.hour > 12 ? _lecture.time.hour - 12 : _lecture.time.hour;
       lectureEnd =
      lectureStart == 12 ? _lecture.length : lectureStart + _lecture.length;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {

    return initialized
        ? lectures.isNotEmpty
            ? _lecture.free
                ? GlowingProgressIndicator(child: Text('free time'))
                : ListTile(
                    title: Text(_lecture.name),
                    subtitle: Text(
                        lectureStart.toString() +
                            '-' +
                            '${lectureEnd.toString()}',
                    ),

                    trailing: GlowingProgressIndicator(
                      child: Icon(Icons.schedule),
                    ),
                    onTap: () {})
            : Text('No lectures')
        : Center(
            child: FadingText('Loading...'),
          );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ADDEVENTSPAGE
class AddEventsPage extends StatefulWidget {
  const AddEventsPage({Key key}) : super(key: key);

  @override
  _AddEventsPageState createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(

          'new Event',
          style: TextStyle( fontSize: 30),
        ),


      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      event_name_changed = "$NameOfEvent";
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      event_description_channged = "$DescriptionOfEvent";
                    }),
              ),
            ),
            FloatingActionButton(

                onPressed: () {
                  event_description = event_description_channged;
                  event_name = event_name_changed;

                  Events.add(Card(
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.star,

                      ),
                      title: Text(event_name),
                      subtitle: Text(event_description),
                    ),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}

//////////////////////////ADDTOSCHEDULEPAGE
class AddToSchedulePage extends StatefulWidget {
  const AddToSchedulePage({Key key}) : super(key: key);

  @override
  _AddToSchedulePageState createState() => _AddToSchedulePageState();
}

class _AddToSchedulePageState extends State<AddToSchedulePage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Event Details",
          style: TextStyle(),
        ),



      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("Assets/newframe.png"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,

                  child: TextField(
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide( width: 4),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide( width: 3),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "Name of the event",
                          helperText: 'Keep it short, this is just a beta.',

                          labelStyle:
                              TextStyle( fontSize: 30),
                          ),
                      onChanged: (NameOfEvent) {
                        print("The value entered is : $NameOfEvent");
                        event_name_changed = "$NameOfEvent";
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,

                  child: TextField(
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide( width: 4),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide( width: 3),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "Description",
                          helperText: 'Keep it short, this is just a beta.',

                          labelStyle:
                              TextStyle( fontSize: 30),
                          ),
                      onChanged: (DescriptionOfEvent) {
                        print("The value entered is : $DescriptionOfEvent");
                        event_description_channged = "$DescriptionOfEvent";
                      }),
                ),
              ),
              FloatingActionButton(

                  onPressed: () {
                    event_description = event_description_channged;
                    event_name = event_name_changed;

                    Events.add(Card(
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.star,

                        ),
                        title: Text(event_name),
                        subtitle: Text(event_description),
                      ),
                    ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ADDPROJECTPAGE
class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key key}) : super(key: key);

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      event_name_changed = "$NameOfEvent";
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      event_description_channged = "$DescriptionOfEvent";
                    }),
              ),
            ),
            FloatingActionButton(
                child: Icon(
                  Icons.check,

                ),

                onPressed: () {
                  event_description = event_description_channged;
                  event_name = event_name_changed;

                  if (event_description_channged == null ||
                      event_name_changed == null) {
                    Events.add(Card(
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.star,

                        ),
                        title: Text(event_name),
                        subtitle: Text(event_description),
                      ),
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////PROJECTPAGE
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key key}) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List <Event> eventsedRegester;
  List <String> imagesstring=[];
  List <Event> eventfiltered=[];
  bool initialized = false;
  Map<String, dynamic> data;
  ScreenArguments args;
  bool host_pressed=false;

  @override
  void didChangeDependencies() async {


    if (!initialized) {
      BuildContext ctx =
          Provider.of<MaterialNavigatorKey>(context, listen: false)
              .materialNavigatorKey
              .currentContext;
      data =host_pressed==true? await Server_Connection_Functions().getHostData(context, args.username): await Server_Connection_Functions().getProfileData(ctx);
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
    return  Expanded(
      child: Container(
        child: !initialized
              ? Center(
            child: Container(child: FadingText('Loading...')),
          )
              : Container(

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

                                          fontStyle: FontStyle.normal,


                                          fontFamily: 'DancingScript',
                                          fontSize: 20)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('name - ' + data['name'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),
                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('roll no. ' + data['roll_no'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),
                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('Branch ' + data['branch'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),

                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('Batch ' + data['batch'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),

                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('year ' + data['year'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),
                    Card(

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text('invited by ' + data['who_sent'].toString(),
                            style: TextStyle(

                                fontStyle: FontStyle.normal,


                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),

                    // Card(
                    //
                    //   child: Container(
                    //     margin:
                    //         EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                    //     padding:
                    //         EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                    //     child: Text('roll no. ' + data['roll_no'].toString(),
                    //         style: TextStyle(
                    //
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
      ),
    );
  }
}

/////////////////////////////////////////////////INTERNSHIPPAGE
class InternshipsPage extends StatefulWidget {
  const InternshipsPage({Key key}) : super(key: key);

  @override
  _InternshipsPageState createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {
  List <Event> eventsedRegester;
  List <String> imagesstring=[];
  List <Event> eventfiltered=[];

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override

  @override
  Widget build(BuildContext context) {
    scf = Provider.of<SCF>(context, listen: false).get();
    eventsedRegester=Provider.of<EventsData>(context,listen:false).getEvents();
    eventsedRegester.forEach((element) {
      if(element.eventType=="Social"){
        print("/////////////////////EVENT TYPE IS HERE ${element.eventType}");
        eventfiltered.add(element);
      }
    });

    return Expanded(
      child:Container(
        alignment: Alignment.center,

        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return SingleChildScrollView(
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 350),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FlipAnimation(
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: eventfiltered.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  height: 400,

                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              '${eventfiltered[index].event_image.toString()}',
                                            ),
                                            fit: BoxFit.fitHeight),
                                        shape: BoxShape.rectangle),
                                  ),
                                ),
                              ),
                              ListTile(




                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/eventdetailsdesign',
                                        arguments: ScreenArguments(
                                            id: eventfiltered[index].id,
                                            scf: scf,
                                            context: context));
                                  },

                                  subtitle: Text(
                                      eventfiltered[index].owner.toString(),
                                      style: TextStyle(
                                          fontFamily: 'DancingScript'
                                      )

                                  ),
                                  trailing: eventfiltered[index].favorite
                                      ?Icon(Icons.star,):Icon(Icons.star_border,),
                                  leading: TextButton(
                                    onPressed:(){ setState(() {
                                      hostorprofile=true;
                                    });Navigator.of(context).pushNamed('/ProfileDetailsScreen',arguments: ScreenArguments(
                                        username: eventfiltered[index].owner,hostpressed: hostorprofile

                                    ) );},
                                    child: CircleAvatar(
                                      radius: 22,

                                      child: CircleAvatar(


                                          radius: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        '${eventfiltered[index].owner_image.toString()}'),
                                                    fit: BoxFit.fill),
                                                shape: BoxShape.circle),
                                          )),
                                    ),
                                  ),
                                  title: Text(
                                    eventfiltered[index].name,
                                    style: TextStyle(
                                         fontSize: 19,fontFamily: 'DancingScript'),
                                  )),
                              Divider(height: 20,thickness: 2,),
                            ],
                          );
                        }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////EVENTSPAGE

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

var scf;

class _EventsPageState extends State<EventsPage> {
  bool loading =true;
  List <Event> eventsedRegester;
  List <String> imagesstring=[];
  List <Event> eventfiltered=[];



  @override
  void initState() {

    scf = Provider.of<SCF>(context, listen: false).get();
    eventsedRegester=Provider.of<EventsData>(context,listen:false).getEvents();
    eventsedRegester.forEach((element) {
      if(element.eventType=="University"){
        print("/////////////////////EVENT TYPE IS HERE ${element.eventType}");
        eventfiltered.add(element);
      }
    });

    // TODO: implement initState
    super.initState();
    LoadData();
    print("///////////////////////////INITIATED");

  }
  Future LoadData() async {



    if (!mounted) return;
    setState(() {
      loading=false;
    });


print("//////////////////////////////LOADED");
  }

  @override
void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("//////////////////////////////BUILDING");



    return Expanded(
      child:Container(
        alignment: Alignment.center,

        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return SingleChildScrollView(
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 350),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FlipAnimation(
                    child: ListView.builder(

                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: eventfiltered.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Center(
                                child: loading?SkeletonContainer.square(
                                  width: 22,
                                  height: 22,

                                ):TextButton(
                                  onPressed:(){ setState(() {
                                    hostorprofile=true;
                                  });Navigator.of(context).pushNamed('/ProfileDetailsScreen',arguments: ScreenArguments(
                                      username: eventfiltered[index].owner,hostpressed: hostorprofile

                                  ) );},
                                  child: CircleAvatar(
                                    radius: 22,

                                    child: CircleAvatar(


                                        radius: 20,
                                        child: !loading?Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      '${eventfiltered[index].owner_image.toString()}'),
                                                  fit: BoxFit.fill),
                                              shape: BoxShape.circle),
                                        ):SkeletonContainer.square(
                                          width: 100,
                                          height: 20,

                                        )),
                                  ),
                                ),
                              ),

                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed(
                                  '/eventdetailsdesign',
                                  arguments: ScreenArguments(
                                      id: eventfiltered[index].id,
                                      scf: scf,
                                      context: context));
                            },
                            child: Container(
                            width: double.infinity,
                            height: 400,

                            child: loading?SkeletonContainer.square(
                            width: 400,
                            height: 400,

                            ):Container(
                               decoration: BoxDecoration(
                            image: DecorationImage(
                            image: CachedNetworkImageProvider( '${eventfiltered[index].event_image.toString()}',errorListener: (){

                            }

                            ),
                            fit: BoxFit.fitHeight),
                            ),
                            ),
                            ),
                          ),
                              ListTile(




                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/eventdetailsdesign',
                                        arguments: ScreenArguments(
                                            id: eventfiltered[index].id,
                                            scf: scf,
                                            context: context));
                                  },

                                  subtitle: loading?SkeletonContainer.square(
                                    width: 10,
                                    height: 10,

                                  ):Text(
                                      "${eventfiltered[index].dateime.day.toString()} .${eventfiltered[index].dateime.month.toString()  }",
                                      style: TextStyle(
                                          fontFamily: 'DancingScript'
                                      )

                                  ),
                                  trailing: loading?SkeletonContainer.square(
                                    width: 10,
                                    height: 10,

                                  ):eventfiltered[index].favorite
                                      ?Icon(FontAwesomeIcons.solidStar,):Icon(FontAwesomeIcons.star,),

                                  title: loading?SkeletonContainer.square(
                                    width: 10,
                                    height: 10,

                                  ):Text(
                                    eventfiltered[index].name,
                                    style: TextStyle(
                                         fontSize: 19,fontFamily: 'DancingScript'),
                                  )),

                            ],
                          );
                        }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

////////////////////CUSTOMPAGE
class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(

              fontStyle: FontStyle.normal,


              fontFamily: 'DancingScript',
              fontSize: 20),
        ),


      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      setState(() {
                        event_name_changed = "$NameOfEvent";
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,

                child: TextField(
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',

                        labelStyle:
                            TextStyle( fontSize: 30),
                        ),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      setState(() {
                        event_description_channged = "$DescriptionOfEvent";
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: FloatingActionButton.extended(
                  label: Text(
                    'save',
                    style: TextStyle(

                        fontSize: 20),
                  ),
                  icon: Icon(
                    Icons.check,

                  ),

                  onPressed: () {
                    event_description = event_description_channged;
                    event_name = event_name_changed;
                    if (event_name_changed != null &&
                        event_description_channged != null) {
                      Events.add(Card(
                        child: ListTile(
                          leading: Icon(
                            FontAwesomeIcons.star,

                          ),
                          title: Text(event_name),
                          subtitle: Text(event_description),
                        ),
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('event saved'),

                      ));
                    }

                    if (event_name_changed != null &&
                        event_description_channged != null)
                      Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////ADDINGPAGE
class AddingPage extends StatefulWidget {
  @override
  _AddingPageState createState() => _AddingPageState();
}

class _AddingPageState extends State<AddingPage> {
  PlusAnimation _plusAnimation;
  double width = 500;
  double height = 200;


  Artboard _riveArtboard;
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/appbar.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Idle'));
      },
    );
  }

  void _events_page_function(bool _eventspressed) {
    if (_adding_to_app_pressed == false) {
      if (_events_pressed == true) {


        setState(() {
          _events_pressed = _eventspressed;
        });
      }

    }
  }

  void _adding_page_open_function(bool _adding_page_active) {
    if (_plusAnimation == null) {
      _riveArtboard.addController(
        _plusAnimation = PlusAnimation('Plus'),
      );
    }

    if (_adding_page_active == true) {
      _plusAnimation.start();
    } else {
      _plusAnimation.reverse();
    }

    setState(() {
      if (_adding_page_active == true) {
        _plusAnimation.isActive = false;
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Plus'));

        print("_adding_page_active");
      }
      _adding_to_app_pressed = _adding_page_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Icon> myicons = [
      Icon(
        FontAwesomeIcons.star,

      ),
      Icon(
        Icons.schedule_outlined,

      ),
      Icon(
        FontAwesomeIcons.tasks,

      ),
    ];
    List<Text> titlelist = [
      Text("Add to Events"),
      Text("Add to Schedule"),
      Text("Share details about Projects"),
    ];
    List<Text> subtitlelist = [
      Text(
          "Update via this feature to let people know the details of any event"),
      Text(
          "Update your personal schedule with new tasks assigned like self study,sports.etc"),
      Text(
          "Update via this feature to let people know the details of any projects in DTU, looking for Volunteers"),
    ];
    List<Card> AddingButtons = [
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              //  Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CustomPage()));
              Navigator.of(context).pushNamed('AddEventScreen', arguments: 1);
            },
            leading: Icon(
              FontAwesomeIcons.star,

            ),
            title: Text("Add to Events"),
            subtitle: Text(
                "Update via this feature to let people know the details of any event"),
          ),
        ),
      ),
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              //  Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CustomPage()));
              Navigator.of(context).pushNamed('AddEventScreen', arguments: 2);
            },
            leading: Icon(
              Icons.update,

            ),
            title: Text("Add to Stories"),
            subtitle: Text(
                "Update about various public events and achievements your society "),
          ),
        ),
      ),
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              //  Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CustomPage()));
              Navigator.of(context).pushNamed('AddEventScreen', arguments: 3);
            },
            leading: Icon(
            Icons.work_outline,

            ),
            title: Text("Add to internships/jobs"),
            subtitle: Text(
                "Update via this feature to let people know the details about various internships/Jobs/Projects related opportunities for students"),
          ),
        ),
      ),
      // Card(
      //   elevation: 0,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: ListTile(
      //       onTap: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => AddToSchedulePage()));
      //       },
      //       leading: Icon(
      //         Icons.schedule_outlined,
      //
      //       ),
      //       title: Text("Add to Schedule",
      //       subtitle: Text(
      //           "Update your personal schedule with new tasks assigned like self study,sports.etc"),
      //     ),
      //   ),
      // ),
    ];

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FlipAnimation(child: AddingButtons[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////RIVEANIMATION

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;

  bool initialized = false;
  Artboard _riveArtboard;
  var scf;
  List<Event> sheduledToday = [];

  bool eventsInitialized = false;
  bool storycontinues=false;
  int j=1;

  @override
  void didChangeDependencies() async {
    if (!initialized) {
      if (!Provider.of<EventsData>(context, listen: false)
          .getOnceDownloaded()) {
        scf = Provider.of<SCF>(context, listen: false).get();
        await scf.fetchListOfEvents(context);
        Provider.of<EventsData>(context, listen: false).setOnceDownloaded(true);

        // Provider.of<EventsImages>(context, listen: false).fetchList(
        //     Provider.of<EventsData>(context, listen: false).getEvents(),
        //     Provider.of<AccessTokenData>(context, listen: false)
        //         .getAccessToken());
      }
      sheduledToday =
          Provider.of<EventsData>(context, listen: false).getEvents();

      setState(() {
        initialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {

    super.initState();


    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/appbar.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Riv widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Idle'));
      },
    );
  }

  void _events_page_function(bool _eventspressed) {
    if (_adding_to_app_pressed == false) {
      if (_events_pressed == true) {


        setState(() {
          _events_pressed = _eventspressed;
        });
      }

    }
  }
  void _Project_page_function(bool _projectpressed) {
    if (_adding_to_app_pressed == false) {
      if (_project_pressed == true) {


        setState(() {
          _project_pressed = _projectpressed;
        });
      }

    }
  }
  void _Internship_page_function(bool _internshippressed) {
    if (_adding_to_app_pressed == false) {
      if (_project_pressed == true) {


        setState(() {
          _internship_pressed= _internshippressed;
        });
      }

    }
  }

  void _adding_page_open_function(bool _adding_page_active) {

    if (_plusAnimation == null) {
      _riveArtboard.addController(
        _plusAnimation = PlusAnimation('Plus'),
      );
    }

    if (_adding_page_active == true) {
      _plusAnimation.start();

    } else {
      _plusAnimation.reverse();
      if (_events_pressed == true) {

      } else if (_events_pressed == false) {

      }
    }

    setState(() {
      if (_adding_page_active == true) {
        _plusAnimation.isActive = false;
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Plus'));

        print("_adding_page_active");
      }
      _adding_to_app_pressed = _adding_page_active;
    });
  }

  String owner = '';


  @override
  Widget build(BuildContext context) {
    List<List<Event>> ownersEvents = [];

    List <Event>storiesFiltered=[];
    ScreenArguments args = ModalRoute
        .of(context)
        .settings
        .arguments;
    if(j!=1){
storycontinues=true;

    }
    sheduledToday.forEach((element) {
      if(element.eventType=="Society" )
        storiesFiltered.add(element);

    });


    for (int i = 0; i < storiesFiltered.length; i++) {

      if (ownersEvents.indexWhere(
              (element) => element[0].owner == storiesFiltered[i].owner) !=
          -1) {
        ownersEvents[ownersEvents.indexWhere(
                (element) => element[0].owner == storiesFiltered[i].owner)]
            .add(storiesFiltered[i]);
      } else {
        ownersEvents.add([storiesFiltered[i]]);
      }
    }
    print(ownersEvents.length);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("Assets/newframe.png"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: !initialized
          ? Center(
          child:Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/LogoOTG.png"),
                  fit: BoxFit.cover,
                ),


              )
          ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_adding_to_app_pressed == false && _events_pressed == false && _project_pressed==false && _internship_pressed==false)
                  Container(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: ownersEvents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(

                          onTap: () {
                            j=0;
                            j++;

                            Navigator.of(context).pushNamed(
                              StoryViewScreen.routeName,
                              arguments: ScreenArguments(
                                id: !storycontinues?index:args.id,
                                  eves: !storycontinues?ownersEvents[
                                      index]:ownersEvents[
                                  args.id],ownerlist:  ownersEvents), // sheduledToday[index].event_image,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            child: CircleAvatar(

                              radius: 30,
                              child: CircleAvatar(

                                radius: 27,
                                backgroundImage: storiesFiltered.isNotEmpty?CachedNetworkImageProvider(

                                    ownersEvents[index][0].owner_image,
                                    scale: 0.5): AssetImage("Assets/newframe.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (_adding_to_app_pressed == true)
                  Container(
                    height: 200,
                  ),

                //NAVIGATION OF PAGES
                if (_adding_to_app_pressed == true)
                  AddingPage()
                else if (_events_pressed == true)
                  EventsPage()
                  else if(_internship_pressed==true)
                    InternshipsPage()
                    else if(_project_pressed==true)
                      ProjectsPage()
                else
                  HomePage(),

                Container(
                  padding: EdgeInsets.all(0),
                  width: width,

                  child: _riveArtboard == null
                      ? const SizedBox()
                      : GestureDetector(
                          onTapUp: (tapinfo) {
                            var localtouchposition =
                                (context.findRenderObject() as RenderBox)
                                    .globalToLocal(tapinfo.globalPosition);

                            var tophalftouched =
                                localtouchposition.dy < height / 2;
                            var hometouched = localtouchposition.dx < width / 6;
                            var internshiptouched =
                                localtouchposition.dx < 2 * (width / 6);
                            var profiletouched = localtouchposition.dx < width;
                            var lowerblanktouched =
                                localtouchposition.dx < 3 * (width / 6);
                            var eventstouched =
                                localtouchposition.dx < 5 * (width / 8);

                            if (!tophalftouched) {
                              if (hometouched) {
                                if (!_adding_to_app_pressed) {
                                  setState(() {
                                    if (_events_pressed == true) {
                                      _events_pressed = !_events_pressed;



                                    }
                                    if(_internship_pressed==true){
                                      _internship_pressed=!_internship_pressed;
                                    }
                                    if(_project_pressed==true){
                                      _project_pressed=!_project_pressed;
                                    }
                                    _plusAnimation.isActive = false;
                                    _riveArtboard.addController(
                                        _plusAnimation =
                                            PlusAnimation('home'));
                                  });
                                }
                              } else if (internshiptouched) {
                                if (!_adding_to_app_pressed) {
                                  setState(() {
                                    _internship_pressed = !_internship_pressed;
                                    _events_pressed=false;
                                    _project_pressed=false;
                                    _Internship_page_function(_internship_pressed);
                                    _plusAnimation.isActive = false;
                                    _riveArtboard.addController(_plusAnimation =
                                        PlusAnimation('internship'));
                                  });
                                }
                              } else if (lowerblanktouched) {
                                setState(() {

                                  _adding_to_app_pressed =
                                      !_adding_to_app_pressed;
                                  _adding_page_open_function(
                                      _adding_to_app_pressed);
                                });
                              } else if (eventstouched) {
                                if (!_adding_to_app_pressed) {
                                  setState(() {
                                    _events_pressed = !_events_pressed;
                                    _internship_pressed=false;
                                    _project_pressed=false;
                                    _events_page_function(_events_pressed);
                                    _plusAnimation.isActive = false;
                                    _riveArtboard.addController(_plusAnimation =
                                        PlusAnimation('events'));
                                  });
                                }
                              } else if (profiletouched) {
                                if (!_adding_to_app_pressed) {
                                  setState(() {
                                    _project_pressed =!_project_pressed;
                                    _events_pressed=false;
                                    _internship_pressed=false;
                                    _Project_page_function(_project_pressed);
                                    _plusAnimation.isActive = false;
                                    _riveArtboard.addController(_plusAnimation =
                                        PlusAnimation('profile'));
                                    print("Profile Touched");
                                  });


                                }
                              }
                            } else {
                              setState(() {
                                _adding_to_app_pressed =
                                    !_adding_to_app_pressed;
                                _adding_page_open_function(
                                    _adding_to_app_pressed);
                              });
                            }
                          },
                          child: Container(

                            child: Rive(
                              artboard: _riveArtboard,
                              alignment: Alignment.bottomCenter,
                              useArtboardSize: true,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
