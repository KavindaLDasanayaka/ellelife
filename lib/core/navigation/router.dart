import 'package:ellelife/core/Widgets/wrapper.dart';
import 'package:ellelife/core/auth/presentation/login.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/feed/presentation/screens/postpage.dart';
import 'package:ellelife/src/reels/presentation/reels.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:ellelife/src/teams/presentation/teams_screen.dart';
import 'package:ellelife/src/teams/single_team_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_bloc.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:ellelife/src/user/presentation/screens/edit_profile_page.dart';
import 'package:ellelife/src/user/presentation/screens/register.dart';
import 'package:ellelife/core/navigation/navigation_screen.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/src/feed/presentation/screens/create_post.dart';
import 'package:ellelife/src/feed/presentation/screens/home_screen.dart';
import 'package:ellelife/src/user/presentation/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: "/",
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  errorPageBuilder: (context, state) {
    return const MaterialPage<dynamic>(
      child: Scaffold(body: Center(child: Text("this page is not found!!"))),
    );
  },
  routes: [
    GoRoute(
      path: "/",
      name: RouteNames.wrapper,
      builder: (context, state) {
        return Wrapper();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return NavigationScreen(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: "/home",
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          name: "/reels",
          path: RouteNames.reels,
          builder: (context, state) => ReelsPage(),
        ),
        GoRoute(
          name: "/teams",
          path: RouteNames.teams,
          builder: (context, state) => TeamsScreen(),
        ),
        GoRoute(
          name: "/profile",
          path: RouteNames.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: "/register",
      name: RouteNames.register,
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: "/login",
      name: RouteNames.login,
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: "/singleteam",
      name: RouteNames.singletTeam,
      builder: (context, state) {
        final Team team = state.extra as Team;
        return SingleTeamPage(team: team);
      },
    ),
    GoRoute(
      path: "/singlepost",
      name: RouteNames.singletPost,
      builder: (context, state) {
        final Post post = state.extra as Post;
        return Postpage(post: post);
      },
    ),
    GoRoute(
      name: "/create",
      path: RouteNames.createPost,
      builder: (context, state) => CreatePost(),
    ),
    GoRoute(
      path: "/edit-profile",
      name: RouteNames.editProfile,
      builder: (context, state) {
        final UserModel user = state.extra as UserModel;
        return BlocProvider(
          create: (context) => UserUpdateBloc(),
          child: EditProfilePage(user: user),
        );
      },
    ),
  ],
);
