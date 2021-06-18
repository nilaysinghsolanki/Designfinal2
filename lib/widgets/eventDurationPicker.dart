import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class DurationPicker extends StatefulWidget {
  DurationPicker({Key key}) : super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  NumberPicker hours;
  int currentHours = 1;
  NumberPicker minutes;
  int currentMinutes = 0;
  @override
  Widget build(BuildContext context) {
    _initializeNumberPickers();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("Assets/newframe.png"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('${currentHours}h ${currentMinutes}min'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Set Hour'), hours],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Set minutes'), minutes],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.white,
                    side: BorderSide(color: Colors.brown,width: 2)
                ),
                onPressed: () {
                  Provider.of<AddEventScreenData>(context, listen: false)
                      .setMinutes(currentMinutes);
                  print(
                      '${Provider.of<AddEventScreenData>(context, listen: false).getMinutes()}');
                  Provider.of<AddEventScreenData>(context, listen: false)
                      .setHours(currentHours);
                  print('set hours called');

                  Navigator.of(context).pop();
                },
                child: Text('ok',style: TextStyle(color: Colors.brown),))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    hours = new NumberPicker.integer(
      selectedTextStyle: TextStyle(color: Colors.green,fontSize: 30),
      textStyle: TextStyle(color: Colors.brown),
      initialValue: currentHours,
      minValue: 1,
      step: 1,
      maxValue: 240,
      onChanged: (v) {
        setState(() {
          currentHours = v;
        });
      },
    );
    minutes = new NumberPicker.integer(
      selectedTextStyle: TextStyle(color: Colors.green,fontSize: 30),
      textStyle: TextStyle(color: Colors.brown),
      initialValue: currentMinutes,
      minValue: 0,
      step: 1,
      maxValue: 59,
      onChanged: (v) {
        setState(() {
          currentMinutes = v;
        });
      },
    );
  }
}
