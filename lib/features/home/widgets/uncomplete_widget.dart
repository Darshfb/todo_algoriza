import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algoriza/features/cubit/todo_cubit.dart';

enum Menu { completed, favorite, delete }

class UnCompleteData extends StatelessWidget {
  const UnCompleteData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = TodoCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cubit.unCompleteData.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    var item = cubit.unCompleteData[index];
                    return Row(
                      children: [
                        Checkbox(
                            checkColor: Colors.black,
                            focusColor: Colors.black,
                            activeColor: Colors.black,
                            hoverColor: Colors.black,
                            fillColor: MaterialStateProperty.all(Colors.red),
                            value:
                            (item['status'] == 'completed') ? true : false,
                            onChanged: (value) {
                              cubit.updateDatabaseCompleted(
                                  id: cubit.unCompleteData[index]['id'],
                                  status: (cubit.unCompleteData[index]['status'] ==
                                      "uncompleted")
                                      ? "completed"
                                      : "uncompleted");
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['title'],
                            style: TextStyle(
                                color: (item['status'] == 'completed')
                                    ? Colors.grey
                                    : Colors.black,
                                decoration: (item['status'] == 'completed')
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              item['start'],
                              style: TextStyle(
                                  color: (item['status'] == 'completed')
                                      ? Colors.grey
                                      : Colors.black),
                            )),
                        PopupMenuButton<Menu>(
                            child: Icon(Icons.more_vert,
                                color: (item['status'] == 'completed')
                                    ? Colors.grey
                                    : Colors.black),
                            onSelected: (Menu item) {
                              if (item.name == 'delete') {
                                cubit.deleteFromDatabase(
                                    id: cubit.unCompleteData[index]['id']);
                              } else if (item.name == 'completed') {
                                cubit.updateDatabaseCompleted(
                                    id: cubit.unCompleteData[index]['id'],
                                    status: (cubit.unCompleteData[index]['status'] ==
                                        "uncompleted")
                                        ? "completed"
                                        : "uncompleted");
                              } else if (item.name == 'favorite') {
                                cubit.updateDatabaseFav(
                                    id: cubit.unCompleteData[index]['id'],
                                    favorite: (cubit.unCompleteData[index]
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
                                child:  Text((cubit.allData[index]
                                ['status'] ==
                                    "uncompleted")
                                    ? "completed"
                                    : "uncompleted"),
                              ),
                              const PopupMenuItem<Menu>(
                                value: Menu.favorite,
                                child: Text('Favorite'),
                              ),
                              const PopupMenuItem<Menu>(
                                value: Menu.delete,
                                child: Text('Delete'),
                              ),
                            ]),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
