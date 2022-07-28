import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_algoriza/features/cubit/todo_cubit.dart';
import 'package:todo_algoriza/features/home/home_screen.dart';
import 'package:todo_algoriza/shared/component/component.dart';
import 'package:todo_algoriza/shared/component/custom_button.dart';
import 'package:todo_algoriza/shared/component/custom_drop_down_form_field.dart';
import 'package:todo_algoriza/shared/component/text_form_field.dart';

class AddTask extends StatelessWidget {
  AddTask({Key? key}) : super(key: key);
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final remindController = TextEditingController();
  final repeatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  final List<String> reminderList = [
    '10',
    '30',
    '1 hour before',
    '1 day before'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text('Add task',
            style: TextStyle(color: Colors.black, fontSize: 16.0)),
        actions: [
          BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubit = TodoCubit.get(context);
              return TextButton(
                  onPressed: () {
                    cubit.showNotificationInTime(0);
                    // await NotificationApi.showNotification(
                    //   title : 'Mostafa',
                    //   body : 'Here her a message',
                    //   payload: 'mostafa.abs',
                    //   id: 0
                    // );
                    //   navigateTo(context: context, widget: NotificationApp());
                  },
                  child: const Text(
                    'show notification',
                    style: TextStyle(color: Colors.black),
                  ));
            },
          )
        ],
        toolbarHeight: 90.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title must\'t be empty';
                          }
                          return null;
                        },
                        hintText: 'Design team meeting',
                      ),
                    ),
                    const Text(
                      'Deadline',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFormField(
                        hintText: '28-02-2022',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Data mustn\'t be empty';
                          } else {
                            return null;
                          }
                        },
                        controller: dateController,
                        suffixIcon: Icons.keyboard_arrow_down,
                        suffixPressed: () {},
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2500),
                          ).then((value) {
                            dateController.text =
                                DateFormat('yyyy-MM-dd').format(value!);
                            selectedDate = value;
                          }).catchError((error) {
                            if (kDebugMode) {
                              print(error.toString());
                            }
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CustomTextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Start Time';
                                  }
                                  return null;
                                },
                                hintText: '11:00 Am',
                                controller: startController,
                                suffixIcon: Icons.watch_later_outlined,
                                suffixPressed: () {},
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    startController.text =
                                        value!.format(context);
                                    selectedTime = value;
                                    if (kDebugMode) {
                                      print(value.format(context).toString());
                                    }
                                  }).catchError((error) {
                                    startController.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'End Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CustomTextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'End Time';
                                  }
                                  return null;
                                },
                                hintText: '14:00 pm',
                                controller: endController,
                                suffixIcon: Icons.watch_later_outlined,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    endController.text = value!.format(context);
                                    if (kDebugMode) {
                                      print(value.format(context).toString());
                                    }
                                  }).catchError((error) {
                                    endController.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      'Remind',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: DropDownButtonFormField(
                        hintText: '10 minutes early',
                        validateText: 'Please select reminder',
                        list: reminderList,
                        onChanged: (value) {
                          if (kDebugMode) {
                            print(value);
                          }
                          remindController.text = value;
                        },
                      ),
                    ),
                    const Text(
                      'Repeat',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: DropDownButtonFormField(
                        hintText: 'Weekly',
                        validateText: 'Please select repeat',
                        list: repeatList,
                        onChanged: (value) {
                          print(value);
                          repeatController.text = value;
                        },
                      ),
                    ),
                  ],
                ),
                BlocConsumer<TodoCubit, TodoState>(
                  listener: (context, state) {
                    if (state is SuccessInsertToDatabase) {
                      navigateTo(context: context, widget: HomeScreen());
                    }
                  },
                  builder: (context, state) {
                    var cubit = TodoCubit.get(context);
                    return CustomButton(
                      text: 'Create a task',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedDate != null && selectedTime != null) {
                            cubit.scheduleNotification(
                                date: selectedDate!,
                                time: selectedTime!,
                                title: titleController.text,
                                body: startController.text,
                            );
                          }
                          cubit.insertToDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              start: startController.text,
                              end: endController.text,
                              remind: remindController.text,
                              repeat: repeatController.text,
                              status: 'uncompleted',
                              favorite: 'false');

                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
