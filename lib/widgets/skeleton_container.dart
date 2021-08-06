import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color FinalColor;
  final BorderRadius radius;
  const SkeletonContainer._({Key key,this.width=double.infinity,this.height=double.infinity,this.FinalColor,this.radius}) : super(key: key);
  const SkeletonContainer.square({double width,double height,Color FinalColor}) : this._(width:width,height:height,FinalColor:FinalColor);
  const SkeletonContainer.circle({BorderRadius radius,Color FinalColor}) : this._(radius:radius,FinalColor:FinalColor);
  @override
  Widget build(BuildContext context) =>SkeletonAnimation(child: Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: FinalColor,
    ),
  ));



}
