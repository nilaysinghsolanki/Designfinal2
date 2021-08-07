import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final  Final;
  final BorderRadius radius;
  const SkeletonContainer._({Key key,this.width=double.infinity,this.height=double.infinity,this.Final,this.radius}) : super(key: key);
  const SkeletonContainer.square({double width,double height, Final}) : this._(width:width,height:height,Final:Final);
  const SkeletonContainer.circle({BorderRadius radius, Final}) : this._(radius:radius,Final:Final);
  @override
  Widget build(BuildContext context) =>SkeletonAnimation(child: Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Final,
    ),
  ));



}
