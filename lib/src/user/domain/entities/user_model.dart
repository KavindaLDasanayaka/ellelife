import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String teamName;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final String password;
  final int followers;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.teamName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    // required this.password,
    required this.followers,
  });

  //from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      teamName: json["teamName"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      // password: json["password"] ?? "",
      followers: json["followers"].toInt() ?? 0,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "teamName": teamName,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      // "password": password,
      "followers": followers,
    };
  }
}
