import 'package:flutter/material.dart';
import 'package:timer/models/timer_model.dart';
import 'package:timer/screens/setting_screen.dart';
import 'package:timer/timer.dart';
import 'package:timer/widgets/timer_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

enum ToScreen { Settings }
enum TimerState { Stop, Start }

final CountTimer timer = CountTimer();

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerState timerState = TimerState.Stop;

  void _onPressStartStop() {
    TimerState newTimerState;
    if (timer.isActive) {
      timer.stopTimer();
      newTimerState = TimerState.Stop;
    } else {
      timer.startTimer();
      newTimerState = TimerState.Start;
    }
    setState(() => timerState = newTimerState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (ToScreen value) {
              if (value == ToScreen.Settings) {
                Navigator.of(context).pushNamed(SettingScreen.routeName);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Settings'),
                value: ToScreen.Settings,
              )
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final availableWidth = constraints.maxWidth;
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                    child: TimerButton(
                      color: Color(0xff009688),
                      text: 'Work',
                      onPressed: () => timer.startTime(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                    child: TimerButton(
                      color: Color(0xff607D8B),
                      text: 'Short Break',
                      onPressed: () => timer.startBreak(true),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                    child: TimerButton(
                      color: Color(0xff455A64),
                      text: 'Long Break',
                      onPressed: () => timer.startBreak(false),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  initialData: '00:00',
                  stream: timer.stream(),
                  builder: (_, snapshot) {
                    TimerModel timer = snapshot.data == '00:00'
                        ? TimerModel(time: '00:00', percent: 1)
                        : snapshot.data;
                    return CircularPercentIndicator(
                      radius: availableWidth / 2,
                      lineWidth: 10.0,
                      percent: timer.percent,
                      center: Text(
                        timer.time,
                        style: Theme.of(context).textTheme.headline,
                      ),
                      progressColor: Color(0xff009688),
                    );
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                color: timer.isActive ? Color(0xff212121) : Color(0xff009688),
                width: 300,
                child: TimerButton(
                  text: timer.isActive ? 'Stop' : 'Start',
                  onPressed: _onPressStartStop,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
