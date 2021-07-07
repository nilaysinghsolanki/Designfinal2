import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:nilay_dtuotg_2/widgets/eventDurationPicker.dart';
import 'package:nilay_dtuotg_2/widgets/eventOwnerPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = 'AddEventScreen';
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final name = TextEditingController();
  final description = TextEditingController();
  final whatsInItForYou = TextEditingController();
  final link = TextEditingController();
  bool imagePicked = false;
  bool imageCroped = false;
  @override
  void initState() {
    name.text = 'name';
    description.text = 'description';
    whatsInItForYou.text = "What's in it for Students?";
    link.text = "link";
    // TODO: implement initState
    super.initState();
  }

  DateTime dateTime;
  TimeOfDay timeOfDay;
  final controller = CropController();

  File _image;
  final picker = ImagePicker();
  var _imageDataList = <Uint8List>[];

  void _showPicker(BuildContext context, num ratio) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        barrierColor: Colors.black12,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(11),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 10 * ratio, horizontal: 22 * ratio),
//color: Colors.cyan,
              margin: EdgeInsets.only(
                top: 20 * ratio,
                left: 15 * ratio,
                right: 15 * ratio,
              ),
              child: new Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.blueGrey[700],
                      ),
                      title: new Text(
                        'Photos',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  Divider(),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.blueGrey[700],
                    ),
                    title: new Text('Camera',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource imageSource) async {
    print('a');
    PickedFile pickedFile;
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      print('b');
      pickedFile = await picker.getImage(
        source: imageSource,
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
        imagePicked = true;
      } else {
        print('f');
        print('No image selected.');
      }
    });
  }

  final formGlobalKey = GlobalKey<FormState>();
  bool waiting = false;
  var resp;
  int type;
  DateTime now = DateTime.now();
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;

    type = ModalRoute.of(context).settings.arguments;
    // BuildContext bc =
    //     Provider.of<TabsScreenContext>(context, listen: false).get();
    var data = Provider.of<AddEventScreenData>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.brown,
      persistentFooterButtons: [
        ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(primary: Colors.white, elevation: 0),
            onPressed: () async {
              print('1');
              setState(() {
                waiting = true;
              });
              if (dateTime != null &&
                  timeOfDay != null &&
                  name != null &&
                  description != null &&
                  type != null) {
                print('2');
                var scf = Provider.of<SCF>(context, listen: false).get();
                int resp = await scf.createEvent(
                    context,
                    name.text,
                    description.text +
                        '~\$' +
                        whatsInItForYou.text +
                        '\$~' +
                        link.text,
                    type,
                    dateTime,
                    timeOfDay,
                    _image);
                scf.fetchListOfEvents(context);

                print('3');
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Text(resp.toString()),
                        ),
                      );
                    });

                if (resp <= 205) {
                  Navigator.of(context).pop();
                }
              }
              setState(() {
                waiting = false;
              });
            },
            icon: Icon(
              Icons.save,
              color: Colors.brown,
            ),
            label: waiting
                ? CircularProgressIndicator()
                : Text(
                    'save',
                    style: TextStyle(color: Colors.brown),
                  ))
      ],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: type == 1
            ? Text('add event')
            : type == 2
                ? Text('add projects')
                : Text('add internships/jobs'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/newframe.png"), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image == null
                  ? ListTile(
                      leading: Icon(Icons.add_a_photo),
                      title: Text('No image selected.'),
                      onTap: () => _showPicker(context, ratio),
                    )
                  : Container(
                      child: Image.file(_image),
                      height: 100,
                    ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.white,
                    side: BorderSide(color: Colors.brown, width: 2)),
                child: Text(
                  'Pick A Date',
                  style: TextStyle(color: Colors.brown),
                ),
                autofocus: true,
                clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2021),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2022));
                  print('$dateTime');
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.white,
                    side: BorderSide(color: Colors.brown, width: 2)),
                onPressed: () async {
                  timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 1, minute: 0),
                  );
                  print('$timeOfDay');
                },
                child: Text(
                  "startingTime?",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/newframe.png"),
                      fit: BoxFit.cover),
                ),
                child: ListTile(
                  leading: Icon(Icons.timelapse),
                  tileColor: Colors.white,
                  title: Text('Duration?'),
                  trailing: Text('${data.getHours()}h ${data.getMinutes()}min'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(child: DurationPicker());
                        });
                  },
                ),
              ),
              // ListTile(
              //   leading: Icon(Icons.people),
              //   tileColor: Colors.blue[200],
              //   title: Text('owners'),
              //   trailing: Text('${data.getOwners()}'),
              //   onTap: () {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return Dialog(child: OwnerPicker());
              //         });
              //   },
              // ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  cursorColor: Colors.brown,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  maxLength: 20,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: name,
                  //  restorationId: 'username',
                  placeholder: 'Name of the event',
                  keyboardType: TextInputType.emailAddress,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 20) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'enter name';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  maxLength: 2000, maxLines: 8, minLines: 1,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: description,
                  //  restorationId: 'username',
                  placeholder: "",
                  keyboardType: TextInputType.multiline,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 2000) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'enter description';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  maxLength: 2000, maxLines: 8, minLines: 1,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: whatsInItForYou,
                  //  restorationId: 'username',
                  placeholder: "",
                  keyboardType: TextInputType.multiline,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 2000) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'what\'s In It For students';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  maxLength: 2000, maxLines: 8, minLines: 1,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: link,
                  //  restorationId: 'username',
                  placeholder: "",
                  keyboardType: TextInputType.multiline,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 2000) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'link for event or website';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),

              // Container(
              //   padding: EdgeInsets.all(20),
              //   child: DropDownFormField(
              //     textField: 'display',
              //     valueField: 'value',
              //     dataSource: [
              //       {
              //         "display": "type1",
              //         "value": 1,
              //       },
              //       {
              //         "display": "type2",
              //         "value": 2,
              //       },
              //       {
              //         "display": "type3",
              //         "value": 3,
              //       },
              //     ],
              //     onSaved: (value) {
              //       setState(() {
              //         type = value;
              //       });
              //     },
              //     onChanged: (value) {
              //       setState(() {
              //         type = value;
              //       });
              //     },
              //     titleText: 'event type',
              //     value: type,
              //     hintText: 'choose event type',
              //   ),
              // ),
            ],
          )),
        ),
      ),
    );
  }
}
