part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class CreateDatabaseSuccessState extends TodoState {}

class CreateDatabaseErrorState extends TodoState {}

class TodoLoadingGetAllDataState extends TodoState {}

class TodoSuccessGetAllDataState extends TodoState {}

class TodoErrorGetAllDataState extends TodoState {
  final String error;

  TodoErrorGetAllDataState(this.error);
}

class LoadingInsertToDatabase extends TodoState {}

class SuccessInsertToDatabase extends TodoState {}

class ErrorInsertToDatabase extends TodoState {
  final String error;

  ErrorInsertToDatabase(this.error);
}

class LoadingUpdateToDatabase extends TodoState {}

class ErrorUpdateToDatabase extends TodoState {
  final String error;

  ErrorUpdateToDatabase(this.error);
}

class LoadingDeleteToDatabase extends TodoState {}

class ErrorDeleteToDatabase extends TodoState {
  final String error;

  ErrorDeleteToDatabase(this.error);
}

class TodoSuccessChangeByDateState extends TodoState {}

class TodoSuccessChangeByDate2State extends TodoState {}

class ScheduleNotificationState extends TodoState {}

class NotificationInTimeState extends TodoState {}

class TodoLoadingChangeByDateState extends TodoState {}
