import 'package:ellelife/src/user/domain/entities/user_model.dart';

abstract class UserRepos {
  Future<void> saveUser(UserModel user, String password);
  Future<void> deleteUser(String userId);
  Future<void> updateUser(String userId, UserModel updatedUser);
  Future<UserModel?> getUserById(String userId);
  Future<List<UserModel?>> getAllusers();
}
