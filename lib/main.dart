import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:to_fit_in/home/hasura/home_view.dart';

import 'home/hasura/bloc_todo.dart';
import 'home/home_view2.dart';
import 'video_play.dart';


void main() {
  runApp(
      BlocProvider(
      blocs: [
        Bloc((i) => BlocTodo()),
      ],
      dependencies: [],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To FitIN',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home:  VideoPlay(),
    );
  }
}


