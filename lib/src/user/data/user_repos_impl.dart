import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:ellelife/src/user/domain/repo/user_repos.dart';

class UserReposImpl extends UserRepos {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection("users");

  @override
  Future<void> deleteUser(String userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(UserModel user, String password) async {
    try {
      final userCredential = await UserAuthService()
          .createUserWithEmailAndPassword(
            email: user.email,
            password: password,
          );
      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      // final Map<String, dynamic> userData = user.toJson();
      // await _userCollection.add(userData);
      final DocumentReference docref = FirebaseFirestore.instance
          .collection("users")
          .doc(userId);

      final userMap = user.toJson();
      userMap['userId'] = userId;

      await docref.set(userMap);

      print("user saved successfuly with userId :$userId");
    } catch (err) {
      print("Error Creating user: $err");
      throw Exception("Error Creating User : $err");
    }
  }

  @override
  Future<void> updateUser(String userId) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }
}
