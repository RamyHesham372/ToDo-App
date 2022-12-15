// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../shared/components.dart';

var formKey = GlobalKey<FormState>();
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();

buildBottomSheet(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle, color: Colors.white),
              const SizedBox(height: 10),
              // I'm using my reusable TextFormField
              defaultTextFormField(
                  myboardType: TextInputType.text,
                  controllerType: titleController,
                  myValidator: (valve) {
                    if (valve!.isEmpty) {
                      return 'title must not be empty';
                    }
                    return null;
                  },
                  labelText: 'Title',
                  myBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefix: Icons.title),
              const SizedBox(height: 10),
              // I'm using my reusable TextFormField
              defaultTextFormField(
                  myboardType: TextInputType.datetime,
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        timeController.text = value.format(context);
                      } else {
                        return null;
                      }
                    }).catchError((error) {
                      print('error when getting the time ${error.toString()}');
                    });
                  },
                  controllerType: timeController,
                  myValidator: (valve) {
                    if (valve!.isEmpty) {
                      return 'Time must not be empty';
                    }
                    return null;
                  },
                  labelText: 'Time',
                  myBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefix: Icons.access_time_outlined),
              const SizedBox(height: 10),
              defaultTextFormField(
                  myboardType: TextInputType.datetime,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024, 1),
                    ).then((value) {
                      if (value != null) {
                        dateController.text = value.toString().split(' ').first;
                      } else {
                        return null;
                      }
                    }).catchError((error) {
                      print('error when getting the time ${error.toString()}');
                    });
                  },
                  controllerType: dateController,
                  myValidator: (valve) {
                    if (valve!.isEmpty) {
                      return 'Date must not be empty';
                    }
                    return null;
                  },
                  labelText: 'Date',
                  myBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefix: Icons.date_range),
            ],
          ),
        ),
      ),
    );