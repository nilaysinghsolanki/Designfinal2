import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  static const routeName = '/StoryViewScreen';
  StoryViewScreen({Key key}) : super(key: key);
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    List<StoryItem> storyItems = args.eves
        .map((e) => StoryItem.inlineImage(
            imageFit: BoxFit.contain,
            caption: Text(
              e.name,
              style: TextStyle(color: Colors.white),
            ),
            url: e.event_image,
            controller: controller,
            duration: Duration(seconds: 5))
    )
        .toList();
    return Scaffold(
      body: Container(


        child: StoryView(
          onComplete: () => Navigator.of(context).pop(),
          controller: controller,
          storyItems: storyItems,
        ),
      ),
    );
  }
}
