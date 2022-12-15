// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/todo_cubit.dart';
import 'package:todo/shared/cubit/todo_states.dart';

import '../modules/bottom_sheet.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit()..createDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (context, state) {},
        builder: (context, state) {

          ToDoCubit myCubit = ToDoCubit.get(context);

          return Scaffold(
            key: myCubit.scaffoldKey,
            appBar: AppBar(
              title: const Text('Todo App'),
            ),
            body: ConditionalBuilder(
              condition: state is! GetFromDataBaseLoadingState,
              builder: (context) => myCubit.screens[myCubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: myCubit.currentIndex,
              onTap: (index) {
                myCubit.changeBottomNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                    tooltip: 'Do It Now'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt),
                    label: 'Done',
                    tooltip: 'Good Job'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                    tooltip: 'Check It'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (myCubit.bottomSheetOpened) {
                    if (formKey.currentState!.validate()) {
                      myCubit.changeBottomSheet(
                          isShow: false, myIcon: Icons.edit);
                      myCubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                      ).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    myCubit.scaffoldKey.currentState
                        ?.showBottomSheet(
                            (context) => buildBottomSheet(context))
                        .closed
                        .then((value) {
                      myCubit.changeBottomSheet(
                          isShow: false, myIcon: Icons.edit);
                    }).catchError((error) {
                      print('error when drag bottom down${error.toString()}');
                    });
                    myCubit.changeBottomSheet(isShow: true, myIcon: Icons.add);
                  }
                },
                child: Icon(myCubit.fabIcon)),
          );
        },
      ),
    );
  }
}