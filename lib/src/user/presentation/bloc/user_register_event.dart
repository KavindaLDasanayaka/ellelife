part of 'user_register_bloc.dart';

sealed class UserRegisterEvent {}

final class UserRegisterEventInit extends UserRegisterEvent {}

final class UserRegiteringEvent extends UserRegisterEvent {
  final String userName;
  final String userEmail;
  final String teamName;
  final String password;
  final File? imageFile;

  UserRegiteringEvent({
    required this.userName,
    required this.userEmail,
    required this.teamName,
    required this.password,
    required this.imageFile,
  });
}
