import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../plus_controller.dart';
class InternshipDetailsDesign extends StatefulWidget {
  const InternshipDetailsDesign({Key key}) : super(key: key);
  static const routeName = '/internshipdetailsdesign';

  @override
  _InternshipDetailsDesignState createState() => _InternshipDetailsDesignState();
}

class _InternshipDetailsDesignState extends State<InternshipDetailsDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("InternshipDetails must be placed here"),);
  }
}
