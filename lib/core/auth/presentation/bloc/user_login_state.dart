part of 'user_login_bloc.dart';

sealed class UserLoginState {}

final class UserLoginInitial extends UserLoginState {}

final class UserLoginLoading extends UserLoginState {}

final class UserLoggedIn extends UserLoginState {}

final class UserLoginError extends UserLoginState {
  final String message;

  UserLoginError({required this.message});
}
