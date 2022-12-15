// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/todo_states.dart';

import '../../modules/archived_tasks.dart';
import '../../modules/done_tasks.dart';
import '../../modules/new_tasks.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(InitialState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  late Database database;

  List<Map> newTasks = [];

  List<Map> doneTasks = [];

  List<Map> archivedTasks = [];

  List<Widget> screens = const [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  bool bottomSheetOpened = false;

  IconData fabIcon = Icons.edit;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeBottomSheet({
    required bool isShow,
    required IconData myIcon,
  }) {
    bottomSheetOpened = isShow;
    fabIcon = myIcon;
    emit(ChangeBottomSheetState());
  }

  createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (Database database, int version) {
      print('db created');
      database
          .execute(
              'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (Database database) {
      getFromDatabase(database);
      print('db opened');
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) {
    return database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(InsertToDataBaseState());

        getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting to database $error');
      });
    });
  }

  getFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetFromDataBaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedTasks.add(element);
        } else {
          newTasks.add(element);
        }
      }

      emit(GetFromDataBaseState());
    });
  }

  updateDataBase({
    required String status,
    required int id,
  }) {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getFromDatabase(database);
      emit(UpdateDataBaseState());
    });
  }

  deleteFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeleteDataBaseState());
    });
  }
}