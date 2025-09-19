import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:ellelife/src/user/data/user_storage.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_event.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_state.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  final UserReposImpl _userRepository = UserReposImpl();
  final UserStorage _userStorage = UserStorage();

  UserUpdateBloc() : super(UserUpdateInitial()) {
    on<UserUpdateStarted>(_onUserUpdateStarted);
    on<UserUpdateReset>(_onUserUpdateReset);
  }

  void _onUserUpdateStarted(
    UserUpdateStarted event,
    Emitter<UserUpdateState> emit,
  ) async {
    emit(UserUpdateLoading());

    try {
      String imageUrl = event.user.imageUrl;

      // Upload new image if provided
      if (event.newImageFile != null) {
        final uploadedImageUrl = await _userStorage.uploadImageToCloudinary(event.newImageFile!);
        if (uploadedImageUrl != null) {
          imageUrl = uploadedImageUrl;
        } else {
          emit(UserUpdateFailure(error: "Failed to upload image"));
          return;
        }
      }

      // Create updated user model
      final updatedUser = UserModel(
        userId: event.user.userId,
        name: event.user.name,
        email: event.user.email,
        teamName: event.user.teamName,
        imageUrl: imageUrl,
        createdAt: event.user.createdAt,
        updatedAt: DateTime.now(),
        followers: event.user.followers,
      );

      // Update user in repository
      await _userRepository.updateUser(event.user.userId, updatedUser);

      emit(UserUpdateSuccess(message: "Profile updated successfully"));
    } catch (error) {
      emit(UserUpdateFailure(error: "Failed to update profile: $error"));
    }
  }

  void _onUserUpdateReset(
    UserUpdateReset event,
    Emitter<UserUpdateState> emit,
  ) {
    emit(UserUpdateInitial());
  }
}