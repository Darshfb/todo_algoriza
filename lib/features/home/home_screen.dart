import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algoriza/features/add_task/add_task_screen.dart';
import 'package:todo_algoriza/features/cubit/todo_cubit.dart';
import 'package:todo_algoriza/features/home/widgets/all_widget.dart';
import 'package:todo_algoriza/features/home/widgets/complete_widget.dart';
import 'package:todo_algoriza/features/home/widgets/favorite_widget.dart';
import 'package:todo_algoriza/features/home/widgets/uncomplete_widget.dart';
import 'package:todo_algoriza/features/schedule/schedule_screen.dart';
import 'package:todo_algoriza/shared/component/component.dart';
import 'package:todo_algoriza/shared/component/custom_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  int? currentIndex;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = TodoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context: context, widget: ScheduleScreen());
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.grey,
                  ))
            ],
            title: const Text('Board',
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
            toolbarHeight: 90.0,
          ),
          body: Column(
            children: [
              Expanded(
                child: ContainedTabBarView(
                  tabs: const [
                    Text(
                      'All',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Completed',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'uncompleted',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Favorite',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                  views: const [
                    AllData(),
                    CompleteData(),
                    UnCompleteData(),
                    FavoriteData(),
                  ],
                  tabBarProperties: const TabBarProperties(
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label),
                  onChange: (index) {
                    print(index);
                    currentIndex = index;
                    if (index == 0) {
                      print('hi');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(text: 'Add a task', onPressed: () {
                  navigateTo(context: context, widget: AddTask());
                },),
              ),
            ],
          ),
        );
      },
    );
  }
}
