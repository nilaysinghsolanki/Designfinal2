import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  static const routeName = '/StoryViewScreen';
  StoryViewScreen({Key key}) : super(key: key);
  final StoryController controller = StoryController();
  bool initialised=false;
  List<StoryItem> storyItems;
  List<Image> storyImages;


  @override


  Widget build(BuildContext context) {

    if(!initialised) {
      ScreenArguments args = ModalRoute
          .of(context)
          .settings
          .arguments;


      storyItems = args.eves
          .map((e) =>
          StoryItem.inlineImage(
              imageFit: BoxFit.fitWidth,
              caption: Text(
                e.name,
                style: TextStyle(color: Colors.white),
              ),
              url: e.event_image,
              controller: controller,
              imageBackground: e.event_image,
              duration: Duration(seconds: 5))
      )
          .toList();
      int i=1;
      while(i<=storyItems.length) {
        precacheImage(NetworkImage(args.eves[i-1].event_image), context);
        i++;
      }


      initialised=true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

        color: Colors.white,


        child: StoryView(

          onComplete: () => Navigator.of(context).pop(),
          controller: controller,
          storyItems: storyItems,
        ),
      ),
    );
  }
}
