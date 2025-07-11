import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: TextButton(
          onPressed: () {
            UserAuthService().signOut();
            (context).goNamed(RouteNames.login);
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
