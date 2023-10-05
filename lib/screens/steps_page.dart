import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:steps_counter1/auth.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}


class StepsCount extends StatefulWidget {
  const StepsCount({super.key});

  @override
  _StepsCountState createState() => _StepsCountState();
}

class _StepsCountState extends State<StepsCount> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
 // FirebaseFirestore db = FirebaseFirestore.instance;
  String _status = '?', _steps = '?';
  late int todaySteps = 0;
  late int savedStepsCount = 0;
  late int lastDaySaved = 0;
  int todayDayNo = 0;
  final String _click = 'db';
  int _i = 0;
  
  final Stream<QuerySnapshot> UserSteps = FirebaseFirestore.instance.collection('use').snapshots();
  

   Future<void> signOut() async {
    await Auth().signOut();
  }

    Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'),);
  }

  // void dbRead() async {
  //   await db.collection("use").get().then((event) {
  //     for (var doc in event.docs) {
  //       print("${doc.id} => ${doc.data()}");
  //     }
  //   });
  // }

  // final user = <String, dynamic>{
  //  "email": "ddd@ddd.com",
  //   "todayStep": 50,
  //  "savedStepsCount": 40,
  //  "lastDaySaved": 30,
  //  "todayDayNo": 20,
  // };

  // void dbAdd() async{
  //   _i= _i+1;
  //   await db.collection("use").add(user).then((DocumentReference doc) =>
  //   print('DocumentSnapshot added with ID: ${doc.id}'));
  // }
  

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

    int todayDayNo = Jiffy.now().dayOfYear;
    if (value < savedStepsCount) {

      savedStepsCount = 0;
      setState(() {
        savedStepsCount;
      });
    }

    if (lastDaySaved< todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      setState(() {
        lastDaySaved;
        savedStepsCount;
      }); 
    }

    setState(() {
      todaySteps = value - savedStepsCount;
    });
    return todaySteps; // this is your daily steps value.
  }  


  @override 
  Widget build(BuildContext context) {

  //  Widget _DbButton() {
  //   return TextButton(
  //     onPressed: () {
  //     dbRead;
  //     dbAdd;
  //   }, child: Text('DB $_i' ),
  //   );
  // }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Steps Count'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
    //          _DbButton(),
    //          SizedBox(height: 20,),
              _signOutButton(),
              Container(
                 height: 100,
                 padding: const EdgeInsets.all(5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: UserSteps, 
                  builder:(
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) { 
                    if (snapshot.hasError) {
                      return const Text('Something went wrong...');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading');
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Text(
                          'Data 1 ${data.docs[index]['1']} Data 2 ${data.docs[index]['2']}'
                        );
                      },
                    );
                  },
                  ),
              ),
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                _steps,
                style: const TextStyle(fontSize: 20),
              ),
              const Text(
                'Tuday Steps',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                todaySteps.toString() ?? '0',
                style: const TextStyle(fontSize: 20),
              ),
              const Text(
                'Tuday Now , Last Day',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                todayDayNo.toString() ?? '0',
                style: const TextStyle(fontSize: 20),
              ),Text(
                lastDaySaved.toString() ?? '0',
                style: const TextStyle(fontSize: 20),
              ),
              // TextButton(
              //   onPressed: () {
              //     _click = 'clicked';
              //     db.collection("UserSteps").add(user);
              //  }, child: Text('DB,  $_click' ),
              // ),
              const Divider(
                height: 10,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 10),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 30,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? const TextStyle(fontSize: 20)
                      : const TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}