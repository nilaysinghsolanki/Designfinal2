import 'package:cached_network_image/cached_network_image.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:nilay_dtuotg_2/widgets/rollNumberPicker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:network_to_file_image/network_to_file_image.dart';
import '../widgets/yearPicker.dart' as yp;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';

class PatchProfileScreen extends StatefulWidget {
  static const routeName = '/patchProfileScreen';
  @override
  _PatchProfileScreenState createState() => _PatchProfileScreenState();
}

class _PatchProfileScreenState extends State<PatchProfileScreen> {
  //bool initialized = false;
  int rollNum;
  int year;
  String _myBranch;
  String _myBatch;
  String username = 'dtuotg';
  bool initialized = false;
  @override
  void initState() {
    super.initState();
  }
  Map<String, dynamic> data;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    print('a');
    PickedFile pickedFile;
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      print('b');
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
      print('${pickedFile.path}');
    } catch (e) {
      print('c');
      print(e.code);
    }
    setState(() {
      print('d');
      if (pickedFile != null) {
        print('e');
        _image = File(pickedFile.path);
      } else {
        print('f');
        print('No image selected.');
      }
    });
  }

  @override
  void didChangeDependencies() async {
    if (!initialized) {
      BuildContext ctx =
          Provider.of<MaterialNavigatorKey>(context, listen: false)
              .materialNavigatorKey
              .currentContext;
      data = await Server_Connection_Functions().getProfileData(ctx);
      await Provider.of<UsernameData>(context, listen: false).fetchAndSetData();
      username = Provider.of<UsernameData>(context, listen: false).username[0];
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      Map<String, String> headersEvents = {
        "Content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $accessToken"
      };
      http.Response response = await http.get(
        Uri.https('dtuotgbeta.azurewebsites.net', '/auth/profile/view/$username'),
        headers: headersEvents,
      );
      int statusCode = response.statusCode;
      Map<String, dynamic> resp = json.decode(response.body);
      _myBatch = resp['batch'];
      _myBranch = resp['branch'];
      year = resp['year'];
      rollNum = resp['roll_no'];

      setState(() {
        initialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final formGlobalKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();
  final instagram = TextEditingController();
  final linkedIn = TextEditingController();
  bool waiting = false;
  @override
  Widget build(BuildContext context) {
    print('////username$username');
    rollNum = Provider.of<ProfileData>(context).rollNumber.isEmpty
        ? 0
        : Provider.of<ProfileData>(context).rollNumber[0];
    year = Provider.of<ProfileData>(context).year.isEmpty
        ? DateTime.now().year
        : Provider.of<ProfileData>(context).year[0];
    return !initialized
        ? CircularProgressIndicator.adaptive()
        : Scaffold(

            persistentFooterButtons: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(

                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (formGlobalKey.currentState.validate() &&
                        waiting == false) {
                      Provider.of<ProfileData>(context, listen: false)
                          .setName(name.text);
                      var accessToken =
                          Provider.of<AccessTokenData>(context, listen: false)
                              .accessToken;
                      var accessTokenValue = accessToken[0];
                      //if status is ok  // // // //     Provider.of<ProfileData>(context, listen: false)
                      // // // //         .saveSetedChanges();
                      setState(() {
                        waiting = true;
                      });
                      Map<String, String> headersProfile = {
                        "Content-type": "multipart/form-data",
                        "accept": "application/json",
                        "Authorization": "Bearer $accessTokenValue"
                      };
                      var rollNUmString = rollNum.toString();
                      var formattedRollNum = rollNUmString.length == 3
                          ? rollNum
                          : rollNUmString.length == 2
                              ? '0' + rollNUmString
                              : '00' + rollNUmString;
                      // Map mapjsonnprofile = {
                      //   "name": "${name.text}",
                      //   "roll_no": "$formattedRollNum",
                      //   "branch":
                      //       "${Provider.of<ProfileData>(context, listen: false).getBranch()}",
                      //   "year": Provider.of<ProfileData>(context, listen: false)
                      //       .getYear(),
                      //   "batch":
                      //       "${Provider.of<ProfileData>(context, listen: false).getBatch()}",
                      //   "image": _image
                      // };
                      // http.Response response = await http.patch(
                      //     Uri.https('dtuotgbeta.azurewebsites.net',
                      //         'auth/profile/$username'),
                      //     headers: headersProfile,
                      //     body: json.encode(mapjsonnprofile));
                      // int statusCode = response.statusCode;
                      // var resp = json.decode(response.body);
                      // print('/////////enter detail screen response $resp');
                      // setState(() {
                      //   waiting = false;
                      // });
                      ////

                      Response responsee;
                      var dio = Dio();
                      var formdata = FormData.fromMap({
                        "name": "${name.text}",

                        "roll_no": "$formattedRollNum",
                        "branch":
                            "${Provider.of<ProfileData>(context, listen: false).getBranch()}",
                        "year": Provider.of<ProfileData>(context, listen: false)
                            .getYear(),
                        "batch":
                            "${Provider.of<ProfileData>(context, listen: false).getBatch()}",
                        "image": await MultipartFile.fromFile(
                          _image.path,
                          filename: _image.path,
                        ),
                        "description":description.text +
                            '~\$' +
                      "https://www.instagram.com/${instagram.text}/" +
                            '\$~' +
                            linkedIn.text,
                        "owner_id__username":username
                      });
                      responsee = await dio.put(
                        'dtuotgbeta.azurewebsites.netauth/profile/$username',
                        data: formdata,
                        options: Options(
                          headers: headersProfile,
                        ),
                        onSendProgress: (int sent, int total) {
                          print('$sent $total');
                        },
                      );

                      ////
                      if (responsee.data["status"] != 'FAILED') {
                        //   Provider.of<ProfileData>(context, listen: false)
                        //     .saveSetedChanges();
                        Provider.of<AccessTokenData>(context, listen: false)
                            .addAccessToken(
                                Provider.of<AccessTokenData>(context,
                                        listen: false)
                                    .getAccessToken(),
                                Provider.of<AccessTokenData>(context,
                                        listen: false)
                                    .getDateTime());
                        Navigator.of(context).pushNamed('/homeScreen');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  child: Text(responsee.data),
                                ),
                              );
                            });
                      }
                    }
                  }
                  ////////TOKEN?save, BATCH,RESPONSE CHECK,IF OK THEN SAVE IN DATA BASE
                  // onPressed: () async {
                  //   if (formGlobalKey.currentState.validate() &&
                  //       waiting == false) {
                  //     Provider.of<ProfileData>(context, listen: false)
                  //         .setName(name.text);
                  //     var accessToken =
                  //         Provider.of<AccessTokenData>(context, listen: false)
                  //             .accessToken;
                  //     var accessTokenValue = accessToken[0];
                  //     //if status is ok  // // // //     Provider.of<ProfileData>(context, listen: false)
                  //     // // // //         .saveSetedChanges();
                  //     setState(() {
                  //       waiting = true;
                  //     });
                  //     Map<String, String> headersProfile = {
                  //       "Content-type": "multipart/form-data",
                  //       "accept": "application/json",
                  //       "Authorization": "Bearer $accessTokenValue"
                  //     };
                  //     var rollNUmString = rollNum.toString();
                  //     var formattedRollNum = rollNUmString.length == 3
                  //         ? rollNum
                  //         : rollNUmString.length == 2
                  //             ? '0' + rollNUmString
                  //             : '00' + rollNUmString;
                  //     Map mapjsonnprofile = {
                  //       "name": "${name.text}",
                  //       "roll_no": "$formattedRollNum",
                  //       "branch":
                  //           "${Provider.of<ProfileData>(context, listen: false).getBranch()}",
                  //       "year": Provider.of<ProfileData>(context, listen: false)
                  //           .getYear(),
                  //       "batch":
                  //           "${Provider.of<ProfileData>(context, listen: false).getBatch()}",
                  //       "image": _image
                  //     };
                  //     http.Response response = await http.patch(
                  //         Uri.https('dtuotgbeta.azurewebsites.net',
                  //             'auth/profile/$username'),
                  //         headers: headersProfile,
                  //         body: json.encode(mapjsonnprofile));
                  //     int statusCode = response.statusCode;
                  //     var resp = json.decode(response.body);
                  //     print('/////////enter detail screen response $resp');
                  //     setState(() {
                  //       waiting = false;
                  //     });
                  //     if (resp["status"] != 'FAILED') {
                  //       //   Provider.of<ProfileData>(context, listen: false)
                  //       //     .saveSetedChanges();
                  //       Provider.of<AccessTokenData>(context, listen: false)
                  //           .addAccessToken(
                  //               Provider.of<AccessTokenData>(context,
                  //                       listen: false)
                  //                   .getAccessToken(),
                  //               Provider.of<AccessTokenData>(context,
                  //                       listen: false)
                  //                   .getDateTime());
                  //       Navigator.of(context).pushNamed('/homeScreen');
                  //     } else {
                  //       showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return Dialog(
                  //               child: Container(
                  //                 child: Text(response.body),
                  //               ),
                  //             );
                  //           });
                  //     }
                  //   }
                  // },
                  ,
                  child: waiting
                      ? CircularProgressIndicator()
                      : Text(
                          'save and next',
                          style: TextStyle(),
                        ))
            ],
            appBar: AppBar(

              title: Text('ENTER DETAILS 2nd time'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/newframe.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Form(
                  key: formGlobalKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.height / 7, 0, 0),
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height / 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(data['image'].toString(),),


                        ),
                      ),
                      _image == null
                          ? ListTile(
                              leading: Icon(Icons.add_a_photo),
                              title: Text('No image selected.'),
                              onTap: getImage,
                            )
                          : Container(
                              child: Image.file(_image),
                              height: 100,
                            ),
                      Card(
                        elevation: 0,

                        child: TextField(
                          controller: description,
                          style: TextStyle( fontSize: 30),

                          cursorHeight: 35,
                          decoration: InputDecoration(
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
                            labelText: "link to more details/website/meeting",


                            labelStyle:
                            TextStyle( fontSize: 20),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,

                        child: TextField(
                          controller: instagram,
                          style: TextStyle( fontSize: 30),

                          cursorHeight: 35,
                          decoration: InputDecoration(
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
                            labelText: "instagram",


                            labelStyle:
                            TextStyle( fontSize: 20),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,

                        child: TextField(
                          controller: linkedIn,
                          style: TextStyle( fontSize: 30),

                          cursorHeight: 35,
                          decoration: InputDecoration(
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
                            labelText: "linkedIn",


                            labelStyle:
                            TextStyle( fontSize: 20),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,

                        child: TextField(
                          controller: name,
                          style: TextStyle( fontSize: 30),

                          cursorHeight: 35,
                          decoration: InputDecoration(
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
                            labelText: "Name(You would like others see)",


                            labelStyle:
                            TextStyle( fontSize: 20),
                          ),
                        ),
                      ),


                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: RollNumberPicker(),
                                );
                              });
                        },
                        title: Text('rollnumber'),
                        trailing: Text(rollNum.toString()),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: yp.YearPicker(),
                                );
                              });
                        },
                        title: Text('year'),
                        trailing: Text(year.toString()),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: DropDownFormField(
                          titleText: 'BRANCH',
                          hintText: 'Please choose one',
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'select  branch';
                          //   }
                          // },
                          value: _myBranch,
                          onSaved: (value) {
                            Provider.of<ProfileData>(context, listen: false)
                                .setBranch(value);
                            setState(() {
                              _myBranch = value;
                            });
                          },
                          onChanged: (value) {
                            Provider.of<ProfileData>(context, listen: false)
                                .setBranch(value);
                            setState(() {
                              _myBranch = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "ECE",
                              "value": "ec",
                            },
                            {
                              "display": "BT",
                              "value": "bt",
                            },
                            {
                              "display": "CE",
                              "value": "ce",
                            },
                            {
                              "display": "CO",
                              "value": "co",
                            },
                            {
                              "display": "EE",
                              "value": "ee",
                            },
                            {
                              "display": "EN",
                              "value": "en",
                            },
                            {
                              "display": "EP",
                              "value": "ep",
                            },
                            {
                              "display": "it",
                              "value": "it",
                            },
                            {
                              "display": "me",
                              "value": "me",
                            },
                            {
                              "display": "ae",
                              "value": "ae",
                            },
                            {
                              "display": "mc",
                              "value": "mc",
                            },
                            {
                              "display": "pe",
                              "value": "pe",
                            },
                            {
                              "display": "pt",
                              "value": "pt",
                            },
                            {
                              "display": "se",
                              "value": "se",
                            },
                            {
                              "display": "bd",
                              "value": "bd",
                            }
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: DropDownFormField(
                          titleText: 'Batch',
                          hintText: 'Please choose one',
                          // validator: (value) {
                          //   if (value != '') {
                          //     return 'select  batch';
                          //   }
                          // },
                          value: _myBatch,
                          onSaved: (value) {
                            Provider.of<ProfileData>(context, listen: false)
                                .setBatch(value);
                            setState(() {
                              _myBatch = value;
                            });
                          },
                          onChanged: (value) {
                            Provider.of<ProfileData>(context, listen: false)
                                .setBatch(value);
                            setState(() {
                              _myBatch = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "a1",
                              "value": "a1",
                            },
                            {
                              "display": "B1",
                              "value": "b1",
                            },
                            {
                              "display": "a2",
                              "value": "a2",
                            },
                            {
                              "display": "b2",
                              "value": "b2",
                            },
                            {
                              "display": "a3",
                              "value": "a3",
                            },
                            {
                              "display": "b3",
                              "value": "b3",
                            },
                            {
                              "display": "a4",
                              "value": "a4",
                            },
                            {
                              "display": "b4",
                              "value": "b4",
                            },
                            {
                              "display": "a5",
                              "value": "A5",
                            },
                            {
                              "display": "b5",
                              "value": "b5",
                            },
                            {
                              "display": "a6",
                              "value": "a6",
                            },
                            {
                              "display": "b6",
                              "value": "b6",
                            },
                            {
                              "display": "a7",
                              "value": "a7",
                            },
                            {
                              "display": "b7",
                              "value": "b7",
                            },
                            {
                              "display": "a8",
                              "value": "a8",
                            },
                            {
                              "display": "b8",
                              "value": "b8",
                            },
                            {
                              "display": "a9",
                              "value": "a9",
                            },
                            {
                              "display": "b9",
                              "value": "b9",
                            },
                            {
                              "display": "a10",
                              "value": "a10",
                            },
                            {
                              "display": "b10",
                              "value": "b10",
                            },
                            {
                              "display": "a11",
                              "value": "a11",
                            },
                            {
                              "display": "b11",
                              "value": "b11",
                            },
                            {
                              "display": "a12",
                              "value": "a12",
                            },
                            {
                              "display": "b12",
                              "value": "b12",
                            },
                            {
                              "display": "a13",
                              "value": "a13",
                            },
                            {
                              "display": "b13",
                              "value": "b13",
                            },
                            {
                              "display": "a14",
                              "value": "a14",
                            },
                            {
                              "display": "b14",
                              "value": "b14",
                            },
                            {
                              "display": "a15",
                              "value": "a15",
                            },
                            {
                              "display": "b15",
                              "value": "b15",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
///////dont forget to save access token permenantly
