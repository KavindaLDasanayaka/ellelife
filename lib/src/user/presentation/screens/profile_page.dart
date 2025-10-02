import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/core/utils/constants.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel?> _userFuture;
  bool _isLoading = true;
  bool _hasError = false;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = UserAuthService().getCurrentUser()?.uid ?? '';
    _userFuture = _fetchUserDetails();
  }

  Future<UserModel?> _fetchUserDetails() async {
    try {
      final userId = UserAuthService().getCurrentUser()?.uid ?? '';
      final UserModel? user = await UserReposImpl().getUserById(userId);

      setState(() {
        _isLoading = false;
        if (user == null) {
          _hasError = true;
        }
      });
      return user;
    } catch (err) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return null;
    }
  }

  void _signOut(BuildContext context) async {
    clearDiskCache();
    await UserAuthService().signOut();
    (context).goNamed(RouteNames.login);
  }

  void clearDiskCache() async {
    await DefaultCacheManager().emptyCache(); // clears disk cache
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final user = await _userFuture;
              if (user != null) {
                context.pushNamed(RouteNames.editProfile, extra: user);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : const NetworkImage(profileImage) as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User Bio
                  Text(
                    user.teamName,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),
                  CustomButton(
                    buttonText: "Logout",
                    width: double.infinity,
                    buttonColor: mainColor,
                    buttonTextColor: mainWhite,
                    onPressed: () {
                      _signOut(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // body: Center(
      //   child: TextButton(
      //     onPressed: () {
      //       UserAuthService().signOut();
      //       (context).goNamed(RouteNames.login);
      //     },
      //     child: Text("Logout"),
      //   ),
      // ),
    );
  }
}