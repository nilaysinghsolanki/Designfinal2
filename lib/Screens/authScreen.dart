import 'package:flutter/services.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:nilay_dtuotg_2/plus_controller.dart';
import 'package:rive/rive.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;


  Artboard _riveArtboard;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final username = TextEditingController();
  final pswd = TextEditingController();
  final pswd2 = TextEditingController();
  final email = TextEditingController();
  final otp = TextEditingController();
  final code = TextEditingController();
  bool signingUp = false;
  bool waiting = false;
  // bool signUpOtpStep = false;
  bool obscureText = true;
  bool forgotPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: //AuthForm(),
            Container(
              height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("Assets/newframe.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Form(
        key: formGlobalKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //.......................HEADING
              Container(
                child: Text(
                  signingUp ? 'Sign Up' : 'Log in',
                  style: TextStyle(
                  
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),
                ),
                margin: EdgeInsets.only(top: 60, bottom: 20),
              ),
              //......................TEXT ENTRYING

              if (signingUp)
                //  if (!signUpOtpStep)
                Padding(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF2EFE4),
                      borderRadius: BorderRadius.circular(25.0)
                    ),

                    child: TextField(


                      controller: email,
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(

                        fillColor: Color(0xffF2EFE4),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "email id ",
                        labelStyle:
                        TextStyle( fontSize: 20,color: Colors.black),
                      ),

                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
                ),
              //   if (!signUpOtpStep)
              Padding(

                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF2EFE4),
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: TextField(


                    controller: username,
                    style: TextStyle( fontSize: 30),

                    cursorHeight: 35,
                    decoration: InputDecoration(

                      fillColor: Color(0xffF2EFE4),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide( width: 4),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide( width: 3),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "Username",

                      labelStyle:
                      TextStyle( fontSize: 20,color: Colors.black),
                    ),

                  ),
                ),
                padding: EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              if (!forgotPassword)
                //  if (!signUpOtpStep)
                Padding(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF2EFE4),
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    child: TextField(
                      obscureText: obscureText,


                      controller: pswd,
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(

                        fillColor: Color(0xffF2EFE4),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "enter new password",


                        labelStyle:
                        TextStyle( fontSize: 20,color: Colors.black),
                      ),

                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
                ),
              if (signingUp)
                //   if (!signUpOtpStep)
                Padding(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF2EFE4),
                        borderRadius: BorderRadius.circular(25.0)
                    ),

                    child: TextField(

                      obscureText: obscureText,


                      controller: pswd2,
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(

                        fillColor: Color(0xffF2EFE4),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "enter new password",


                        labelStyle:
                        TextStyle( fontSize: 20,color: Colors.black),
                      ),

                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
                ),
              //////

              if (signingUp)
                //  if (!signUpOtpStep)
                Padding(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF2EFE4),
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    child: TextField(

                      controller: code,
                      style: TextStyle( fontSize: 30),

                      cursorHeight: 35,
                      decoration: InputDecoration(

                        fillColor: Color(0xffF2EFE4),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide( width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Code",


                        labelStyle:
                        TextStyle( fontSize: 20,color: Colors.black),
                      ),

                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
                ),
              //////
              //  if (signUpOtpStep)
              // Padding(
              //   child: CupertinoTextFormFieldRow(
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     maxLength: 6,
              //     decoration: BoxDecoration(
              //
              //     ),
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              //     controller: otp,
              //     //  restorationId: 'otp',
              //     placeholder: 'enter OTP',
              //     keyboardType: TextInputType.number,
              //     //  clearButtonMode: OverlayVisibilityMode.editing,
              //     obscureText: false,
              //     autocorrect: false,
              //     validator: (value) {
              //       if (signingUp && signUpOtpStep) {
              //         if (value.contains(' ')) {
              //           return 'no spaces allowed';
              //         }
              //         if (value.contains('.')) {
              //           return '. not allowed';
              //         }
              //         if (value.length != 6) {
              //           return '6 digits bro';
              //         }
              //         if (value.isEmpty) {
              //           return 'enter otp';
              //         }
              //       }
              //     },
              //   ),
              //   padding:
              //       EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              // ),
              //    if (!signUpOtpStep)
              Padding(
                padding: EdgeInsets.only(left: 22, top: 0, bottom: 0, right: 22),
                child: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Text(
                      obscureText ? 'show password' : 'hide password',
                      style: TextStyle(
                        color: Colors.black,

                          ),
                    )),
              ),
              //    if (!signUpOtpStep)
              if (!waiting)
                Padding(
                  padding:
                      EdgeInsets.only(left: 22, top: 0, bottom: 0, right: 22),
                  child: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          signingUp = !signingUp;
                        });
                      },
                      child: Text(

                        signingUp ? 'OR LOG IN' : 'OR SIGN UP',
                        style:TextStyle(
                          color:Colors.black,
                        ),

                      )),
                ),
              Padding(
                padding: EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),

                      enableFeedback: true,
                      // elevation: MaterialStateProperty.all(0),XXXXXXXXXXXXXXXXXXXXXXXXXXX
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      )),

                    ),
                    onPressed: () async {
                      if (formGlobalKey.currentState.validate() && !waiting) {
                        //*******************LOGIN */
                        if (!signingUp && waiting == false
                            // && !signUpOtpStep
                            ) {
                          setState(() {
                            waiting = true;
                          });
                          Map<String, String> headerslogin = {
                            "Content-type": "application/json"
                          };
                          Map mapjsonnlogin = {
                            "username": "${username.text}",
                            "password": "${pswd.text}"
                          };
                          http.Response response = await http.post(
                              Uri.https(
                                  'dtuotgbeta.azurewebsites.net', 'auth/login/'),
                              headers: headerslogin,
                              body: json.encode(mapjsonnlogin));
                          int statusCode = response.statusCode;
                          print(
                              '///////${response.body}/////////////////////// $statusCode');

                          Map resp = json.decode(response.body);
                          /////failed login
                          if (resp["status"] == 'FAILED')
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username or password is incorrect"),duration: Duration(milliseconds: 1000),));

                          //////
                          setState(() {
                            waiting = false;
                            if (resp["status"] != 'FAILED') {
                              Provider.of<OwnerIdData>(context, listen: false)
                                  .addOwnerId(resp["user_id"]);
                              print(
                                  'owner id///////////////////////////${resp["user_id"]}');

                              ///successfull login
                              print(resp["tokens"]["access"].toString());
                              print(
                                  'first time login.............. ${resp["first_time_login"]}');
                              //
                              if (resp["first_time_login"] == true) {
                                Provider.of<AccessTokenData>(context,
                                        listen: false)
                                    .setTokenAndDate(
                                        resp["tokens"]["access"].toString());
                                Provider.of<UsernameData>(context, listen: false)
                                    .addUsername(username.text);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logging you in ${username.text.toString()}"),duration: Duration(milliseconds: 1000),));

                                Navigator.of(context).pushNamed(
                                    '/homeScreen',
                                    arguments:
                                        ScreenArguments(username: username.text));
                              } else {
                                Provider.of<AccessTokenData>(context,
                                        listen: false)
                                    .addAccessToken(
                                        resp["tokens"]["access"].toString(),
                                        DateTime.now());
                                Provider.of<UsernameData>(context, listen: false)
                                    .addUsername(username.text);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logging you in ${username.text.toString()}"),duration: Duration(milliseconds: 1000),));



                                Navigator.of(context).pushNamed('/homeScreen');

                              }
                                }
                          });
                        }
//////////////////////////////////////////////////////////////
                        // if (signUpOtpStep) {
                        //   setState(() {
                        //     waiting = true;
                        //   });
                        //   String urlEmailVerify =
                        //       'https://dtu-otg.herokuapp.com/auth/email-verify/';
                        //   Map<String, String> headersEmailVerify = {
                        //     "Content-type": "application/json"
                        //   };
                        //   Map mapjsonnEmailVerify = {
                        //     "username": "${username.text}",
                        //     "code": int.parse(otp.text)
                        //   };
                        //   http.Response response = await http.post(
                        //       Uri.https('dtu-otg.herokuapp.com',
                        //           'auth/email-verify/'),
                        //       headers: headersEmailVerify,
                        //       body: json.encode(mapjsonnEmailVerify));
                        //   int statusCode = response.statusCode;
                        //   print(
                        //       '///////${response.body}/////////////////////// $statusCode');

                        //   Map resp = json.decode(response.body);
                        //   if (resp["status"] != 'OK')
                        //     showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return Dialog(
                        //             child: Container(
                        //               child: Text(response.body),
                        //             ),
                        //           );
                        //         });
                        //   setState(() {
                        //     waiting = false;
                        //     if (resp["status"] == 'OK') {
                        //       signUpOtpStep = false;
                        //       signingUp = false;
                        //       obscureText = false;
                        //       // Navigator.of(context)
                        //       //     .pushNamed('/EnterDetailsScreen');
                        //     }
                        //   });
                        //   if (resp["status"] == 'OK')
                        //     showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return Dialog(
                        //             child: Container(
                        //               padding: EdgeInsets.all(22),
                        //               child: Text(
                        //                   'You are signed up , now go and log in to use the app'),
                        //             ),
                        //           );
                        //         });
                        // }
////////////////////////////////////////////////////////////////////////////////////
                        if (signingUp //&& !signUpOtpStep
                            &&
                            waiting == false) {
                          if (pswd.text == pswd2.text) {
                            Map<String, String> headers = {
                              "Content-type": "application/json"
                            };
                            Map mapjsonn = {
                              "email": "${email.text}",
                              "username": "${username.text}",
                              "password": "${pswd.text}",
                              "code": "${code.text}"
                            };
                            // print(jsonn);
                            // var urL = Uri(
                            //     path: 'https://dtu-otg.herokuapp.com/auth/register/');

                            String url =
                                'https://dtuotgbeta.azurewebsites.net/auth/register/';
                            setState(() {
                              waiting = true;
                            });
                            http.Response response = await http.post(
                                Uri.https(
                                    'dtuotgbeta.azurewebsites.net', 'auth/register/'),
                                headers: headers,
                                body: json.encode(mapjsonn));
                            int statusCode = response.statusCode;
                            print(
                                '///////${response.body}/////////////////////// $statusCode');

                            //404 not found
                            //201 obj created
                            //503 internal server error
                            //200 ok
                            Map resp = json.decode(response.body);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      child: Text(response.body),
                                    ),
                                  );
                                });
                            setState(() {
                              waiting = false;
                              if (resp["status"] == 'OK') {
                                //  signUpOtpStep = true;
                                // Provider.of<EmailAndUsernameData>(context,
                                //         listen: false)
                                //     .addEmailAndUsername(
                                //         email.text, username.text);
                                setState(() {
                                  waiting = false;

                                  signingUp = false;
                                  obscureText = false;
                                });
                                //
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(22),
                                          child: Text(
                                              'You are signed up , now go and log in to use the app'),
                                        ),
                                      );
                                    });
                                //
                              }
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      child: Text('both pswds should be same'),
                                    ),
                                  );
                                });
                          }
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  child: Text('enter valid inputs'),
                                ),
                              );
                            });
                      }
                    },
                    child: waiting
                        ? CircularProgressIndicator()
                        : Text(signingUp
                            // ? signUpOtpStep
                            //   ? '       verify otp        '
                            // : '            send otp            '
                            ? '   SIGN UP '
                            : '              LOG IN           ')),
              )
            ],
          ),
        ),
      ),
    ));
    //////////////////////////////////////////////////////////////////////////
    //FUNCTIONS...LOGIN SIGNUP_SENDOTP...OTP_VERIFY
  }
}
