import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_algoriza/features/cubit/notification_info.dart';
import 'package:todo_algoriza/main.dart';
import 'package:todo_algoriza/shared/notification_utils.dart';
import 'package:timezone/timezone.dart' as tz;
part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  static TodoCubit get(context) => BlocProvider.of(context);
  Database? database;

  void createDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    openDatabase(path, version: 1, onCreate: (database, version) {
      if (kDebugMode) {
        print('The database is created');
      }
      database
          .execute(
              'CREATE TABLE todo (id INTEGER PRIMARY KEY, title TEXT, date TEXT, start TEXT, end TEXT, remind TEXT, repeat TEXT, status TEXT, favorite TEXT)')
          .then((value) {
        if (kDebugMode) {
          print('table is created');
        }
      });
    }, onOpen: (database) {
      getAllData(database: database);
      if (kDebugMode) {
        print('table is opened');
      }
    }).then((value) {
      emit(CreateDatabaseSuccessState());
      database = value;
    }).catchError((error) {
      emit(CreateDatabaseErrorState());
    });
  }

  List<Map> allData = [];
  List<Map> completeData = [];
  List<Map> unCompleteData = [];
  List<Map> favorite = [];

  void getAllData({Database? database}) async {
    allData = [];
    completeData = [];
    unCompleteData = [];
    favorite = [];
    emit(TodoLoadingGetAllDataState());
    database?.rawQuery('SELECT * FROM todo').then((value) {
      for (var i in value) {
        if (i['favorite'] == "true") {
          favorite.add(i);
          print('favorite ${favorite.toString()}');
        }
        if (i['status'] == "uncompleted") {
          unCompleteData.add(i);
          print('unCompleteData ${unCompleteData.toString()}');
        }
        if (i['status'] == "completed") {
          completeData.add(i);
          print('completeData ${completeData.toString()}');
        }
        allData.add(i);
        print('all data ${allData.toString()}');
      }
      if (kDebugMode) {
        print(' $allData');
      }
      emit(TodoSuccessGetAllDataState());
    }).catchError((error) {
      emit(TodoErrorGetAllDataState(error.toString()));
      if (kDebugMode) {
        print('error when get all data $error');
      }
    });
  }

  List<Map> listByDate = [];
  String dateTime = DateFormat('yyyy-MM-dd ').format(DateTime.now());

  void selectByDate() {
    print('hi');
    listByDate = [];
    database?.query('todo', where: '"date" = ?', whereArgs: [dateTime]).then(
        (value) {
      print('2');
      for (var i in value) {
        listByDate.add(i);
      }
      if (kDebugMode) {
        print('.................................................. $listByDate');
      }
      emit(TodoSuccessChangeByDateState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void changeDate(value) {
    dateTime = value;
    selectByDate();
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String start,
    required String end,
    required String remind,
    required String repeat,
    required String status,
    required String favorite,
  }) {
    emit(LoadingInsertToDatabase());
    database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO todo (title, date, start, end, remind, repeat, status, favorite) '
              'VALUES("$title","$date","$start","$end","$remind","$repeat","$status","$favorite")')
          .then((value) {
        getAllData(database: database);
        if (kDebugMode) {
          print('$value data inserted successfully');
        }
        emit(SuccessInsertToDatabase());
      }).catchError((error) {
        emit(ErrorInsertToDatabase(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    });
  }

  void deleteFromDatabase({required int id}) {
    emit(LoadingDeleteToDatabase());
    database!.rawDelete('DELETE FROM todo WHERE id = ? ', [id]).then((value) {
      getAllData(database: database);
      if (kDebugMode) {
        print('$value deleted successfully');
      }
    }).catchError((error) {
      emit(ErrorDeleteToDatabase(error.toString()));
      if (kDebugMode) {
        print('error when deleting from database $error');
      }
    });
  }

  bool isCompleted = false;

  void updateDatabaseCompleted({required int id, required String status}) {
    emit(LoadingUpdateToDatabase());
    database!
        .update('todo', {"status": status}, where: 'id =?', whereArgs: [id])
        .then((value) {
      getAllData(database: database);
      selectByDate();
      if (kDebugMode) {
        print('item updated $value');
      }
    }).catchError((error) {
      emit(ErrorUpdateToDatabase(error.toString()));
      if (kDebugMode) {
        print('error when updating data $error');
      }
    });
  }

  void updateDatabaseFav({required int id, required String favorite}) {
    emit(LoadingUpdateToDatabase());
    database!
        .update('todo', {"favorite": favorite}, where: 'id =?', whereArgs: [id])
        .then((value) {
      getAllData(database: database);
      selectByDate();
      if (kDebugMode) {
        print('item updated $value');
      }
    }).catchError((error) {
      emit(ErrorUpdateToDatabase(error.toString()));
      if (kDebugMode) {
        print('error when updating data $error');
      }
    });
  }

  void deleteAllDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    deleteDatabase(path).then((value) {
      createDataBase();
    });
  }

  Future _onSelectNotification(String? payload) async {
    if (payload == null) {
      return;
    }

    final splitArguments = payload.split('?');

    if (splitArguments.length != 2) {
      return;
    }

    final isoFormatDate = splitArguments.last;
    final date = DateTime.tryParse(isoFormatDate);

    if (date == null) {
      return;
    }
  }

  void showNotificationInTime(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    final isoDate = DateTime.now().toIso8601String();

    NotificationsUtils.instance.showNotification(
      title: 'A local push notification',
      body: 'This is a local push notification example.',
      payload: '/notification?$isoDate',
      onSelectNotification: _onSelectNotification,
    ).then((value){
      emit(NotificationInTimeState());
    }).catchError((error){
      print(error.toString());
    });
  }

  void scheduleNotification({
    required DateTime date,
    required TimeOfDay time,
    required String title,
    required String body,
  }) {
    final isoDate = DateTime.now().toIso8601String();

    NotificationsUtils.instance.scheduleNotification(
      title: title,
      body: body,
      payload: '/notification?$isoDate',
      onSelectNotification: _onSelectNotification,
      date: date,
      time: time,
    ).then((value){
      print('hi');
      emit(ScheduleNotificationState());
    });
  }

  //Notification

  static const _notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'gonzaloaldana.com/local_notifications', 'your channel name',
          channelDescription: 'your channel description'));

  /// Setting alarm for specific date
  static void scheduleAlarmOnDate(AlarmInfo alarmInfo) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        alarmInfo.id ?? 0,
        alarmInfo.title,
        alarmInfo.title,
        tz.TZDateTime.from(alarmInfo.alarmDateTime, tz.local),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// Setting alarm for repeat interval
  static void repeatNotification(AlarmInfo alarmInfo,
      {required RepeatInterval repeatInterval}) async {
    await flutterLocalNotificationsPlugin.periodicallyShow(alarmInfo.id ?? 0,
        alarmInfo.title, alarmInfo.title, repeatInterval, _notificationDetails,
        androidAllowWhileIdle: true);
  }

}


