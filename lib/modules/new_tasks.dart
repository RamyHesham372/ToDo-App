import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/todo_cubit.dart';
import 'package:todo/shared/cubit/todo_states.dart';

import '../shared/components.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var task = ToDoCubit.get(context).newTasks;

        return whenTasksEmpty(task: task);
      },
    );
  }
}
