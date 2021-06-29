import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '';

class TestingScreen extends StatefulWidget {
  static const routeName = '/TestingScreen';
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  File image;
  bool initialized = false;
  AssetImage _assetImage = AssetImage('Assets/newframe.png');

  @override
  void didChangeDependencies() async {
    if (!initialized) {
      getImageFileFromAssets('Assets/newframe.png');
      setState(() {
        initialized = true;
      });
    }
    super.didChangeDependencies();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : Container(
              child: Column(
                children: [
                  Container(
                    height: 222,
                    width: 222,
                    child: Image.asset('Assets/newframe.png'),
                  )
                ],
              ),
            ),
    );
  }
}
