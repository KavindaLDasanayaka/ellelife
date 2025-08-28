import 'dart:io';

import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';

import 'package:ellelife/src/user/data/user_storage.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';

import 'package:ellelife/src/user/presentation/bloc/user_register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _teamNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _imageController = TextEditingController();

  File? _imageFile;

  //pick the image
  Future<void> _pickImage(ImageSource source) async {
    var status = await Permission.camera.request();
    if (status.isGranted || await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } else {
      throw Exception("Camera permission denied");
    }
  }

  Future<void> _selectSource(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text("Please Select Source"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: mainWhite,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(mainColor),
                ),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: mainWhite,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  //save user
  Future<void> _saveUser(BuildContext context) async {
    try {
      final password = _passwordController.text;

      BlocProvider.of<UserRegisterBloc>(context).add(
        UserRegiteringEvent(
          userName: _nameController.text.trim(),
          password: password,
          teamName: _teamNameController.text.trim(),
          userEmail: _emailController.text.trim(),
          imageFile: _imageFile,
        ),
      );
    } catch (err) {
      print("User Saving UI error: $err");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Regiter Failed",
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(fontSize: 12, color: mainWhite),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                BlocConsumer<UserRegisterBloc, UserRegisterState>(
                  listener: (context, state) {
                    if (state is UserRegisteringSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User Register Success!")),
                      );
                      (context).goNamed(RouteNames.home);
                    } else if (state is UserRegisteringError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User Registering Faied!")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is UserRegisteringLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserRegisteringError) {
                      return Column(
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          CustomButton(
                            buttonText: "Try Again!",
                            width: double.infinity,
                            buttonColor: mainColor,
                            buttonTextColor: mainWhite,
                            onPressed: () {
                              BlocProvider.of<UserRegisterBloc>(
                                context,
                              ).add(UserRegisterEventInit());
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
                              Center(
                                child: Stack(
                                  children: [
                                    _imageFile != null
                                        ? CircleAvatar(
                                            radius: 64,
                                            backgroundColor: mainColor,
                                            backgroundImage: FileImage(
                                              _imageFile!,
                                            ),
                                          )
                                        : const CircleAvatar(
                                            radius: 64,
                                            backgroundColor: mainColor,
                                            backgroundImage: NetworkImage(
                                              "https://i.stack.imgur.com/l60Hf.png",
                                            ),
                                          ),
                                    Positioned(
                                      bottom: -10,
                                      right: 0,
                                      child: IconButton(
                                        //todo:pick image
                                        iconSize: 30,
                                        onPressed: () async {
                                          _selectSource(context);
                                        },
                                        icon: Icon(Icons.add_a_photo),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextInputField(
                                controller: _nameController,
                                iconData: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter your name!";
                                  }

                                  return null;
                                },
                                labelText: "Name",
                                obscureText: false,
                              ),
                              const SizedBox(height: 20),
                              CustomTextInputField(
                                controller: _emailController,
                                iconData: Icons.email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter your email!";
                                  }
                                  if (!RegExp(
                                    r'\S+@\S+\.\S+',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                labelText: "Email",
                                obscureText: false,
                              ),
                              const SizedBox(height: 20),
                              CustomTextInputField(
                                controller: _teamNameController,
                                iconData: Icons.group,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter your Team Name!";
                                  }
                                  return null;
                                },
                                labelText: "Team",
                                obscureText: false,
                              ),
                              const SizedBox(height: 20),
                              CustomTextInputField(
                                controller: _passwordController,
                                iconData: Icons.key,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Valid Passowrd!";
                                  } else if (value.length < 6) {
                                    return "Password is too Short! User 6 or more characters";
                                  }
                                  return null;
                                },
                                labelText: "Password",
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              CustomTextInputField(
                                controller: _confirmPasswordController,
                                iconData: Icons.key,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please your Passowrd!";
                                  }
                                  if (value != _passwordController.text) {
                                    return "Please Enter the same password";
                                  }
                                  return null;
                                },
                                labelText: "Confirm Password",
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                buttonText: "Register",
                                width: double.infinity,
                                buttonColor: mainColor,
                                buttonTextColor: mainWhite,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _saveUser(context);
                                  }
                                },
                              ),

                              const SizedBox(height: 16),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    (context).goNamed(RouteNames.login);
                                  },
                                  child: Text(
                                    "Already have an account? Sign In",
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
      ),
    );
  }
}
