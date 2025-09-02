import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/auth/presentation/bloc/user_login_bloc.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordResetController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordResetController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter your email address and we'll send you a link to reset your password.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            CustomTextInputField(
              controller: _passwordResetController,
              iconData: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              labelText: "Email",
              obscureText: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _passwordResetController.clear();
            },
            child: const Text("Cancel"),
          ),
          BlocConsumer<UserLoginBloc, UserLoginState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                _passwordResetController.clear();
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is ForgotPasswordLoading) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  if (_passwordResetController.text.isNotEmpty) {
                    BlocProvider.of<UserLoginBloc>(context).add(
                      ForgotPasswordEvent(
                        email: _passwordResetController.text.trim(),
                      ),
                    );
                  }
                },
                child: const Text("Send Reset Email"),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/logo.png",
                width: MediaQuery.of(context).size.width * 0.35,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              BlocConsumer<UserLoginBloc, UserLoginState>(
                listener: (context, state) {
                  if (state is UserLoggedIn) {
                    (context).goNamed(RouteNames.home);
                  } else if (state is UserLoginError) {
                    Center(child: Text(state.message));
                  }
                },
                builder: (context, state) {
                  if (state is UserLoginLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserLoginError) {
                    return Column(
                      children: [
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                        CustomButton(
                          buttonText: "Try Again!",
                          width: double.infinity,
                          buttonColor: mainColor,
                          buttonTextColor: mainWhite,
                          onPressed: () {
                            BlocProvider.of<UserLoginBloc>(
                              context,
                            ).add(UserLogoutEvent());
                          },
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextInputField(
                              controller: _emailController,
                              iconData: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter your email!";
                                }
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              labelText: "Email",
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),
                            CustomTextInputField(
                              controller: _passwordController,
                              iconData: Icons.key,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter your Passowrd!";
                                }
                                return null;
                              },
                              labelText: "Password",
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              buttonText: "Log In",
                              width: double.infinity,
                              buttonColor: mainColor,
                              buttonTextColor: mainWhite,
                              onPressed: () {
                                BlocProvider.of<UserLoginBloc>(context).add(
                                  UserLogEvent(
                                    userName: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            // Text(
                            //   "Sign in with Google to access the app's features",
                            //   style: TextStyle(
                            //     fontSize: 13,
                            //     // ignore: deprecated_member_use
                            //     color: mainWhite.withOpacity(0.6),
                            //   ),
                            // ),
                            const SizedBox(height: 0),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  _showForgotPasswordDialog(context);
                                },
                                child: Text(
                                  "Forgot Password? Click here to reset",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainWhite,
                                  ),
                                ),
                              ),
                            ),
                            // CustomButton(
                            //   buttonText: "Sign in with Google",
                            //   width: double.infinity,
                            //   buttonColor: mainColor,
                            //   buttonTextColor: mainWhite,
                            //   onPressed: () {
                            //     BlocProvider.of<UserLoginBloc>(
                            //       context,
                            //     ).add(SignUpWithGoogleEvent());
                            //   },
                            // ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  (context).goNamed(RouteNames.register);
                                },
                                child: Text(
                                  "Don't have an account? Sign Up",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
