import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nilay_dtuotg_2/Screens/testingScreen.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../plus_controller.dart';
import '../providers/info_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool initialized = false;
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Color newcolor = Colors.transparent;

  Artboard _riveArtboard;
  String accessTokenValue;



  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/BT_animation.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard
            .addController(_plusAnimation = PlusAnimation('Animation 1'));
        _plusAnimation.instance.animation.loop = Loop.loop;
      },
    );
  }
  @override


  void didChangeDependencies() async {


    // TODO: implement didChangeDependencies
    if (!initialized) {
      rootBundle.load('Assets/BT_animation.riv').then(
            (data) async {
          // Load the RiveFile from the binary data.
          final file = RiveFile.import(data);

          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;

          // Add a controller to play back a known animation on the main/default
          // artboard. We store a reference to it so we can toggle playback.
          setState(() {
            _riveArtboard = artboard;
            _riveArtboard
                .addController(_plusAnimation = PlusAnimation('Animation 1'));
            _plusAnimation.instance.animation.loop = Loop.loop;


          });







        },


      );

      Provider.of<UsernameData>(context, listen: false).fetchAndSetData();

      await Provider.of<OwnerIdData>(context, listen: false).fetchAndSetData();
      await Provider.of<AccessTokenData>(context, listen: false)
          .fetchAndSetData();
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      //date time expiry check needs to be added for token
      if (accessToken.isEmpty) {
        print('empty if');
        Navigator.of(context).pushNamed('/AuthScreen');
      } else {
        print('non empty else');
        accessTokenValue = accessToken[0];

        print('accessTokenValue');
        Map<String, String> headersAccessToken = {
          "Content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $accessTokenValue"
        };

        http.Response response = await http.get(
          Uri.https('dtuotg.azurewebsites.net', 'auth/check-auth'),
          headers: headersAccessToken,
        );
        int statusCode = response.statusCode;
        var resp = json.decode(response.body);
        if (resp["status"] == 'OK') {

          //Navigator.of(context).pushReplacementNamed(TestingScreen.routeName);

          // Navigator.of(context).pushReplacementNamed(TestingScreen.routeName);

          Navigator.of(context).pushReplacementNamed('/homeScreen');
        } else {
          Navigator.of(context).pushReplacementNamed('/AuthScreen');
        }
      }
      initialized = true;

      print(initialized);
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {





    return  Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/LogoOTG.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
