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
        color: Color(0xff6F6E6E),
        border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),

          ),
      child: SingleChildScrollView(
        child: Column(
          children: [

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Set hours'), hours],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Set minutes'), minutes],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff6F6E6E),
                    elevation: 0,

                    side: BorderSide(width: 2)
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
                child: Text('ok',style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    hours = new NumberPicker.integer(
      selectedTextStyle: TextStyle(fontSize: 30),
      textStyle: TextStyle(),
      initialValue: currentHours,
      minValue: 1,
      step: 1,
      maxValue: 12,
      onChanged: (v) {
        setState(() {
          currentHours = v;
        });
      },
    );
    minutes = new NumberPicker.integer(
      selectedTextStyle: TextStyle(fontSize: 30),
      textStyle: TextStyle(),
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
