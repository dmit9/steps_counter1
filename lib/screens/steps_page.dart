import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}


class StepsCount extends StatefulWidget {
  @override
  _StepsCountState createState() => _StepsCountState();
}

class _StepsCountState extends State<StepsCount> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  late int todaySteps = 0;
  late int savedStepsCount = 0;
  late int lastDaySaved = 0;
  int todayDayNo = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();   // кол-во шагов общее
      getTodaySteps(event.steps);
      print(_steps);
 //     todaySteps = _steps as int;    
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  Future<int> getTodaySteps(int value) async {
    print(value);
    //int savedStepsCountKey = 999999;
   // int? savedStepsCount = stepsBox.get(savedStepsCountKey, defaultValue: 0);

    int todayDayNo = Jiffy.now().dayOfYear;
    if (value < savedStepsCount!) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      // persist this value using a package of your choice here
      //stepsBox.put(savedStepsCountKey, savedStepsCount);
      setState(() {
        savedStepsCount;
      });
    }
  // load the last day saved using a package of your choice here
    //int lastDaySavedKey = 888888;
    //int? lastDaySaved = stepsBox.get(lastDaySavedKey, defaultValue: 0);   

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.
    if (lastDaySaved! < todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      // stepsBox
      //   ..put(lastDaySavedKey, lastDaySaved)
      //   ..put(savedStepsCountKey, savedStepsCount);
      setState(() {
        lastDaySaved;
        savedStepsCount;
      }); 
    }

    setState(() {
      todaySteps = value - savedStepsCount!;
    });
   // stepsBox.put(todayDayNo, todaySteps);// _steps as int);     //todaySteps);
    return todaySteps; // this is your daily steps value.
  }  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 40),
              ),
              Text(
                'Tuday Steps',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                todaySteps?.toString() ?? '0',
                style: TextStyle(fontSize: 40),
              ),
              Text(
                'Tuday Now , Last Day',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                todayDayNo?.toString() ?? '0',
                style: TextStyle(fontSize: 40),
              ),Text(
                lastDaySaved?.toString() ?? '0',
                style: TextStyle(fontSize: 40),
              ),
              Divider(
                height: 50,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 60,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}