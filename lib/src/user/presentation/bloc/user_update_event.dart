import 'dart:io';

import 'package:ellelife/src/user/domain/entities/user_model.dart';

abstract class UserUpdateEvent {}

class UserUpdateStarted extends UserUpdateEvent {
  final UserModel user;
  final File? newImageFile;

  UserUpdateStarted({
    required this.user,
    this.newImageFile,
  });
}

class UserUpdateReset extends UserUpdateEvent {}