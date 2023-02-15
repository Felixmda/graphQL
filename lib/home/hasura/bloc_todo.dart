
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_fit_in/home/hasura/state_bloc.dart';

import 'cnx_hasura.dart';
import 'model/todo_model.dart';

class BlocTodo extends ChangeNotifier{

  List<Todo> todos = [];
  final blocLista = BehaviorSubject<StateBloc>();
  Stream<StateBloc> get outLista => blocLista.stream;
  final StreamController<dynamic> buscarListaStream = StreamController<dynamic>();
  Sink get inLista => buscarListaStream.sink;


  BlocTodo(){
    buscarListaStream.stream.listen(getTasks);
  }

   getTasks(dynamic data)async {

     if (data == null) {
       blocLista.sink.add(StatusNullable());
     } else {
       blocLista.sink.add(StatusLoading());



    try {
      final result = await CnxHasura.hasuraConnect.subscription('''
      subscription GetTodoStreamingSubscription {
  todo(order_by: {id: $data}) {
    completed
		id
		task
  }
}
    ''',
      );


      result.listen((data) {
        todos = data['data']['todo'].map<Todo>((map) {
          return Todo.fromJson(map);
        }).toList();

        blocLista.sink.add(StatusSuccess(todos));
      }).onError((err) {
        print(err);
      });




    } catch (Ex) {
      if(Ex is Exception){

      }
      }


    }

  }

  @override
  void dispose() {
  blocLista.close();
  buscarListaStream.close();

  }

@override
void addListener(VoidCallback listener) {
  // TODO: implement addListener
}

@override
// TODO: implement hasListeners
bool get hasListeners => throw UnimplementedError();

@override
void notifyListeners() {
  // TODO: implement notifyListeners
}

@override
void removeListener(VoidCallback listener) {
  // TODO: implement removeListener
}
}