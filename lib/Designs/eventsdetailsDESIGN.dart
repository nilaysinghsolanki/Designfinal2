import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsDetailsDesign extends StatefulWidget {
  const EventsDetailsDesign({Key key}) : super(key: key);
  static const routeName = '/eventdetailsdesign';
  @override
  _EventsDetailsDesignState createState() => _EventsDetailsDesignState();
}

class _EventsDetailsDesignState extends State<EventsDetailsDesign> {
  TextStyle general_text_style = TextStyle(color: Colors.brown);

  @override
  List<Widget> DescriptionCategories=[

  ];
  Widget build(BuildContext context) {
    List<Widget> DescriptionCategories=[
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(

            leading: Icon(
              FontAwesomeIcons.star,
              color: Colors.purple,
            ),
            title: Text("Add to Events", style: general_text_style),
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

            leading: Icon(
              FontAwesomeIcons.star,
              color: Colors.purple,
            ),
            title: Text("Add to Events", style: general_text_style),
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

            leading: Icon(
              FontAwesomeIcons.star,
              color: Colors.purple,
            ),
            title: Text("Add to Events", style: general_text_style),
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

            leading: Icon(
              FontAwesomeIcons.star,
              color: Colors.purple,
            ),
            title: Text("Add to Events", style: general_text_style),
            subtitle: Text(
                "Update via this feature to let people know the details of any event"),
          ),
        ),
      ),

    ];
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body:  Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/newframe.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(0),

          child: StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),

            crossAxisCount: 4,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) =>
                AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 0,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset:100.0,
                    child: FlipAnimation(
                      flipAxis: FlipAxis.y,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(

                          color: Colors.white,
                        ),
                        child: Center(child: DescriptionCategories[index]),
                      ),
                    ),
                  ),
                ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(16, index.isEven ? 1 : 1),

          ),
        ));




  }
}
