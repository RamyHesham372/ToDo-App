import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/todo_cubit.dart';

defaultButton({
  required Function() function,
  Color background = Colors.blue,
  double elevation = 8,
  double paddingHorizontal = 100.0,
  double paddingVertical = 15.0,
  double radius = 30.0,
  required String text,
}) =>
    MaterialButton(
      onPressed: function,
      color: background,
      elevation: elevation,
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

defaultTextFormField({
  required TextInputType myboardType,
  required TextEditingController controllerType,
  required String? Function(String?)? myValidator,
  required String labelText,
  required IconData prefix,
  IconData? suffix,
  bool isPassShow = false,
  Function()? suffixPressed,
  Function()? onTap,
  OutlineInputBorder myBorder = const OutlineInputBorder(),
}) =>
    TextFormField(
      keyboardType: myboardType,
      controller: controllerType,
      obscureText: isPassShow,
      onTap: onTap,
      validator: myValidator,
      decoration: InputDecoration(
        labelText: labelText,
        border: myBorder,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(icon: Icon(suffix), onPressed: suffixPressed),
      ),
    );

buildTaskItem(Map task, context) => Dismissible(
      key: Key(task['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListTile(
          leading: IconButton(
              onPressed: () {
                ToDoCubit.get(context)
                    .updateDataBase(status: 'done', id: task['id']);
              },
              icon: const Icon(Icons.check_box_outline_blank)),
          title: Text(
            '${task['title']}',
            maxLines: 2,
          ),
          trailing: IconButton(
              onPressed: () {
                ToDoCubit.get(context)
                    .updateDataBase(status: 'archived', id: task['id']);
              },
              icon: const Icon(Icons.archive_outlined)),
        ),
      ),
      onDismissed: (direction) {
        ToDoCubit.get(context).deleteFromDatabase(id: task['id']);
      },
    );

whenTasksEmpty({required List<Map> task}) => ConditionalBuilder(
      condition: task.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(task[index], context),
          separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(horizontal: 15)),
          itemCount: task.length),
      fallback: (context) => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu, size: 50, color: Colors.grey),
              Text('add some tasks', style: TextStyle(color: Colors.grey))
            ]),
      ),
    );