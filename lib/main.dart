
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:timelines/timelines.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nilay_dtuotg_2/Screens/galleryView.dart';
import 'package:nilay_dtuotg_2/Screens/patchProfileData.dart';
import 'package:nilay_dtuotg_2/Screens/patchProfileData.dart';
import 'package:nilay_dtuotg_2/Screens/storyViewScreen.dart';
import 'package:nilay_dtuotg_2/Screens/testingScreen.dart';
import 'package:nilay_dtuotg_2/models/lecture.dart';
import 'package:nilay_dtuotg_2/widgets/skeleton_container.dart';
import 'package:nilay_dtuotg_2/widgets/utils.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
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

import 'Designs/Projectlist.dart';
import 'Screens/eventsdetailsDESIGN.dart';
import 'helper/db_helper.dart';

void main() => runApp(MyApp());

var event_name;
var event_description;
bool hostorprofile = false;

List<Widget> Events = [];
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
/////////////////////COLORS

////////////////////////////PAGESNAVIGATION
bool _events_pressed = false;
bool _internship_pressed = false;
bool _project_pressed = false;
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
    ThemeData DarkTheme = ThemeData.dark();

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
          '/eventdetailsdesign': (context) => EventDetailsDesign(
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
  ScreenArguments args;
  HomeScreen({Key key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  double width;
  double height;


  bool initialized = false;

  var scf;
  List<Event> sheduledToday = [];

  List<AssetImage> listofimages=[
AssetImage('Assets/expertrons.jpg'),
    AssetImage('Assets/finotize.png'),
    AssetImage('Assets/Finstreet.png'),
    AssetImage('Assets/icreate.jpg'),
    AssetImage('Assets/inmo.png'),
    AssetImage('Assets/Learning_While_Travelling_TM_png.png'),
    AssetImage('Assets/myways.png'),
    AssetImage('Assets/niyo.png'),
    AssetImage('Assets/jetbrains.png'),
    AssetImage('Assets/duexpress.webp'),
    AssetImage('Assets/adcom.jpg'),






  ];
  List<String> listofimageslinks=[
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/","https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",
    "https://ecelldtu.in/",

  ];


  bool eventsInitialized = false;
  bool storycontinues = false;
  int j = 1;
  List<Widget> _children;

  @override
  void didChangeDependencies() async {
    _children = [
      Column(
        children: [
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/10,
              child: Center(

                child: CarouselSlider.builder(
                    itemCount: listofimages.length,
                    itemBuilder: (context, itemIndex, pageViewIndex) {
                      return GestureDetector(
                        onTap: () {
                          launch(listofimageslinks[itemIndex]);


                        },
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,

                                  image: listofimages[itemIndex])),
                          child:
                          Container(),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: listofimages.length != 0 ? true : false,
                      enlargeCenterPage: false,
                      autoPlayInterval: Duration(seconds: 5),
                      height: 200,
                    )),
              ),
            ),
          ),

          Expanded(child: HomePage())
        ],
      ),
      InternshipsPage(),AddingPage()
    ];

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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
            child: Icon(
              Icons.lightbulb,
              color: Colors.white,
            ),
          ),
          title: Text(

            "Our Initiatives",
            style:TextStyle(color:Colors.white ),
          ),
        ),
      ),
    ),
    // Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   child: Builder(
    //     builder: (_) => ListTile(
    //       onTap: () async {
    //         print('.patch profile..');
    //         Navigator.of(_).pushNamed('patchProfileScreen');
    //       },
    //       leading: CircleAvatar(
    //         backgroundColor: Colors.transparent,
    //       ),
    //       title: Text(
    //         "edit profile",
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ),
    //   ),
    // ),
    // Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   child: Builder(
    //     builder: (_) => ListTile(
    //       onTap: () {
    //         Navigator.of(_).pushNamed('/schedule');
    //       },
    //       leading: CircleAvatar(
    //         backgroundColor: Colors.transparent,
    //         child: Hero(
    //             tag: "tag1",
    //             child: Icon(
    //               Icons.calendar_today,
    //               color: Colors.white,
    //             )),
    //       ),
    //       title: Text(
    //         "Schedule",
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ),
    //   ),
    // ),
    // Builder(
    //   builder: (_) => ListTile(
    //     onTap: () {
    //       Navigator.of(_).pushNamed('inviteScreen');
    //     },
    //     leading: CircleAvatar(
    //       backgroundColor: Colors.transparent,
    //       child: Hero(
    //           tag: "inviteherotag",
    //           child: Icon(
    //             Icons.face_retouching_natural,
    //             color: Colors.white,
    //           )),
    //     ),
    //     title: Text(
    //       "invite friends",
    //       style: TextStyle(fontSize: 20),
    //     ),
    //   ),
    // ),
    // ListTile(
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     child: Icon(
    //       Icons.motorcycle_rounded,
    //       color: Colors.white,
    //     ),
    //   ),
    //   title: Text(
    //     "Catch-A-Ride",
    //     style: TextStyle(fontSize: 20),
    //   ),
    // ),
    // ListTile(
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     child: Icon(
    //
    //
    //       Icons.report,
    //       color: Colors.white,
    //     ),
    //   ),
    //   title: Text(
    //     "Emergency",
    //     style: TextStyle(fontSize: 20),
    //   ),
    // ),
    // ListTile(
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     child: Icon(
    //       Icons.work,
    //       color: Colors.white,
    //     ),
    //   ),
    //   title: Text(
    //     "Active Projects",
    //     style: TextStyle(fontSize: 20),
    //   ),
    // ),
    // Container(
    //   alignment: Alignment.bottomCenter,
    //   child: ListTile(
    //     leading: CircleAvatar(
    //       backgroundColor: Colors.transparent,
    //     ),
    //     title: Text("I have a B-Plan , for selling DTU"),
    //     subtitle: Text("-Every Entrepreneur at E-cell"),
    //   ),

  ];
  int _currentIndex =0;


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Color(0xff6F6E6E),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    RiveAnimationController _controller = OneShotAnimation('active', autoplay:true);
    RiveAnimationController _controller1 = OneShotAnimation('Idle', autoplay:true);


    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        child: Scaffold(

          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            fixedColor: Colors.white,
            backgroundColor: Color(0xff6F6E6E),
            type:BottomNavigationBarType.fixed,
            onTap: onTabTapped, // new
            currentIndex:_currentIndex,  // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                activeIcon:GestureDetector(
                  onTap:()=> _controller.isActive=true,
                  child: Container(

                    width: MediaQuery.of(context).size.width/8,
                    height: MediaQuery.of(context).size.height/20,
                    child:  RiveAnimation.asset('Assets/home_animation.riv',fit:BoxFit.contain,animations: ['active'],artboard: "HOME",controllers:[_controller],)    ),
                )
                ,
                backgroundColor: Color(0xff6F6E6E),
                icon: Container(
                    width: MediaQuery.of(context).size.width/8,
                    height: MediaQuery.of(context).size.height/20,child:RiveAnimation.asset('Assets/home_animation.riv',fit:BoxFit.contain,animations: ['reverse'],artboard: "HOME",),
                )
                ,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon:GestureDetector(
                  onTap:()=> _controller1.isActive=true,
                  child: Container(
                    alignment: Alignment.topCenter,

                      width: MediaQuery.of(context).size.width/4,
                      height: MediaQuery.of(context).size.height/10,
                      child:  RiveAnimation.asset('Assets/SIJF_ICON.riv',fit:BoxFit.contain,animations: ['still'],artboard: "Design_Animate",controllers:[_controller1],)    ),
                )
                ,
                backgroundColor: Color(0xff6F6E6E),
                icon: Container(
                  width: MediaQuery.of(context).size.width/4,
                  height: MediaQuery.of(context).size.height/10,child:RiveAnimation.asset('Assets/SIJF_ICON.riv',fit:BoxFit.contain,animations: ['still'],artboard: "Design_Animate",),
                )
                ,
                label: 'SIJF',
              ),

              BottomNavigationBarItem(
                  activeIcon:GestureDetector(
                    onTap:()=> _controller.isActive=true,
                    child: Container(
                        width: MediaQuery.of(context).size.width/8,
                        height: MediaQuery.of(context).size.height/20,child: RiveAnimation.asset('Assets/start_animation.riv',fit:BoxFit.contain,animations: ['idle'],artboard: "LIKE/STAR",controllers:[_controller])),
                  )
                  ,
                  backgroundColor: Color(0xff6F6E6E),
                  icon: Container(
                      width: MediaQuery.of(context).size.width/8,
                      height: MediaQuery.of(context).size.height/20,child: RiveAnimation.asset('Assets/start_animation.riv',fit:BoxFit.contain,animations: ['idle'],artboard: "LIKE/STAR",))
                  ,
                  label:'Events'
              ),

            ],
          ),
          drawer: Drawer(
            child: Container(
              color:Color(0xff6F6E6E) ,

              child: Center(
                child: ListView(
                  children: ScatteredListtiles,
                ),
              ),
            ), // Populate the Drawer in the next step.
          ),
           body: Container(color:Color(0xff6F6E6E),child: _children[_currentIndex]),
        ),
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
  List<Project> evesForSchedule = [];
  List<Project> sheduled = [];
  double width = 500;
  int weekDayIndex = 1;
  bool loading = true;

  double height = 200;
  List<Project> sheduledToday = [];
  List<Project> eventsedRegester = [];
  List<Project> eventfiltered = [];
  List<NetworkImage> CachedImages = [];

  @override




  var scf;
  void initState() {
    if (!Provider.of<ProjectData>(context, listen: false)
        .getOnceDownloaded()) {
      scf = Provider.of<SCF>(context, listen: false).get();
      scf.fetchListOfProjects(context);
      Provider.of<ProjectData>(context, listen: false).setOnceDownloaded(true);

      // Provider.of<EventsImages>(context, listen: false).fetchList(
      //     Provider.of<EventsData>(context, listen: false).getEvents(),
      //     Provider.of<AccessTokenData>(context, listen: false)
      //         .getAccessToken());
    }


    eventsedRegester =
        Provider.of<ProjectData>(context, listen: false).getProjects();

    eventsedRegester.forEach((element) {
      eventfiltered.add(element);
    });
    // TODO: implement initState
    super.initState();
  }
  @override


  void didChangeDependencies() async{



    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEventDetails = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  bool eventsInitialized = false;



  @override
  Widget build(BuildContext context) {
    List<Widget> ScatteredListtiles = [

      Card(
        elevation: 0,
        child: Center(
            child: Container(
              child: Text("DAY 1 CONTENT CREATORS!!!"),
                )),
      ),
      Card(
        elevation: 0,
        child: Center(
            child: Container(
              child: Text("DAY 2 COMEDY NIGHT!!!!!"),
            )),
      ),
      Card(
        elevation: 0,
        child: Center(
            child: Container(
              child: Text("DAY 3 BAND NIGHT!!!!!!"),
            )),
      ),
      Card(
        elevation: 0,
        child: Center(
            child: Container(
              child: Text("DAY 1 CONTENT CREATORS!!!"),
            )),
      ),






      // Column(
      //   children: [
      //     SingleChildScrollView(
      //       child: !eventsInitialized
      //           ? Rive(
      //               artboard: _riveArtboard,
      //               alignment: Alignment.bottomCenter,
      //               useArtboardSize: true,
      //             )
      //           : ListTile(
      //               trailing: Text("Projects"),
      //             ),
      //     ),
      //   ],
      // ),
      // DateTime.now().hour <= 17 && DateTime.now().hour >= 8
      //     ? TimeTableHomeScreenListTile()
      //     : ListTile(),
      // loading == false
      //     ? Center(
      //         child: CarouselSlider.builder(
      //             itemCount: eventfiltered.length,
      //             itemBuilder: (context, itemIndex, pageViewIndex) {
      //               return GestureDetector(
      //                 onTap: () {
      //                   Navigator.of(context).pushNamed('/eventdetailsdesign',
      //                       arguments: ScreenArguments(
      //                           id: eventfiltered[itemIndex].id,
      //                           scf: scf,
      //                           context: context));
      //                 },
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                       image: DecorationImage(
      //                           fit: BoxFit.fitHeight,
      //                           image: eventfiltered.length != 0
      //                               ? CachedNetworkImageProvider(
      //                                   eventfiltered[itemIndex]
      //                                       .event_image
      //                                       .toString())
      //                               : AssetImage("Assets/newframe.png"))),
      //                   child: eventfiltered.length == 0
      //                       ? Container(child: Text("No Upcoming events"))
      //                       : Container(),
      //                 ),
      //               );
      //             },
      //             options: CarouselOptions(
      //                 autoPlay: eventfiltered.length != 0 ? true : false,
      //                 enlargeCenterPage: false,
      //                 autoPlayInterval: Duration(seconds: 5),
      //                 height: 500,
      //                 viewportFraction: 1)),
      //       )
      //     : Rive(
      //         artboard: _riveArtboard,
      //         alignment: Alignment.bottomCenter,
      //         useArtboardSize: true,
      //       ),
      // ListTile(
      //   title: Text("Internship/Job Opportunities"),
      //   trailing: Icon(Icons.work_outline),
      // ),
    ];
    int columnCount = 1;

    return SingleChildScrollView(

      child: Container(

        child:ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,

          itemCount: 3,
          itemBuilder: (context,index){
           return
                AnimationConfiguration.staggeredGrid(

                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                        child:
                        SingleChildScrollView(
                          child: Container(




                            child: Column(

                              children: [
                                DotIndicator(size: 40,
                                    color: Colors.greenAccent),
                                SizedBox(height:20, child: SolidLineConnector(
                                    color: Colors.grey)),
                                DotIndicator(size: 40,
                                    color: Colors.black),
                                SizedBox(height:20, width: 10,child: SolidLineConnector(
                                    color: Colors.white)),
                                DotIndicator(size: 40,
                                    color: Colors.grey),
                                SizedBox(height:60, width: 10,child: SolidLineConnector(
                                    color: Colors.grey)),

                              ],
                            ),
                            // child: Padding(
                            //   padding: const EdgeInsets.all(0.0),
                            //   child: SlideAnimation(
                            //     child:
                            //
                            //         Timeline.tileBuilder(
                            //
                            //           controller: ScrollController(),
                            //           theme: TimelineThemeData(
                            //             indicatorTheme: IndicatorThemeData(
                            //               color: index%2 ==0?Colors.white:Colors.red
                            //             ),
                            //             color: index%2!=0?Colors.white:Colors.red
                            //           ),
                            // builder: TimelineTileBuilder.fromStyle(
                            //
                            //
                            //         indicatorStyle: index%2!=0?IndicatorStyle.outlined:IndicatorStyle.dot,
                            //           contentsAlign: ContentsAlign.alternating,
                            //           contentsBuilder: (context, index) => Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Text('Timeline Event $index'),
                            //           ),
                            //           itemCount: 5),
                            //
                            //     ),
                            //   )
                            // ),
                          ),
                        )

                    ),

                ),

           );
          },
        ),
      ),
    );

    // return Flexible(
    //   child: StaggeredGridView.countBuilder(
    //     physics: NeverScrollableScrollPhysics(),
    //     padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
    //     crossAxisCount: 4,
    //     itemCount: 4,
    //     itemBuilder: (BuildContext context, int index) =>
    //         AnimationConfiguration.staggeredGrid(
    //       position: index,
    //       columnCount: 0,
    //       duration: const Duration(milliseconds: 500),
    //       child: SlideAnimation(
    //         horizontalOffset: 100.0,
    //         child: FlipAnimation(
    //           flipAxis: FlipAxis.y,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: Color(0xff6F6E6E),
    //               borderRadius: BorderRadius.circular(5.0),
    //             ),
    //             child: Center(child: ScatteredListtiles[index]),
    //           ),
    //         ),
    //       ),
    //     ),
    //     staggeredTileBuilder: (int index) =>
    //         StaggeredTile.count(2, index.isEven ? 4 : 1),
    //     mainAxisSpacing: 4.0,
    //     crossAxisSpacing: 4.0,
    //   ),
    // );
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
      lectureStart = _lecture.time.hour > 12
          ? _lecture.time.hour - 12
          : _lecture.time.hour;
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

//////////////////////////ADDTOSCHEDULEPAGE


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ADDPROJECTPAGE


/////////////////////////////////////////PROJECTPAGE
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key key}) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Event> eventsedRegester;
  PlusAnimation _plusAnimation;
  int rollNum;
  int year;
  String _myBranch;
  String _myBatch;
  String username = 'dtuotg';
  bool initialized = false;
  @override
  void initState() {
    super.initState();
  }
  Map<String, dynamic> data;

  final picker = ImagePicker();
  Artboard _riveArtboard;
  List<String> imagesstring = [];
  List<Event> eventfiltered = [];

  final formGlobalKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();
  final instagram = TextEditingController();
  final linkedIn = TextEditingController();
  List<Project> personalprojects;
  bool waiting = false;

  ScreenArguments args;
  bool host_pressed = false;
  @override


  @override

  void didChangeDependencies() async {
    if (!initialized) {
      BuildContext ctx =
          Provider.of<MaterialNavigatorKey>(context, listen: false)
              .materialNavigatorKey
              .currentContext;
      data = host_pressed == true
          ? await Server_Connection_Functions()
              .getHostData(context, args.username)
          : await Server_Connection_Functions().getProfileData(ctx);
      print(data['image']);
      setState(() {
        initialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  void _launchURL() async {
    if (!await launch(data['description']
        .toString()
        .substring(
        data['description']
            .toString()
            .indexOf('~\$') ==
            -1
            ? 0
            : data['description']
            .toString()
            .indexOf('~\$') +
            2,
        data['description']
            .toString()
            .indexOf('\$~') ==
            -1
            ? 0
            : data['description']
            .toString()
            .indexOf('\$~')),
    )) throw 'Could not launch ${data['description']
        .toString()
        .substring(
        data['description']
            .toString()
            .indexOf('~\$') ==
            -1
            ? 0
            : data['description']
            .toString()
            .indexOf('~\$') +
            2,
        data['description']
            .toString()
            .indexOf('\$~') ==
            -1
            ? 0
            : data['description']
            .toString()
            .indexOf('\$~'))
    }';
  }
  void _launchURL1() async {
    if (!await launch(data['description']
        .toString()
        .substring(
      data['description']
          .toString()
          .indexOf('\$~') ==
          -1
          ? 0
          : data['description']
          .toString()
          .indexOf('\$~') +
          2,
    )
    )) throw 'Could not launch ${data['description']
        .toString()
        .substring(
      data['description']
          .toString()
          .indexOf('\$~') ==
          -1
          ? 0
          : data['description']
          .toString()
          .indexOf('\$~') +
          2,
    )
    }';
  }
  /*void _showSecondPage(BuildContext context,Project projects) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar:AppBar(
            iconTheme:IconThemeData(color:Colors.white),
            elevation:0,
            backgroundColor: Color(0xff6F6E6E),


          ),

          body: Container(
            color:Color(0xff6F6E6E),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(

                    tag: 'my-hero-animation-tag${projects.id}',
                    child: SingleChildScrollView
                      (
                      child: Container(

                        child: Image(fit:BoxFit.fitHeight,image: CachedNetworkImageProvider(
                          '${projects.image.toString()}',
                        ),),


                      ),
                    ),
                  ),


                  Container(
                    decoration: BoxDecoration(

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

                            child: Column(
                              children: [

                                Text(
                                  "Description",
                                  style: TextStyle(


                                  ),
                                ),
                                Text(projects.description
                                    .toString()
                                    .substring(
                                    0,
                                    projects.description
                                        .toString()
                                        .indexOf('~\$') ==
                                        -1
                                        ? projects.description
                                        .toString()
                                        .length
                                        : projects.description
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

                            child: Column(
                              children: [
                                Text(
                                  "Incentives",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,


                                  ),
                                ),
                                Text(
                                  projects.description
                                      .toString()
                                      .substring(
                                      projects.description
                                          .toString()
                                          .indexOf('~\$') ==
                                          -1
                                          ? 0
                                          : projects.description
                                          .toString()
                                          .indexOf('~\$') +
                                          2,
                                      projects.description
                                          .toString()
                                          .indexOf('\$~') ==
                                          -1
                                          ? 0
                                          : projects.description
                                          .toString()
                                          .indexOf('\$~')),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,


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

                            child: Link(
                              uri: Uri.parse(projects.description
                                  .toString()
                                  .substring(
                                projects.description
                                    .toString()
                                    .indexOf('\$~') ==
                                    -1
                                    ? 0
                                    : projects.description
                                    .toString()
                                    .indexOf('\$~') +
                                    2,
                              )),
                              target: LinkTarget.blank,
                              builder: (ctx, openLink) {
                                return TextButton.icon(
                                  onPressed: openLink,
                                  label: Text('Link to Community'),
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

                            child: Text(
                              "Other links",
                              style: TextStyle(


                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {



    /*String projectstring=data['projects'].toString();

    
    final resp=json.decode(projectstring);



    List<Project> personalprojects=json.decode(projectstring.replaceFirst('[', '').replaceFirst("]", ''));
    print(personalprojects);*/





/*
print(data);
    List<dynamic> resp = data['projects'][1];
    personalprojects = resp.map<Project>((e) {
      return Project(

          description: e['description'],



          name: e['name'],

          id: e['id'],



          image: e['image']);
    }).toList();
*/


    return Container(

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: !initialized
            ? Center(
                child: Container(
                    child: RiveAnimation.asset('Assets/ecell_logo.riv',fit:BoxFit.contain,animations: ['Animation 2'],)
                ),
              )
            : Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("Assets/ProfileBG.png"),
    fit: BoxFit.cover,
    ),),

                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.height / 6, 0, 0),
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height / 5,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff6F6E6E),
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(data['image'].toString(),),


                        ),
                      ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        foregroundColor: MaterialStateProperty.all(Colors.transparent),overlayColor:MaterialStateProperty.all(Colors.transparent) ,shadowColor: MaterialStateProperty.all(Colors.transparent)
                      ),
                      onPressed: () {
                        // Or: showModalBottomSheet(), with model bottom sheet, clicking
                        // anywhere will dismiss the bottom sheet.
                        showBottomSheet<String>(
                          context: context,
                          builder: (BuildContext context) => Container(

                            decoration: const BoxDecoration(color: Color(0xff6F6E6E),

                              border: Border(top: BorderSide(color: Colors.white12)),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: <Widget>[
                                const ListTile(
                                  dense: true,
                                  title: Text('This is a bottom sheet'),
                                ),
                                const ListTile(
                                  dense: true,
                                  title: Text('Click OK to dismiss'),
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {

                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        
                      },                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                        child: Text(data['name'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.white,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'DancingScript',
                                fontSize: 20)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(

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

                              child: Column(
                                children: [


                                  Text(data['description']
                                      .toString()
                                      .substring(
                                      0,
                                      data['description']
                                          .toString()
                                          .indexOf('~\$') ==
                                          -1
                                          ? data['description']
                                          .toString()
                                          .length
                                          : data['description']
                                          .toString()
                                          .indexOf('~\$')))
                                ],
                              ),
                            ),
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,

                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed:_launchURL1,
                                        child: TextButton.icon(
                                          onPressed: _launchURL1,
                                          label: Text('linkedIn'),
                                          icon: Icon(FontAwesomeIcons.linkedin),
                                        )
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,

                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed:_launchURL,
                                        child: TextButton.icon(
                                          style:TextButton.styleFrom(
                                            primary:Colors.purple,

                                          )
                                          ,
                                          onPressed: _launchURL,
                                          label: Text('instagram'),
                                          icon: Icon(FontAwesomeIcons.instagram,color: Colors.purple,),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),



                        ],
                      ),
                    ),


                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 44),
                      child: Row(
                        children: [
                          data['who_sent'].toString()!=" "?Text('invited by ',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'DancingScript',
                                  fontSize: 20)):SizedBox(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                hostorprofile = true;
                              });
                              Navigator.of(context).pushNamed(
                                  '/ProfileDetailsScreen',
                                  arguments: ScreenArguments(
                                      username:data['who_sent'].toString()
                                      ,
                                      hostpressed: hostorprofile));
                            },
                            child: Text(data['who_sent'].toString(),
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'DancingScript',
                                    fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
          /*Container(

            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 350),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: personalprojects.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:EdgeInsets.all(10),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5.0,
                                    sigmaY: 5.0,
                                  ),
                                  child: Container(


                                    width: MediaQuery.of(context).size.width*5/6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:Colors.transparent,
                                    ),



                                    child: Column(
                                      children: [
                                        ClipRect(
                                          child: GestureDetector(
                                            onTap: () => _showSecondPage(context,Project(id: personalprojects[index].id,
                                                image:personalprojects[index].image.toString(),
                                                name:personalprojects[index].name.toString(),description: personalprojects[index].description.toString()
                                            )),
                                            child: Container(

                                              child: Hero(
                                                tag: 'my-hero-animation-tag${personalprojects[index].id}',
                                                child: Container(
                                                  child: Image(image: CachedNetworkImageProvider(
                                                    '${personalprojects[index].image.toString()}',
                                                  ),),

                                                ),
                                              ),
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                );
              },
            ),
          ),*/

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
  List<Project> eventsedRegester;
  List<String> imagesstring = [];
  List<Project> eventfiltered = [];
  List<String> username = [];

  Response response;
  var dio = Dio();
  var fltrNotification = new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    if (!Provider.of<ProjectData>(context, listen: false)
        .getOnceDownloaded()) {
      scf = Provider.of<SCF>(context, listen: false).get();
      scf.fetchListOfProjects(context);
      Provider.of<ProjectData>(context, listen: false).setOnceDownloaded(true);

      // Provider.of<EventsImages>(context, listen: false).fetchList(
      //     Provider.of<EventsData>(context, listen: false).getEvents(),
      //     Provider.of<AccessTokenData>(context, listen: false)
      //         .getAccessToken());
    }


    eventsedRegester =
        Provider.of<ProjectData>(context, listen: false).getProjects();

    eventsedRegester.forEach((element) {
      eventfiltered.add(element);
    });
    // TODO: implement initState
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('ecelldtu_logo2');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);

    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }
  @override
  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }
  Future _showNotification() async {
    var scheduledTime= DateTime.now().add(Duration(seconds : 5));

    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await fltrNotification.show(
        0, "Task", "You created a Task",
        generalNotificationDetails, payload: "Task");

  }


  void didChangeDependencies() async{

    var usernameData = await DbHelper.getUsernameData();
    username = [(usernameData[0]['username'])];
    print(username[0]);

    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEventDetails = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  void _showSecondPage(BuildContext context,Project projects) {




    void _launchURL() async {
      String urllinkfinal=projects.description
          .toString()
          .substring(
        projects.description
            .toString()
            .indexOf('\$~') ==
            -1
            ? 0
            : projects.description
            .toString()
            .indexOf('\$~') +
            2,
      );

      urllinkfinal.contains(' ')?urllinkfinal='https://'+urllinkfinal.split( ' ')[urllinkfinal.split(' ').length-1].split('https://')[urllinkfinal.split( ' ')[urllinkfinal.split(' ').length-1].split('https://').length-1]:urllinkfinal=urllinkfinal;

      if (!await launch(urllinkfinal)) throw 'Could not launch ${urllinkfinal
      }';
    }
    _showNotification();
    Navigator.of(context).push(

      MaterialPageRoute(

        builder: (ctx) => Scaffold(
          backgroundColor: Color(0xff6F6E6E),
          appBar:AppBar(
            iconTheme:IconThemeData(color:Colors.white),
            elevation:0,
            backgroundColor: Color(0xff6F6E6E),


          ),

          body: Container(
            color:Color(0xff6F6E6E),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(

                    tag: 'my-hero-animation-tag${projects.id}',
                    child: SingleChildScrollView
                      (
                      child: Container(

                        child: Image(fit:BoxFit.fitHeight,image: CachedNetworkImageProvider(
                          '${projects.image.toString()}',
                        ),),


                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Hero(
                        tag:"lol${projects.id}",
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            alignment:Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,

                              radius: 30,
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 28,
                                  child: Container(

                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                '${projects.owner_pic.toString()}'),
                                            fit: BoxFit.fill),
                                        shape: BoxShape.circle),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          projects.name,
                          style: TextStyle(
                              color:Colors.white,
                              fontSize: 19,
                              fontFamily: 'DancingScript'),
                        ),
                      ),
                username[0]==projects.owner?Row(
                  children: [
                    IconButton(
                      onPressed: () async {



                      /*  var scf = Provider.of<SCF>(context, listen: false).get();
                        await scf.deleteproject(projects.id, context);

                        Navigator.of(context).pushReplacementNamed('/loading',arguments: ScreenArguments(id: 1));*/



                      },
                      color: Colors.white,
                      icon:Icon(Icons.auto_fix_normal),

                    ),

                    IconButton(
                            onPressed: () async {



                              var scf = Provider.of<SCF>(context, listen: false).get();
                              await scf.deleteproject(projects.id, context);
                              scf.fetchListOfProjects(context);


                              Navigator.of(context).pushReplacementNamed('/homeScreen',arguments: ScreenArguments(id: 1));




                            },
                            color: Colors.white,
                            icon:Icon(Icons.delete),

                          ),
                  ],
                ):Container()


                    ],
                  ),

                  Container(
                    decoration: BoxDecoration(

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

                            child: Column(
                              children: [

                                Text(
                                  "Description",
                                  style: TextStyle(


                                  ),
                                ),
                                SelectableText(projects.description
                                    .toString()
                                    .substring(
                                    0,
                                    projects.description
                                        .toString()
                                        .indexOf('~\$') ==
                                        -1
                                        ? projects.description
                                        .toString()
                                        .length
                                        : projects.description
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

                            child: Column(
                              children: [
                                Text(
                                  "Benefits",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,


                                  ),
                                ),
                                Text(
                                  projects.description
                                      .toString()
                                      .substring(
                                      projects.description
                                          .toString()
                                          .indexOf('~\$') ==
                                          -1
                                          ? 0
                                          : projects.description
                                          .toString()
                                          .indexOf('~\$') +
                                          2,
                                      projects.description
                                          .toString()
                                          .indexOf('\$~') ==
                                          -1
                                          ? 0
                                          : projects.description
                                          .toString()
                                          .indexOf('\$~')),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,


                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed:_launchURL,
                          child: projects.description
                              .toString()
                              .substring(
                            projects.description
                                .toString()
                                .indexOf('\$~') ==
                                -1
                                ? 0
                                : projects.description
                                .toString()
                                .indexOf('\$~') +
                                2,
                          ).contains('maps.app.goo')?TextButton.icon(
                            style:TextButton.styleFrom(
                              primary:Colors.blue,

                            )
                            ,
                            onPressed: _launchURL,
                            label: Text('Location'),
                            icon: Icon(FontAwesomeIcons.mapMarked,color: Colors.blue,),
                          ):projects.description
                              .toString()
                              .substring(
                            projects.description
                                .toString()
                                .indexOf('\$~') ==
                                -1
                                ? 0
                                : projects.description
                                .toString()
                                .indexOf('\$~') +
                                2,
                          ).contains('chat.whatsapp.com')?TextButton.icon(
                            style:TextButton.styleFrom(
                              primary:Colors.green,

                            )
                            ,
                            onPressed: _launchURL,
                            label: Text('Whatsapp Group Link'),
                            icon: Icon(FontAwesomeIcons.whatsapp,color: Colors.green,),
                          ):TextButton.icon(
                            style:TextButton.styleFrom(
                              primary:Colors.purple,

                            )
                            ,
                            onPressed: _launchURL,
                            label: Text('Important link'),
                            icon: Icon(FontAwesomeIcons.link,color: Colors.purple,),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,

                            child: Text(
                              "Other links",
                              style: TextStyle(


                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {


    return Container(

      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: eventfiltered.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:EdgeInsets.all(10),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(


                                width: MediaQuery.of(context).size.width*5/6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:Colors.transparent,
                              ),



                              child: Column(
                                children: [
                                  ClipRect(
                                    child: GestureDetector(
                                      onTap: () => _showSecondPage(context,Project(id: eventfiltered[index].id,
                                    image:eventfiltered[index].image.toString(),owner_pic:eventfiltered[index].owner_pic.toString(),
owner:eventfiltered[index].owner.toString(),name:eventfiltered[index].name.toString(),description: eventfiltered[index].description.toString()
                                      )),
                                      child: Container(

                                        child: Hero(
                                          tag: 'my-hero-animation-tag${eventfiltered[index].id}',
                                          child: Container(
                                            child: Image(image: CachedNetworkImageProvider(
                                              '${eventfiltered[index].image.toString()}',
                                            ),),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(


                                    child: ListTile(

                                        onTap: () {



                                        },
                                        subtitle: Text(
                                            eventfiltered[index].owner.toString(),
                                            style: TextStyle(
                                                fontFamily: 'DancingScript')),


                                        leading: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              hostorprofile = true;
                                            });
                                            Navigator.of(context).pushNamed(
                                                '/ProfileDetailsScreen',
                                                arguments: ScreenArguments(
                                                    username:
                                                        eventfiltered[index].owner,
                                                    hostpressed: hostorprofile));
                                          },
                                          child: Hero(
                                            tag:"lol${eventfiltered[index].id}",
                                            child: CircleAvatar(
                                              radius: 22,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                '${eventfiltered[index].owner_pic.toString()}'),
                                                            fit: BoxFit.fill),
                                                        shape: BoxShape.circle),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          eventfiltered[index].name,
                                          style: TextStyle(
                                            color:Colors.white,
                                              fontSize: 19,
                                              fontFamily: 'DancingScript'),
                                        )),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        },
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
  bool loading = true;
  List<Event> eventsedRegester;
  List<String> imagesstring = [];
  List<Event> eventfiltered = [];

  @override
  void initState() {
    scf = Provider.of<SCF>(context, listen: false).get();
    eventsedRegester =
        Provider.of<EventsData>(context, listen: false).getEvents();
    eventsedRegester.forEach((element) {
      if (element.eventType == "University") {
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
      loading = false;
    });

    print("//////////////////////////////LOADED");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void _showSecondPage(BuildContext context,Event projects) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar:AppBar(
            iconTheme:IconThemeData(color:Colors.white),
            elevation:0,
            backgroundColor: Color(0xff6F6E6E),


          ),

          body: Container(
            color:Color(0xff6F6E6E),
            child: Column(
              children: [
                Hero(

                  tag: 'my-hero-animation-tag${projects.id}',
                  child: Container(

                    width: MediaQuery.of(context).size.height*4/6,
                    height: MediaQuery.of(context).size.height/2,

                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              '${projects.event_image}',
                            ),
                            fit: BoxFit.fitWidth),
                        shape: BoxShape.rectangle),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag:"lol${projects.id}",
                      child: Container(
                        alignment:Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,

                          radius: 30,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 28,
                              child: Container(

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            '${projects.owner_image.toString()}'),
                                        fit: BoxFit.fill),
                                    shape: BoxShape.circle),
                              )),
                        ),
                      ),
                    ),
                    Text(
                      projects.name,
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: 19,
                          fontFamily: 'DancingScript'),
                    ),
                    IconButton(
                      onPressed: () async {


                        /*  var scf = Provider.of<SCF>(context, listen: false).get();
                        await scf.deleteproject(projects.id, context);

                        Navigator.of(context).pushReplacementNamed('/loading',arguments: ScreenArguments(id: 1));*/



                      },
                      color: Colors.white,
                      icon:Icon(Icons.auto_fix_normal),

                    ),

                    IconButton(
                      onPressed: () async {



                        var scf = Provider.of<SCF>(context, listen: false).get();
                        await scf.deleteevent(projects.id, context);
                        scf.fetchListOfEvents(context);



                        Navigator.of(context).pushReplacementNamed('/homeScreen',arguments: ScreenArguments(id: 1,));




                      },
                      color: Colors.white,
                      icon:Icon(Icons.delete),

                    ),
                  ],
                ),

                Container(
                  decoration: BoxDecoration(

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

                          child: Column(
                            children: [

                              Text(
                                "Description",
                                style: TextStyle(


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

                          child: Column(
                            children: [
                              Text(
                                "Incentives",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,


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


                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,

                          child: Text(
                            "Other links",
                            style: TextStyle(


                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("//////////////////////////////BUILDING");

    return Container(

      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: eventfiltered.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:EdgeInsets.all(0),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(


                              width: MediaQuery.of(context).size.width*6/6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:Colors.transparent,
                              ),



                              child: Column(
                                children: [
                                  ClipRect(
                                    child: GestureDetector(
                                      onTap: () => _showSecondPage(context,Event(id: eventfiltered[index].id,
                                          event_image:eventfiltered[index].event_image.toString(),owner_image:eventfiltered[index].owner_image.toString(),
                                          owner:eventfiltered[index].owner.toString(),name:eventfiltered[index].name.toString()
                                      )),
                                      child: Container(


                                        child: Hero(
                                          tag: 'my-hero-animation-tag${eventfiltered[index].id}',
                                          child: Image(image: CachedNetworkImageProvider(
                                            '${eventfiltered[index].event_image.toString()}',
                                          ),)
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(

                                    width: MediaQuery.of(context).size.width*5/6,
                                    child: ListTile(
                                        onTap: () {



                                        },
                                        subtitle: Text(
                                            eventfiltered[index].owner.toString(),
                                            style: TextStyle(
                                                fontFamily: 'DancingScript')),

                                        leading: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              hostorprofile = true;
                                            });
                                            Navigator.of(context).pushNamed(
                                                '/ProfileDetailsScreen',
                                                arguments: ScreenArguments(
                                                    username:
                                                    eventfiltered[index].owner,
                                                    hostpressed: hostorprofile));
                                          },
                                          child: Hero(
                                            tag:"lol${eventfiltered[index].id}",
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
                                        ),
                                        title: Text(
                                          eventfiltered[index].name,
                                          style: TextStyle(
                                              color:Colors.white,
                                              fontSize: 19,
                                              fontFamily: 'DancingScript'),
                                        )),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        },
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
                    style: TextStyle(fontSize: 30),
                    cursorHeight: 35,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "Name of the event",
                      helperText: 'Keep it short, this is just a beta.',
                      labelStyle: TextStyle(fontSize: 30),
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
                    style: TextStyle(fontSize: 30),
                    cursorHeight: 35,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "Description",
                      helperText: 'Keep it short, this is just a beta.',
                      labelStyle: TextStyle(fontSize: 30),
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
                    style: TextStyle(fontSize: 20),
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
      Card(color: Color(0xff6F6E6E),elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {

            },
            leading: Icon(
              FontAwesomeIcons.star,
            ),
            title: Text("Add to Events",style: TextStyle(color: Colors.white),),
            subtitle: Text(
                "Update via this feature to let people know the details of any event",style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
      Card(
        color: Color(0xff6F6E6E),


        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
                 },
            leading: Icon(
              Icons.update,
            ),
            title: Text("Add to Story",style: TextStyle(color: Colors.white),),
            subtitle: Text(
                "Update about various public events and achievements your society ",style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
      Card(
        color: Color(0xff6F6E6E),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Creating"),duration: Duration(milliseconds: 1000),));
              //  Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CustomPage()));
              Navigator.of(context).pushNamed('AddEventScreen', arguments: ScreenArguments(id: 3));
            },
            leading: Icon(
              Icons.work_outline,
            ),
            title: Text("Add to internships/jobs",style: TextStyle(color: Colors.white),),
            subtitle: Text(
                "Update via this feature to let people know the details about various internships/Jobs/Projects related opportunities for students",style: TextStyle(color: Colors.white),),
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

    return Container(
      margin:EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/4, 0, 0),
        width :MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height ,
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
              child: SlideAnimation(child: FlipAnimation(child: AddingButtons[index])),
            ),
          );
        },
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
  double width;
  double height;

  bool initialized = false;
  Artboard _riveArtboard;
  var scf;
  List<Event> sheduledToday = [];

  bool eventsInitialized = false;
  bool storycontinues = false;
  int j = 1;
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

  @override
  void didChangeDependencies() async {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height / 5;

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
      if (!Provider.of<ProjectData>(context, listen: false)
          .getOnceDownloaded()) {
        scf = Provider.of<SCF>(context, listen: false).get();
        scf.fetchListOfProjects(context);
        Provider.of<ProjectData>(context, listen: false).setOnceDownloaded(true);

        // Provider.of<EventsImages>(context, listen: false).fetchList(
        //     Provider.of<EventsData>(context, listen: false).getEvents(),
        //     Provider.of<AccessTokenData>(context, listen: false)
        //         .getAccessToken());
      }
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
          _internship_pressed = _internshippressed;
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

   setState(() {
      if (_adding_page_active == true) {
_plusAnimation.start();


        print("_adding_page_active1");
      }
      if (_adding_page_active == false) {
        _plusAnimation.reverse();









        print("_adding_page_inactive1");
      }

      _adding_to_app_pressed = _adding_page_active;
    });
  }


  String owner = '';

  @override
  Widget build(BuildContext context) {
    List<List<Event>> ownersEvents = [];

    List<Event> storiesFiltered = [];
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (j != 1) {
      storycontinues = true;
    }
    sheduledToday.forEach((element) {
      if (element.eventType == "Society") storiesFiltered.add(element);
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

      alignment: Alignment.center,
      child: !initialized
          ? Center(
              child: Container(
                  decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/LogoOTG.png"),
                fit: BoxFit.cover,
              ),
            )))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_adding_to_app_pressed == true)
                  Container(
                    height: 200,
                  ),

                //NAVIGATION OF PAGES
                if (_adding_to_app_pressed == true)
                  AddingPage()
                else if (_events_pressed == true)
                  EventsPage()
                else if (_internship_pressed == true)
                  InternshipsPage()
                else if (_project_pressed == true)
                  ProjectsPage()
                else
                  HomePage(),


              ],
            ),
    );
  }
}
