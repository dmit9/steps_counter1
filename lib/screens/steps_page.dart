import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String _status = '?', _steps = '?';
  late var todaySteps = 0;
  late int savedStepsCount = 0;
  late int lastDaySaved = 0;
  int savedTtodaySteps = 1;
  int todayDayNo = Jiffy.now().dayOfYear;
  final String _click = 'db';
  late int data = 77;

  late String? userEmail = FirebaseAuth.instance.currentUser!.email;
  
  final Stream<QuerySnapshot> dbsSnapshots = FirebaseFirestore.instance.collection('users').snapshots();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String name = 'todaySteps';
  int value = 999; 

  dbReadsavedTtodaySteps() {
    db.collection("users").doc(userEmail).get().then((value) {
      int text1 = value.get("savedTtodaySteps");
      savedTtodaySteps = text1;
 //     print(savedStepsCount);
      return savedTtodaySteps;
    });  
  }
  dbReadsavedStepsCount() {
    db.collection("users").doc(userEmail).get().then((value) {
      int text1 = value.get("savedStepsCount");
      savedStepsCount = text1;
 //     print(savedStepsCount);
      return savedStepsCount;
    });  
  }
  dbReadtodaySteps() {
    db.collection("users").doc(userEmail).get().then((value) {
      int text1 = value.get("todaySteps");
      todaySteps = text1;
 //     print(savedStepsCount);
      return todaySteps;
    });  
  }
  dbReadlastDaySaved() {
    db.collection("users").doc(userEmail).get().then((value) {
      int text1 = value.get("lastDaySaved");
      lastDaySaved = text1;
 //     print(savedStepsCount);
      return lastDaySaved;
    });  
  }

  void dbAdd(name, val) async{
    await  db.collection("users").doc("$userEmail").set({name:val}, SetOptions(merge: true));
  }

   Future<void> signOut() async {
    await Auth().signOut();
  }

    Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'),);
  }
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
    dbReadtodaySteps();
    dbReadsavedStepsCount();
    dbReadsavedTtodaySteps();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();   // кол-во шагов общее
      getTodaySteps(event.steps);
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
    
    dbReadsavedStepsCount();

    int todayDayNo = Jiffy.now().dayOfYear;

    if (value < savedStepsCount) {
      savedStepsCount = 0;
      dbAdd('savedStepsCount', savedStepsCount);
    }

    dbReadlastDaySaved();

    if (lastDaySaved< todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      dbAdd('savedStepsCount', savedStepsCount);
      dbAdd('lastDaySaved', lastDaySaved);
    }

    todaySteps = value - savedStepsCount;
    
    if (savedTtodaySteps < todaySteps){
      savedTtodaySteps = todaySteps;
    }
    else if (savedTtodaySteps > todaySteps) {
      todaySteps = todaySteps + savedTtodaySteps;
    }
  
  
    dbAdd('todayDayNo', todayDayNo);
    dbAdd('todaySteps', todaySteps);
    dbAdd('savedTtodaySteps', savedTtodaySteps);
    return todaySteps; // this is your daily steps value.
  }  


  @override 
  Widget build(BuildContext context) {
    
   // dbRead();
    dbAdd('todayDayNo', todayDayNo);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Steps Count'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          //    _dbAddButton(),
        //      _dbReadButton(),
    //          SizedBox(height: 20,),
                Text(
                 'Login as $userEmail',
                 style: const TextStyle(fontSize: 20),
                 ),
                _signOutButton(),
                SizedBox(height: 20,),
              // Container(
              //    height: 100,
              //    padding: const EdgeInsets.all(5),
              //   child: StreamBuilder<QuerySnapshot>(
              //     stream: dbsSnapshots, 
              //     builder:(
              //       BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot,
              //     ) { 
              //       if (snapshot.hasError) {
              //         return const Text('Something went wrong...');
              //       }
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Text('Loading');
              //       }
              //       final data = snapshot.requireData;
              //       return ListView.builder(
              //         itemCount: data.size,
              //         itemBuilder: (context, index) {
              //           return Text(
              //             '$userEmail ${data.docs[index]['todaySteps']} '
              //           );
              //         },
              //       );
              //     },
              //     ),
              // ),
              // const Text(
              //   'Steps Taken',
              //   style: TextStyle(fontSize: 20),
              // ),
              // Text(
              //   _steps,
              //   style: const TextStyle(fontSize: 20),
              // ),
              const Text(
                'Tuday Steps',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                todaySteps.toString() ?? '0',
                style: const TextStyle(fontSize: 50),
              ),
              // const Text(
              //   'Tuday Now , Last Day',
              //   style: TextStyle(fontSize: 20),
              // ),
              // Text(
              //   todayDayNo.toString() ?? '0',
              //   style: const TextStyle(fontSize: 20),
              // ),Text(
              //   lastDaySaved.toString() ?? '0',
              //   style: const TextStyle(fontSize: 20),
              // ),

              const Divider(
                height: 20,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 20),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 50,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? const TextStyle(fontSize: 30)
                      : const TextStyle(fontSize: 30, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}