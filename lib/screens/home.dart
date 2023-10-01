import 'package:flutter/material.dart';
import 'package:steps_counter1/domain/workout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(title: Text('Steps Counter'), leading: Icon(Icons.fitness_center_outlined),),
        body: WorkoutsList(),
    ),
    );
  }
}

class WorkoutsList extends StatelessWidget {

  final workouts = <Workout>[
    Workout(title: 'Test1', author: 'Max1',description: 'Test Workout1', level: 'A'),
    Workout(title: 'Test2', author: 'Max2',description: 'Test Workout1', level: 'B'),
    Workout(title: 'Test3', author: 'Max3',description: 'Test Workout1', level: 'C'),
    Workout(title: 'Test4', author: 'Max4',description: 'Test Workout1', level: 'D'),
    Workout(title: 'Test5', author: 'Max5',description: 'Test Workout1', level: 'E'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, i){
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:  Container(
                decoration: BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  // ignore: prefer_const_constructors
                  title: Text(workouts[i].title, style: TextStyle(color: Color.fromRGBO(238, 239, 240, 0.898)))
                ),
              ),
            );
          }
          ),
      ),
    );
  }
}