import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';

import '../models/events.dart';
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
//import '../utils.dart' as utl;
import '../models/lecture.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../models/screenArguments.dart';
import '../providers/server_connection_functions.dart';
import 'package:nilay_dtuotg_2/Screens/eventsdetailsDESIGN.dart';

class ScheduleTab extends StatefulWidget {
  ScheduleTab({Key key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  Color newcolor = Colors.transparent;
  Color GoingOnColor = Color(0xffbd9b6a);
  Color FreePeriodColor = Color(0xff9c8f7c);
  Color EventColor;
  Color EventAndClassColor;

  DateTime _focusedDay = DateTime.now();
  //ValueNotifier<List<utl.Event>> _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  // List<utl.Event> _getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return utl.kEvents[day] ?? [];
  // }

  List<Event> sheduled = []; ////not implemented globally...only on home tab
  List<Event> sheduledToday = [];
  bool initialized = false;

  List<Lecture> lectures = [];
  int weekDayIndex = 1;
  List<Event> evesForSchedule = [];
  @override
  void didChangeDependencies() async {
    if (!initialized) {
      evesForSchedule = Provider.of<EventsData>(context, listen: false).events;
      weekDayIndex = DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday;
      await Provider.of<TimeTableData>(context, listen: false)
          .fetchAndSetData(context);
      lectures =
          Provider.of<TimeTableData>(context, listen: false).get(weekDayIndex);

      setState(() {
        initialized = true;
      });
      evesForSchedule.forEach((element) {
        if (element.favorite) {
          sheduled.add(element);
        }
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int events0Schedule1 = 1;
  List<DateTime> getEves(DateTime day) {
    List<DateTime> x = [];
    evesForSchedule.forEach((element) {
      if (element.dateime == day) x.add(element.dateime);
    });
    return x;
  }

  @override
  Widget build(BuildContext context) {
    sheduledToday = [];
    sheduled.forEach((element) {
      if ((element.dateime.day == _selectedDay.day) &&
          (element.dateime.month == _selectedDay.month) &&
          (element.dateime.year == _selectedDay.year)) {
        sheduledToday.add(element);
      }
    });
    var events = Provider.of<EventsData>(context).events;

    var eventsedRegester = [];

    events.forEach((element) {
      if (element.favorite) {
        if (element.dateime.day == _selectedDay.day &&
            element.dateime.month == _selectedDay.month &&
            element.dateime.year == _selectedDay.year) {
          eventsedRegester.add(element);
        }
        if (element.dateime == _selectedDay) {}
      }
    });
    return Scaffold(
      backgroundColor: Color(0xffF2EFE4),
      appBar: AppBar(
        title: Text(
          "Your Schedule",
          style: TextStyle(
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Container(
                    color: newcolor,
                    child: TableCalendar(
                      calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                              color: Colors.brown[200], shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: Colors.brown, shape: BoxShape.circle)),
                      daysOfWeekStyle:
                          DaysOfWeekStyle(decoration: BoxDecoration()),
                      eventLoader: (day) {},
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          print(selectedDay.toString());
                          print(focusedDay.toString());
                          _selectedDay = selectedDay;
                          lectures =
                              Provider.of<TimeTableData>(context, listen: false)
                                  .get(selectedDay.weekday);
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                      firstDay: DateTime.now().subtract(Duration(days: 100)),
                      lastDay: DateTime.now().add(Duration(days: 100)),
                      focusedDay: _focusedDay,
                    ),
                  ),

                  ToggleSwitch(
                    cornerRadius: 22,
                    minWidth: 150,
                    initialLabelIndex: events0Schedule1,
                    onToggle: (index) {
                      setState(() {
                        events0Schedule1 = index;
                      });
                    },
                    labels: ['events', 'schedule'],
                    activeBgColor: Colors.brown,
                    activeFgColor: Colors.white,
                    inactiveFgColor: Colors.brown,
                    inactiveBgColor: Colors.white,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  if (events0Schedule1 == 0)
                    if (initialized)
                      if (sheduledToday.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  if (events0Schedule1 == 0)
                    if (true) //(sheduledToday.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: eventsedRegester.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: double.infinity,
                                      height: 300,
                                      child: Card(
                                          color: Colors.amber,
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5,
                                          margin: EdgeInsets.all(5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      '${eventsedRegester[index].event_image.toString()}',
                                                    ),
                                                    fit: BoxFit.fill),
                                                shape: BoxShape.rectangle),
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/eventsdetailsdesign',
                                              arguments: ScreenArguments(
                                                  id: eventsedRegester[index]
                                                      .id,
                                                  scf:
                                                      Server_Connection_Functions(),
                                                  context: context));
                                        },
                                        tileColor:
                                            eventsedRegester[index].favorite
                                                ? Colors.white
                                                : Colors.blue,
                                        subtitle: Text(
                                          eventsedRegester[index]
                                              .owner
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.brown,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 20,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${eventsedRegester[index].owner_image.toString()}'),
                                                        fit: BoxFit.fill),
                                                    shape: BoxShape.circle),
                                              )),
                                        ),
                                        title: Text(
                                          eventsedRegester[index].name,
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontSize: 19),
                                        )),
                                  )
                                ],
                              );
                            }),
                      ),
                  if (!initialized) CircularProgressIndicator(),
                  if (initialized)
                    if (events0Schedule1 == 1)
                      if (lectures.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            'empty lectures',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                  if (events0Schedule1 == 1)
                    if (lectures.isNotEmpty)
                      Expanded(
                        child: new ListView.builder(
                          itemBuilder: (context, index) {
                            int hour = lectures[index].time.hour;
                            int length = lectures[index].length;
                            bool happeningNow = false;

                            if (lectures[index].time.hour ==
                                TimeOfDay.now().hour) {
                              happeningNow = true;
                            } else {
                              if ((lectures[index].time.hour <
                                      TimeOfDay.now().hour) &&
                                  ((lectures[index].time.hour +
                                          lectures[index].length) >
                                      TimeOfDay.now().hour)) {
                                happeningNow = true;
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                      child: FlipAnimation(
                                          flipAxis: FlipAxis.y,
                                          child: Container(
                                            decoration: lectures[index].free
                                                ? BoxDecoration(
                                                    border: Border(
                                                    left: BorderSide(
                                                        width: 8,
                                                        color:
                                                            Colors.lightGreen),
                                                  ))
                                                : BoxDecoration(
                                                    border: Border(
                                                    left: BorderSide(
                                                        width: 8,
                                                        color: Colors.brown),
                                                    right: happeningNow
                                                        ? BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.purple)
                                                        : BorderSide(width: 0),
                                                    top: happeningNow
                                                        ? BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.purple)
                                                        : BorderSide(width: 0),
                                                    bottom: happeningNow
                                                        ? BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.purple)
                                                        : BorderSide(width: 0),
                                                  )),
                                            child: ListTile(
                                                leading: _focusedDay ==
                                                            DateTime.now() &&
                                                        happeningNow
                                                    ? Text(
                                                        'NOW',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .access_time_outlined,
                                                          ),
                                                          Text(
                                                              '$hour-${hour + length}')
                                                        ],
                                                      ),
                                                subtitle: Text('AP102'),
                                                tileColor: lectures[index].free
                                                    ? Colors.white
                                                    : happeningNow
                                                        ? Colors.white
                                                        : Colors.white,
                                                title: lectures[index].free
                                                    ? Text(
                                                        'FREE',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightGreen),
                                                      )
                                                    : Text(
                                                        lectures[index].name,
                                                        style: TextStyle(
                                                            color:
                                                                FreePeriodColor),
                                                      ),
                                                trailing: Text(
                                                  '$length hour',
                                                  style: TextStyle(
                                                      color: Colors.brown,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )),
                                          )))),
                            );
                          },
                          itemCount: lectures.length,
                        ),
                      ),
                  // Container(
                  //     height: 300,
                  //     padding: EdgeInsets.only(top: 70),
                  //     child: SfCalendar(
                  //       appointmentBuilder: (BuildContext context,
                  //           CalendarAppointmentDetails calendarAppointmentDetails) {},
                  //       firstDayOfWeek: 1,
                  //       showCurrentTimeIndicator: true,
                  //       maxDate: DateTime.now().add(Duration(days: 10)),
                  //       minDate: DateTime.now().subtract(Duration(days: 10)),
                  //       todayHighlightColor: Colors.amber[800],
                  //       showNavigationArrow: true,
                  //       initialDisplayDate: DateTime.now(),
                  //       view: CalendarView.month,
                  //       monthViewSettings: MonthViewSettings(numberOfWeeksInView: 1),
                  //     )),
                ],
              ),
            ),
    );
  }
}
/*TableCalendar(eventLoader: ,
            onFormatChanged: (c) {},
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, daet, ev) {},
            ),
            onDaySelected: (newDay, x) {
              print('day');
              focusedDay = newDay;
            },
            calendarFormat: CalendarFormat.week,
            firstDay: DateTime.now().subtract(Duration(days: 10)),
            lastDay: DateTime.now().add(Duration(days: 10)),
            focusedDay: focusedDay,
//           ) */
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';

// class DynamicEvent extends StatefulWidget {
//   @override
//   _DynamicEventState createState() => _DynamicEventState();
// }

// class _DynamicEventState extends State<DynamicEvent> {
//   CalendarController _controller;
//   Map<DateTime, List<dynamic>> _events;
//   List<dynamic> _selectedEvents;
//   TextEditingController _eventController;
//   SharedPreferences prefs;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CalendarController();
//     _eventController = TextEditingController();
//     _events = {};
//     _selectedEvents = [];
//     prefsData();
//   }

//   prefsData() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _events = Map<DateTime, List<dynamic>>.from(
//           decodeMap(json.decode(prefs.getString("events") ?? "{}")));
//     });
//   }

//   Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
//     Map<String, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[key.toString()] = map[key];
//     });
//     return newMap;
//   }
//   Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
//     Map<DateTime, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[DateTime.parse(key)] = map[key];
//     });
//     return newMap;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.black,
//         title: Text('Flutter Dynamic Event Calendar'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TableCalendar(
//               events: _events,
//               initialCalendarFormat: CalendarFormat.week,
//               calendarStyle: CalendarStyle(
//                   canEventMarkersOverflow: true,
//                   todayColor: Colors.orange,
//                   selectedColor: Theme.of(context).primaryColor,
//                   todayStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white)),
//               headerStyle: HeaderStyle(
//                 centerHeaderTitle: true,
//                 formatButtonDecoration: BoxDecoration(
//                   color: Colors.orange,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 formatButtonTextStyle: TextStyle(color: Colors.white),
//                 formatButtonShowsNext: false,
//               ),
//               startingDayOfWeek: StartingDayOfWeek.monday,
//               onDaySelected: (date, events,holidays) {
//                 setState(() {
//                   _selectedEvents = events;
//                 });
//               },
//               builders: CalendarBuilders(
//                 selectedDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 todayDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ),
//               calendarController: _controller,
//             ),
//             ..._selectedEvents.map((event) => Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: MediaQuery.of(context).size.height/20,
//                 width: MediaQuery.of(context).size.width/2,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey)
//                 ),
//                 child: Center(
//                     child: Text(event,
//                       style: TextStyle(color: Colors.blue,
//                           fontWeight: FontWeight.bold,fontSize: 16),)
//                 ),
//               ),
//             )),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: Icon(Icons.add),
//         onPressed: _showAddDialog,
//       ),
//     );
//   }

//   _showAddDialog() async {
//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Colors.white70,
//           title: Text("Add Events"),
//           content: TextField(
//             controller: _eventController,
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Save",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//               onPressed: () {
//                 if (_eventController.text.isEmpty) return;
//                 setState(() {
//                   if (_events[_controller.selectedDay] != null) {
//                     _events[_controller.selectedDay]
//                         .add(_eventController.text);
//                   } else {
//                     _events[_controller.selectedDay] = [
//                       _eventController.text
//                     ];
//                   }
//                   prefs.setString("events", json.encode(encodeMap(_events)));
//                   _eventController.clear();
//                   Navigator.pop(context);
//                 });

//               },
//             )
//           ],
//         ));
//   }
// }
////////////////////////
// Container(
//                           height: 300,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: NetworkImage(
//                                       '${eventsedRegester[index].event_image.toString()}'))),
//                           child: ListTile(
//                             onTap: () {
//                               Navigator.of(context).pushNamed(
//                                   '/eventsdetailsdesign',
//                                   arguments: ScreenArguments(
//                                       id: eventsedRegester[index].id,
//                                       scf: Server_Connection_Functions(),
//                                       context: context));
//                             },
//                             tileColor: eventsedRegester[index].favorite
//                                 ? Colors.white70
//                                 : Colors.blue,
//                             subtitle: Text(
//                               eventsedRegester[index].owner.toString(),
//                               style: TextStyle(
//                                 color: Colors.brown,
//                               ),
//                             ),
//                             leading: CircleAvatar(
//                               radius: 22,
//                               backgroundColor: Colors.black,
//                               child: CircleAvatar(
//                                   backgroundColor: Colors.transparent,
//                                   radius: 20,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                             image: NetworkImage(
//                                                 '${eventsedRegester[index].owner_image.toString()}'),
//                                             fit: BoxFit.fill),
//                                         shape: BoxShape.circle),
//                                   )),
//                             ),
//                             title: Text(
//                               eventsedRegester[index].name,
//                               style: TextStyle(
//                                   color: Colors.brown, fontSize: 19),
//                             ),
//                           ),
//                         ),
