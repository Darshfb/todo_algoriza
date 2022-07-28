import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_algoriza/features/add_task/add_task_screen.dart';
import 'package:todo_algoriza/features/add_task/notification/notification_api.dart';
import 'package:todo_algoriza/shared/notification_utils.dart';
import 'package:todo_algoriza/features/cubit/todo_cubit.dart';
import 'package:todo_algoriza/features/home/home_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const MethodChannel platform =
MethodChannel('gonzaloaldana.com/local_notifications');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsUtils.instance.initialize();
  await NotificationsUtils.instance.requestIosPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('Hi');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoCubit()..createDataBase()..getAllData(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
