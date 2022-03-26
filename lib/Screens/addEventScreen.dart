import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:nilay_dtuotg_2/widgets/eventDurationPicker.dart';
import 'package:nilay_dtuotg_2/widgets/eventOwnerPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:io';

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
  String Somerandomtext;
  bool imagePicked = false;
  bool imageCroped = false;
  @override
  void initState() {
    name.text = "";
    description.text = "";
    whatsInItForYou.text = "";
    link.text = "";
    Somerandomtext="-";
    // TODO: implement initState
    super.initState();
  }

  DateTime dateTime;
  TimeOfDay timeOfDay;


  File _image;
  final picker = ImagePicker();
  var _imageDataList = <Uint8List>[];
  Future<File> urlToFile(Uri imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  void _showPicker(BuildContext context, num ratio) {
    showModalBottomSheet(

        elevation: 0,

        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(11),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 10 * ratio, horizontal: 22 * ratio),
//
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

                      ),
                      title: new Text(
                        'Photos',
                        style: TextStyle(

                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),

                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.white,

                    ),
                    title: new Text('Camera',
                        style: TextStyle(

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
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor:Colors.white,
            toolbarWidgetColor: Color(0xff6F6E6E),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
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
      if(croppedFile!=null){
        _image=croppedFile;

      }
    });
  }

  final formGlobalKey = GlobalKey<FormState>();
  bool waiting = false;
  var resp;
  DateTime now = DateTime.now();
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    print(args);

    int type = args.id;

    double ratio = MediaQuery.of(context).size.height / 896;

    // BuildContext bc =
    //     Provider.of<TabsScreenContext>(context, listen: false).get();
    var data = Provider.of<AddEventScreenData>(context, listen: true);
    return type!=3?args.editing==true?
    /////////////////EDITINGEVENT
    Scaffold(
      backgroundColor: Color(0xff6F6E6E),



      persistentFooterButtons: [

        ElevatedButton.icon(
            style:
            ElevatedButton.styleFrom( elevation: 0),
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
                int resp = await scf.editEvent(

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
                    _image!=null?_image:urlToFile(Uri.parse(args.event.event_image)),args.event.id);


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
                Navigator.of(context).pushReplacementNamed('/loading');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Creating Event"),duration: Duration(milliseconds: 1000),));


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

            ),
            label: waiting
                ? CircularProgressIndicator()
                : Text(
              'save',

            ))
      ],
      appBar: AppBar(
        backgroundColor: Color(0xff6F6E6E),

        title: Text(type == 1
            ? 'add event 🙂'
            :type==2?'stories':
        'projects +'
          ,style: TextStyle(
              color: Colors.white
          ),),
      ),
      body: Container(



        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Somerandomtext),
               Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.add_a_photo_outlined),
                    title: Text('Replace Selected Image?'),
                    onTap: () => _showPicker(context, ratio),
                  ),
                  Container(
                    child: _image!=null ?Image.file(_image):CachedNetworkImage(imageUrl: args.event.event_image),
                    height: 400,
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,

                    side: BorderSide( width: 2)),
                child: Text(
                  'Pick A Date',

                ),
                autofocus: true,
                clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2021),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2050));
                  print('$dateTime');
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,

                    side: BorderSide( width: 2)),
                onPressed: () async {
                  timeOfDay = await showTimePicker(


                    context: context,
                    initialTime: TimeOfDay(hour: 1, minute:1),
                  );
                  print('$timeOfDay');
                },
                child: Text(
                  "startingTime?",

                ),
              ),

              // ListTile(
              //   leading: Icon(Icons.people),
              //   tile: s.blue[200],
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  elevation: 0,

                  child: TextFormField(
                    onChanged:(value){
                      Somerandomtext=value;
                    },
                    controller: name,
                    style: TextStyle( fontSize: 15),

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
                      labelText: args.event.name,
                      helperText: 'Keep it short, this is just a beta.',


                      labelStyle:
                      TextStyle( fontSize:15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  elevation: 0,

                  child: TextFormField(
                    controller: description,
                    style: TextStyle( fontSize: 15),
                    maxLines: 5,

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
                      labelText: "whats it about ?",
                      helperText: 'Whats it about?',

                      labelStyle:
                      TextStyle( fontSize: 15),
                    ),

                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  elevation: 0,

                  child: TextFormField(

                    controller: whatsInItForYou,
                    style: TextStyle( fontSize: 15),

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
                      labelText: "Incentives",
                      helperText: "What's in it for students",

                      labelStyle:
                      TextStyle( fontSize: 15),
                    ),

                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  elevation: 0,

                  child: TextFormField(
                    controller: link,
                    style: TextStyle( fontSize: 10),

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
              ),
            ],
          ),
        ),
      ),
    ):Scaffold(
      backgroundColor: Color(0xff6F6E6E),



      persistentFooterButtons: [

        ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom( elevation: 0),
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
                Navigator.of(context).pushReplacementNamed('/loading');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Creating Event"),duration: Duration(milliseconds: 1000),));


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

            ),
            label: waiting
                ? CircularProgressIndicator()
                : Text(
                    'save',

                  ))
      ],
      appBar: AppBar(
        backgroundColor: Color(0xff6F6E6E),

        title: Text(type == 1
            ? 'add event 🙂'
            :type==2?'stories':
                 'projects +'
                ,style: TextStyle(
            color: Colors.white
          ),),
      ),
      body: Container(



        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Somerandomtext),
          _image == null
              ? ListTile(
                  leading: Icon(Icons.add_a_photo),
                  title: Text('No image selected.'),
                  onTap: () => _showPicker(context, ratio),
                )
              : Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.add_a_photo_outlined),
                    title: Text('Replace Selected Image?'),
                    onTap: () => _showPicker(context, ratio),
                  ),
                  Container(
                      child: Image.file(_image),
                      height: 100,
                    ),
                ],
              ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,

                side: BorderSide( width: 2)),
            child: Text(
              'Pick A Date',

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

                side: BorderSide( width: 2)),
            onPressed: () async {
              timeOfDay = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: 1, minute: 0),
              );
              print('$timeOfDay');
            },
            child: Text(
              "startingTime?",

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
          //   tile: s.blue[200],
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
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Card(
              elevation: 0,

              child: TextFormField(
                onChanged:(value){
                  Somerandomtext=value;
                },
                controller: name,
                  style: TextStyle( fontSize: 15),

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
                      labelText: "Name of the event",
                      helperText: 'Keep it short, this is just a beta.',

                      labelStyle:
                      TextStyle( fontSize:15),
                      ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Card(
              elevation: 0,

              child: TextFormField(
                controller: description,
                  style: TextStyle( fontSize: 15),
                maxLines: 5,

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
                      labelText: "Description",
                      helperText: 'Whats it about?',

                      labelStyle:
                      TextStyle( fontSize: 15),
                     ),

              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Card(
              elevation: 0,

              child: TextFormField(

                controller: whatsInItForYou,
                  style: TextStyle( fontSize: 15),

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
                      labelText: "Incentives",
                      helperText: "What's in it for students",

                      labelStyle:
                      TextStyle( fontSize: 15),
                     ),

                  ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Card(
              elevation: 0,

              child: TextFormField(
                controller: link,
                  style: TextStyle( fontSize: 10),

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
          ),
            ],
          ),
        ),
      ),
    ):Scaffold(
      backgroundColor: Color(0xff6F6E6E),

      persistentFooterButtons: [

        ElevatedButton.icon(
            style:
            ElevatedButton.styleFrom( elevation: 0),
            onPressed: () async {

              print('1');
              setState(() {
                waiting = true;

              });
              if (
                  name != null &&
                  description != null
                  ) {
                //////////////////////////////////////////////////////////////////////
                print('2');
                var scf = Provider.of<SCF>(context, listen: false).get();
                int resp = await scf.createProject(
                    context,
                    name.text,
                    description.text +
                        '~\$' +
                        whatsInItForYou.text +
                        '\$~' +
                        link.text,


                    _image);
                scf.fetchListOfProjects(context);

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



                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Creating Project"),duration: Duration(milliseconds: 1000),));
                Navigator.of(context).pushReplacementNamed('/loading');
              }
              setState(() {
                waiting = false;
              });
            },
            icon: Icon(
              Icons.save,

            ),
            label: waiting
                ? CircularProgressIndicator()
                : Text(
              'save',

            ))
      ],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff6F6E6E),

        title: Text( '+ Projects',style: TextStyle(color: Colors.white),),
      ),
      body: Container(



        child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _image == null
                  ? ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),

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
                  primary: Color(0xff6F6E6E),
                    elevation: 0,

                    side: BorderSide( width: 2)),
                child: Text(
                  'Pick A Date',style: TextStyle(color: Colors.white),

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
                  primary: Color(0xff6F6E6E),

                    elevation: 0,

                    side: BorderSide( width: 2)),
                onPressed: () async {
                  timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 1, minute: 0),
                  );
                  print('$timeOfDay');
                },
                child: Text(
                  "startingTime?",style: TextStyle(color: Colors.white),

                ),
              ),
              Container(

                child: ListTile(
                  leading: Icon(Icons.timelapse),

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
              //   tile: s.blue[200],
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  color: Color(0xff6F6E6E),
                  elevation: 0,

                  child: TextField(

                    onChanged:(value){
                      Somerandomtext=value;
                    },
                    controller: name,
                    style: TextStyle( fontSize: 15),

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
                      labelText: "Name of the event",
                      helperText: 'Keep it short, this is just a beta.',

                      labelStyle:
                      TextStyle( fontSize: 15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  color: Color(0xff6F6E6E),

                  elevation: 0,

                  child: TextField(
                    maxLines: 5,
                    controller: description,
                    style: TextStyle( fontSize: 15),

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
                      labelText: "Description",
                      helperText: 'Whats it about?',

                      labelStyle:
                      TextStyle( fontSize: 15),
                    ),

                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  color: Color(0xff6F6E6E),
                  elevation: 0,

                  child: TextField(
                    controller: whatsInItForYou,
                    style: TextStyle( fontSize: 15),

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
                      labelText: "Incentives",
                      helperText: "What's in it for students",

                      labelStyle:
                      TextStyle( fontSize: 15),
                    ),

                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  color: Color(0xff6F6E6E),
                  elevation: 0,

                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,

                    textAlign: TextAlign.start,

                    maxLines: 5,
                    controller: link,
                    style: TextStyle( fontSize: 15,),

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
                      TextStyle( fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
