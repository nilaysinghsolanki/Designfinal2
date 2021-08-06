import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import '../plus_controller.dart';
class EventsListDesign extends StatefulWidget {
  const EventsListDesign({Key key}) : super(key: key);
  static const routeName = '/eventlistdesign';
  @override
  _EventsListDesignState createState() => _EventsListDesignState();
}

class _EventsListDesignState extends State<EventsListDesign> {
  TextStyle general_text_style = TextStyle(color: Colors.brown);
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Color newcolor = Colors.transparent;
  bool registered_Animation;


  Artboard _riveArtboard;


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
        if(!registered_Animation) {
          setState(() => _riveArtboard = artboard);
          _riveArtboard.addController(
              _plusAnimation = PlusAnimation('idle_unregistered'));
        }
        else setState(() => _riveArtboard = artboard);
        _riveArtboard.addController(
            _plusAnimation = PlusAnimation('idle_unregistered'));     },

    );
  }
  List<Widget> DescriptionCategories=[

  ];
  Widget build(BuildContext context) {
    List<Widget> DescriptionCategories=[
      ListTile(

        leading: Icon(
          FontAwesomeIcons.star,
          color: Colors.purple,
        ),

        title: Text("Add to Events", style: general_text_style),
        subtitle: Text(
            "Update via this feature to let people know the details of any event"),
      ),
      ListTile(

        leading: Icon(
          FontAwesomeIcons.star,
          color: Colors.purple,
        ),
        title: Text("Add to Events", style: general_text_style),
        subtitle: Text(
            "Update via this feature to let people know the details of any event"),
      ),
      ListTile(

        leading: Icon(
          FontAwesomeIcons.star,
          color: Colors.purple,
        ),
        title: Text("Add to Events", style: general_text_style),
        subtitle: Text(
            "Update via this feature to let people know the details of any event"),
      ),

      ListTile(


        leading: CircleAvatar(),
        title: Text("ENGIFEST", style: general_text_style),
        subtitle: Text(
            "You know what it is "),
        trailing: CircleAvatar(),
      ),

    ];
    return
      Scaffold(
          appBar: AppBar(
            title: Text("Upcoming Events",style: TextStyle(color: Colors.black54),),
            iconTheme: IconThemeData(color: Colors.black54),
            elevation: 0,
            backgroundColor: Color(0xffF2EFE4),
            foregroundColor: Colors.black,
          ),
          body:  Container(
            decoration: BoxDecoration(

                image: DecorationImage(
                    image: AssetImage("Assets/newframe.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,

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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                          child: Container(



                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              color: Colors.white,
                            ),
                            child: Center(child: DescriptionCategories[index]),
                          ),
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
