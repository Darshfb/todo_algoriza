import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo_algoriza/features/cubit/todo_cubit.dart';

enum Menu { completed, favorite, delete }

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key? key}) : super(key: key);
  DateTime _selectedValue = DateTime.now();

  //Text(DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()).toString()),
  @override
  Widget build(BuildContext context) {
    context
        .read<TodoCubit>()
        .changeDate(DateFormat('yyyy-MM-dd').format(_selectedValue));
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = TodoCubit.get(context);
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
            title: const Text('Schedule',
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700)),
            toolbarHeight: 90.0,
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                child: Card(
                  child: DatePicker(
                    DateTime.now(),
                    dateTextStyle:
                        TextStyle(color: Colors.black.withOpacity(.8)),
                    dayTextStyle:
                        TextStyle(color: Colors.black.withOpacity(.8)),
                    monthTextStyle:
                        TextStyle(color: Colors.black.withOpacity(.8)),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.green,
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      // New date selected
                      _selectedValue = date;
                      cubit.changeDate(DateFormat('yyyy-MM-dd').format(date));
                      // print(DateFormat('yyyy-MM-dd').format(date));
                      // print('........... $date');
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('EEEE').format(DateTime.now()).toString()),
                    Text(DateFormat.yMMMd().format(DateTime.now()).toString()),
                  ],
                ),
              ),
              ConditionalBuilder(
                condition: cubit.listByDate.isNotEmpty,
                fallback: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: SvgPicture.asset('images/blank.svg',
                            width: 150.0, height: 200.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No Task on this day, you can add more!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                        ),
                      )
                    ],
                  );
                },
                builder: (context) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: cubit.listByDate.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        var item = cubit.listByDate[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        item['start'],
                                        style: TextStyle(
                                            color:
                                            (item['status'] == 'completed')
                                                ? Colors.grey
                                                : Colors.white,
                                            decoration:
                                            (item['status'] == 'completed')
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        item['title'],
                                        style: TextStyle(
                                            color:
                                            (item['status'] == 'completed')
                                                ? Colors.grey
                                                : Colors.white,
                                            decoration:
                                            (item['status'] == 'completed')
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 50, right: 10),
                                  child: PopupMenuButton<Menu>(
                                      color: Colors.red,
                                      child: Icon(Icons.more_horiz,
                                          color: (item['status'] == 'completed')
                                              ? Colors.grey
                                              : Colors.white),
                                      onSelected: (Menu item) {
                                        if (item.name == 'delete') {
                                          cubit.deleteFromDatabase(
                                              id: cubit.listByDate[index]['id']);
                                        } else if (item.name == 'completed') {
                                          cubit.updateDatabaseCompleted(
                                              id: cubit.listByDate[index]['id'],
                                              status: (cubit.listByDate[index]
                                              ['status'] ==
                                                  "uncompleted")
                                                  ? "completed"
                                                  : "uncompleted");
                                        } else if (item.name == 'favorite') {
                                          cubit.updateDatabaseFav(
                                              id: cubit.listByDate[index]['id'],
                                              favorite: (cubit.listByDate[index]
                                              ['favorite'] ==
                                                  "true")
                                                  ? "false"
                                                  : "true");
                                        }
                                        print(item.name);
                                      },
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<Menu>>[
                                        PopupMenuItem<Menu>(
                                          value: Menu.completed,
                                          child: Text((cubit.listByDate[index]
                                          ['status'] ==
                                              "uncompleted")
                                              ? "completed"
                                              : "uncompleted", style: const TextStyle(color: Colors.white)),
                                        ),
                                        const PopupMenuItem<Menu>(
                                          value: Menu.favorite,
                                          child: Text('Favorite', style: TextStyle(color: Colors.white),),
                                        ),
                                        const PopupMenuItem<Menu>(
                                          value: Menu.delete,
                                          child: Text('Delete', style: TextStyle(color: Colors.white)),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
