
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_fit_in/home/hasura/cnx_hasura.dart';
import 'package:to_fit_in/home/hasura/state_bloc.dart';

import 'bloc_todo.dart';
import 'model/todo_model.dart';
import 'todo_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {


  @override
  void initState() {
    super.initState();
    getList();

  }

  getList({String? order}){
    BlocProvider.getBloc<BlocTodo>().inLista.add(order ?? 'asc');
  }



  MaskedTextController _task = MaskedTextController( text: '', mask: '****************************************');

  Widget iconDelete (Todo item){
    return IconButton(
        onPressed: (){
          removeTask(item.id!);
    }, icon: Icon(Icons.delete, color:Colors.red,));
  }

  Widget checkTask (Todo item){
    return Checkbox(
        onChanged: (v){
         item.completed = v!;
       modifyTask(item);
    },
      value: item.completed,);
  }
  //
  //  void getTasks(dynamic data)async{
  //   // todos.clear();
  //   try {
  //     final result = await CnxHasura.hasuraConnect.query(
  //       """
  // query {
  //   todo {
  //     id
  //     task
  //     completed
  //   }
  // }
  // """,
  //     );
  //
  //     // if (result.hasException) {
  //     //   // handle error
  //     // } else {
  //     todos.addAll(
  //         result['data']['todo'].map<Todo>((map) {
  //           return Todo.fromJson(map);
  //         }).toList()
  //     );
  //
  //     blocLista.sink.add(todos);
  //
  //     // use todos to populate your to-do list
  //   // }
  //     // add newTask to your to-do list
  //     // }
  //   }catch(Ex){
  //
  //   }finally{
  //     setState(() {
  //     });
  //   }
  //
  // }

  Future<dynamic> addTask(String task)async{
try{
  //get query
  var r = await CnxHasura.hasuraConnect.mutation( """
  mutation(\$task: String!) {
    insert_todo(objects: {task: \$task, completed: false}) {
      returning {
        id
        task
        completed
      }
    }
  }
  """,
    variables: {
      "task": "$task",
    },);

  // if (r.hasException) {
  //   // handle error
  // } else {
  var item = r['data']['insert_todo']['returning'][0];
    final Todo newTask = Todo.fromJson(item);

    return newTask;
    // add newTask to your to-do list
  // }
}catch(Ex){

  return -1;
}finally{

}

  }

  Future<dynamic> removeTask(int idTask)async{
    try {
      final result = await CnxHasura.hasuraConnect.mutation(
        """
  mutation(\$id: Int!) {
    delete_todo(where: {id: {_eq: \$id}}) {
      affected_rows
    }
  }
  """,
        variables: {
          "id":idTask
        },
      );

       if (result['data']['delete_todo']['affected_rows']) {

       }
    }catch(Ex){

    }finally{
     // // await getTasks();
     //  setState(() {
     //  });
    }
  }

  Future<dynamic> modifyTask(Todo item)async{
    try {
      final result = await CnxHasura.hasuraConnect.mutation(
      """
  mutation(\$id: Int!, \$completed: Boolean!) {
    update_todo(where: {id: {_eq: \$id}}, _set: {completed: \$completed}) {
        affected_rows
    }
  }
  """,
      variables: {
      "id": item.id,
      "completed": item.completed,
      },
      );

      // if (result.hasException) {
      //   // handle error
      // } else {
      var r  = result['data']['update_todo']['affected_rows'];
      //   // update your to-do list with the updated task
      // }




    }catch(Ex){

    }finally{
      // await getTasks();
      // setState(() {
      // });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
      ),
      body: Container(
        color: Colors.grey[400],
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              child: TextFormField(
                controller: _task,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Informe a task',
                    suffix: IconButton(
                      onPressed: ()async{

                        if(_task.text.trim().isNotEmpty){
                         var r = await addTask(_task.text);
                         if(r is Todo ){
                           // todos.add(r);
                          _task.text= '';
                          setState(() {
                          });
                         }
                        }
                      },
                      icon: Icon(Icons.add),
                    )
                ),
              ),
            ),
            IconButton(onPressed: (){
              getList(order: 'asc');
            }, icon: Icon(Icons.reorder_outlined)),
            Expanded(
              child:
              // child: todos.length == 0 ?
              // Center(
              //   child: Text('Nenhuma Task'),
              // ) :
              StreamBuilder<StateBloc>(
                stream: BlocProvider.getBloc<BlocTodo>().outLista,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData  || snapshot.data is StatusLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var data = (snapshot.data as StatusSuccess)
                      .data as List<Todo>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {

                      return TodoTile(item: data[index] ,checkTask: checkTask(data[index]),iconDelete: iconDelete(data[index]),   );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }



}
