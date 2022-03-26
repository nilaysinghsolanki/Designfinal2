import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/link.dart';

class ProfileDetailsScreem extends StatefulWidget {
  static const routeName = '/ProfileDetailsScreem';
  @override
  _ProfileDetailsScreemState createState() => _ProfileDetailsScreemState();
}

class _ProfileDetailsScreemState extends State<ProfileDetailsScreem> {
  bool initialized = false;
  Map<String, dynamic> data;
  ScreenArguments args;
  bool host_pressed=false;

  @override
  void didChangeDependencies() async {

    args = ModalRoute.of(context).settings.arguments;
    if (args.hostpressed!=null ){

      host_pressed=args.hostpressed;
    }
    else args.hostpressed=false;
    if (!initialized) {
      BuildContext ctx =
          Provider.of<MaterialNavigatorKey>(context, listen: false)
              .materialNavigatorKey
              .currentContext;
      data =host_pressed==true? await Server_Connection_Functions().getHostData(context, args.username): await Server_Connection_Functions().getProfileData(ctx);
      print(data['image']);
      setState(() {
        initialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        iconTheme:IconThemeData(color:Color(0xff6F6E6E)),
        elevation:0,
        backgroundColor: Color(0xff2b2b2b),


      ),
      body:Container(
        color: Color(0xff6F6E6E),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: BackdropFilter(
        filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: !initialized
      ? Center(
      child: Container(child: FadingText('Loading...')),
      )
          : Container(
      decoration: BoxDecoration(
      image: DecorationImage(
      image: AssetImage("Assets/ProfileBG.png"),
      fit: BoxFit.fitWidth,
      ),
      ),
      child: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
      Container(
      margin: EdgeInsets.fromLTRB(
      0, MediaQuery.of(context).size.height / 7, 0, 0),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 5,
      child: CircleAvatar(
      backgroundColor: Color(0xff6F6E6E),
      radius: 40,
      backgroundImage: CachedNetworkImageProvider(data['image'].toString(),),


      ),
      ),
      Container(
      margin:
      EdgeInsets.symmetric(vertical: 11, horizontal: 4),
      padding:
      EdgeInsets.symmetric(vertical: 11, horizontal: 44),
      child: Text(data['name'].toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
      fontStyle: FontStyle.normal,
      fontFamily: 'DancingScript',
      fontSize: 20)),
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
      data['description']
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
      style: TextStyle(
      fontWeight: FontWeight.bold,


      ),
      ),
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

      child: Link(
      uri: Uri.parse(data['description']
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
      )),
      target: LinkTarget.blank,
      builder: (ctx, openLink) {
      return TextButton.icon(
      onPressed: openLink,
      label: Text('linkedIn'),
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

      child: Link(
      uri: Uri.parse(data['description']
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
          .indexOf('\$~'))),
      target: LinkTarget.blank,
      builder: (ctx, openLink) {
      return TextButton.icon(
        style:TextButton.styleFrom(
          primary:Colors.purple,

        ),
      onPressed: openLink,
        label: Text('instagram'),
        icon: Icon(FontAwesomeIcons.instagram,color: Colors.purple,),

      );
      },
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
             if (data['who_sent'].toString()=="admin") Text('invited by ',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'DancingScript',
                      fontSize: 20)),
              TextButton(style: ButtonStyle(
                foregroundColor:MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              ),
                onPressed: () {
                  setState(() {

                  });
                  Navigator.of(context).pushNamed(
                      '/ProfileDetailsScreen',
                      arguments: ScreenArguments(
                          username:data['who_sent'].toString()
                          ,
                          hostpressed: false));
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
      )
    );
  }
}
