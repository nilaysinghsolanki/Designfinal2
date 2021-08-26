import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nilay_dtuotg_2/models/events.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:path/path.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  static const routeName = '/StoryViewScreen';
  StoryViewScreen({Key key}) : super(key: key);
  final StoryController controller = StoryController();
  bool initialised=false;
  List<StoryItem> storyItems;
  List<Image> storyImages;
  List<List<Event>> ownerlists;


  int integer;
  int j=-1;







  @override


  Widget build(BuildContext context) {


    if(!initialised) {

      ScreenArguments args = ModalRoute
          .of(context)
          .settings
          .arguments;

  ownerlists = args.ownerlist;
  j = ownerlists.length;
  print(j);


 integer=args.id;

      storyItems = args.eves
          .map((e) =>
          StoryItem.inlineImage(
              imageFit: BoxFit.fitWidth,
              caption: Text(
                e.owner,

              ),
              url: e.event_image,
              controller: controller,

              duration: Duration(seconds: 5))
      )
          .toList();
      int i=1;
      while(i<=storyItems.length) {
        precacheImage(CachedNetworkImageProvider(args.eves[i-1].event_image), context);
        i++;
      }


      initialised=true;
    }

    return Scaffold(



      body: GestureDetector(


        child: Container(






            child: StoryView(



              onComplete: () {
                if(integer+1<ownerlists.length) {
                  print("/////////////////////////${integer}");
                  print("/////////////////////////${j}");

                  Navigator.of(context).popAndPushNamed(StoryViewScreen.routeName,
                      arguments: ScreenArguments(
                          id: integer+1,
                          eves: ownerlists[integer+1],ownerlist: ownerlists

                      ));
                  integer++;

                }
                else  Navigator.of(context).pop();

             },
              controller: controller,
              storyItems: storyItems,
            ),
          ),
      ),
    );
  }
}


