part of 'user_login_bloc.dart';

sealed class UserLoginEvent {}

final class UserLogEvent extends UserLoginEvent {
  final String userName;
  final String password;

  UserLogEvent({required this.userName, required this.password});
}

final class UserLogoutEvent extends UserLoginEvent {}

final class SignUpWithGoogleEvent extends UserLoginEvent {}
