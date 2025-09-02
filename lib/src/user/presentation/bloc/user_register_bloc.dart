import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:ellelife/src/user/data/user_storage.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_register_event.dart';
part 'user_register_state.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  UserRegisterBloc() : super(UserRegisterInitial()) {
    on<UserRegiteringEvent>(_userRegistering);
    on<UserRegisterEventInit>((event, emit) {
      emit(UserRegisterInitial());
    });
  }

  Future<void> _userRegistering(
    final UserRegiteringEvent event,
    final Emitter emit,
  ) async {
    try {
      emit(UserRegisteringLoading());

      final existingUsers = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: event.userEmail)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        // Email already exists → emit error
        emit(UserRegisteringError(message: 'Email already exists'));
        return;
      }

      String? imageUrl0;
      if (event.imageFile != null) {
        final imageUrl = await UserStorage().uploadImageToCloudinary(
          event.imageFile!,
        );
        imageUrl0 = imageUrl!;
      }
      final UserModel user = UserModel(
        userId: "",
        name: event.userName,
        email: event.userEmail,
        teamName: event.teamName,
        imageUrl: imageUrl0 ?? "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        followers: 0,
      );
      await UserReposImpl().saveUser(user, event.password);
      emit(UserRegisteringSuccess());
    } catch (err) {
      throw Exception("Error: $err");
    }
  }
}
