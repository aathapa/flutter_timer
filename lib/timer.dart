import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/helpers/serviceType.dart';

import './models/timer_model.dart';

class CountTimer {
  double _radius = 1;
  bool _isActive = false;
  Timer timer;
  Duration _time;
  Duration _fullTime;
  int work;
  int shortBreak;
  int longBreak;

  bool get isActive => _isActive;

  String returnTime(Duration t) {
    String minutes =
        t.inMinutes < 10 ? '0${t.inMinutes}' : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = numSeconds < 10 ? '0$numSeconds' : numSeconds.toString();

    return '$minutes:$seconds';
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      if (_isActive) {
        _time = _time - Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      String time;
      time = returnTime(_time);
      return TimerModel(time: time, percent: _radius);
    });
  }

  void startTime() async {
    readSettings();
    _time = Duration(minutes: work, seconds: 0);
    _radius = 1;
    _fullTime = _time;
    _isActive = true;
  }

  Future readSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    work = pref.getInt(WORK_TIME) == null ? 30 : pref.getInt(WORK_TIME);
    shortBreak = pref.getInt(SHORT_TIME) == null ? 5 : pref.getInt(SHORT_TIME);
    longBreak = pref.getInt(Long_TIME) == null ? 20 : pref.getInt(Long_TIME);
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: isShort ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }

  void stopTimer() {
    _isActive = false;
  }
}
