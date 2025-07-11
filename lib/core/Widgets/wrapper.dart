import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show a loading spinner while waiting for the stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // 👇 Navigate to /home if user is logged in
          Future.microtask(() => context.go('/home'));
          return const SizedBox(); // Return empty widget while navigating
        } else {
          // 👇 Navigate to /login if not logged in
          Future.microtask(() => context.go('/login'));
          return const SizedBox();
        }
      },
    );
  }
}
