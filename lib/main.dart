import 'package:ellelife/core/auth/presentation/bloc/user_login_bloc.dart';
import 'package:ellelife/core/navigation/router.dart';
import 'package:ellelife/firebase_options.dart';
import 'package:ellelife/src/feed/presentation/bloc/post_create_bloc.dart';
import 'package:ellelife/src/feed/presentation/bloc/post_home_bloc.dart';
import 'package:ellelife/src/feed/presentation/bloc/postedit_bloc.dart';
import 'package:ellelife/src/teams/presentation/bloc/team_register_bloc.dart';
import 'package:ellelife/src/teams/presentation/bloc/teams_bloc.dart';
import 'package:ellelife/src/user/presentation/bloc/user_register_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/core/utils/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserLoginBloc()),
        BlocProvider(create: (context) => UserRegisterBloc()),
        BlocProvider(create: (context) => PostCreateBloc()),
        BlocProvider(create: (context) => TeamsBloc()),
        BlocProvider(create: (context) => TeamRegisterBloc()),
        BlocProvider(create: (context) => PosteditBloc()),
        BlocProvider(create: (context) => PostHomeBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Elle Life",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.dark(),
      ),
      routerConfig: router,
    );
  }
}
