import 'package:flutter/material.dart';
import 'package:timer/widgets/setting_button.dart';
import 'package:timer/widgets/timer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/serviceType.dart';

enum ServiceType { Work, Short, Long }

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting';

  @override
  _SettingScreemnState createState() => _SettingScreemnState();
}

class _SettingScreemnState extends State<SettingScreen> {
  SharedPreferences pref;
  TextEditingController _txtWork = TextEditingController();
  TextEditingController _txtShort = TextEditingController();
  TextEditingController _txtLong = TextEditingController();

  final textStyle = TextStyle(fontSize: 24);

  @override
  void initState() {
    readSettings();
    super.initState();
  }

  readSettings() async {
    pref = await SharedPreferences.getInstance();
    int workTime = pref.getInt(WORK_TIME);
    if (workTime == null) {
      await pref.setInt(WORK_TIME, int.parse('30'));
    }
    int shortTime = pref.getInt(SHORT_TIME);
    if (shortTime == null) {
      await pref.setInt(SHORT_TIME, int.parse('10'));
    }
    int longTime = pref.getInt(Long_TIME);
    if (longTime == null) {
      await pref.setInt(Long_TIME, int.parse('20'));
    }
    setState(() {
      _txtWork.text = workTime.toString();
      _txtShort.text = shortTime.toString();
      _txtLong.text = longTime.toString();
    });
  }

  updateSettings(String key, [int value]) {
    switch (key) {
      case WORK_TIME:
        int workValue = int.tryParse(_txtWork.text);
        if (value != null) workValue += value;

        if (workValue >= 1 && workValue <= 180) {
          pref.setInt(key, workValue);
          setState(() => _txtWork.text = workValue.toString());
        }
        break;
      case SHORT_TIME:
        int shortValue = int.tryParse(_txtShort.text);
        if (value != null) shortValue += value;
        if (shortValue >= 1 && shortValue <= 60) {
          pref.setInt(key, shortValue);
          setState(() => _txtShort.text = shortValue.toString());
        }
        break;
      case Long_TIME:
        int longValue = int.parse(_txtLong.text);
        if (value != null) longValue += value;
        if (longValue >= 1 && longValue <= 120) {
          pref.setInt(key, longValue);
          setState(() => _txtLong.text = longValue.toString());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SettingAction(
                serviceType: 'Work',
                controller: _txtWork,
                setting: WORK_TIME,
                onPressServiceHandler: updateSettings,
                onChanged: updateSettings,
              ),
              SettingAction(
                serviceType: 'Short Break',
                controller: _txtShort,
                setting: SHORT_TIME,
                onPressServiceHandler: updateSettings,
                onChanged: updateSettings,
              ),
              SettingAction(
                serviceType: 'Long Break',
                controller: _txtLong,
                setting: Long_TIME,
                onPressServiceHandler: updateSettings,
                onChanged: updateSettings,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingAction extends StatelessWidget {
  final String serviceType;
  final TextEditingController controller;
  final Function onPressServiceHandler;
  final Function onChanged;
  final String setting;

  const SettingAction({
    this.serviceType,
    this.controller,
    this.onPressServiceHandler,
    this.setting,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            serviceType,
            style: TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SettingButton(
                  color: Color(0xff455A64),
                  text: "-",
                  value: -1,
                  setting: setting,
                  callback: onPressServiceHandler,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  onChanged: (_) => onChanged(setting),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: SettingButton(
                  color: Color(0xff009688),
                  text: "+",
                  value: 1,
                  setting: setting,
                  callback: onPressServiceHandler,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
