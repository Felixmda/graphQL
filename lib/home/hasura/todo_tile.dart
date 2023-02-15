

import 'package:flutter/material.dart';

import 'model/todo_model.dart';

class TodoTile extends StatelessWidget {
  Todo item;
  Widget iconDelete;
  Widget checkTask;
   TodoTile({required this.item , required this.checkTask, required this.iconDelete,  Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:checkTask,
        title: Text('${item.task}', style: TextStyle( decoration: item.completed ? TextDecoration.lineThrough : null,),),
        subtitle: Text('nº: ${item.id}'),
        trailing: iconDelete,

      ),
    );
  }
}
