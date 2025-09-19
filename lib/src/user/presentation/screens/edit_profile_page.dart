import 'dart:io';

import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/core/utils/constants.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_bloc.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_event.dart';
import 'package:ellelife/src/user/presentation/bloc/user_update_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _nameController;
  late final TextEditingController _teamNameController;

  File? _imageFile;
  bool _hasImageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _teamNameController = TextEditingController(text: widget.user.teamName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    var status = await Permission.camera.request();
    if (status.isGranted || await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
          _hasImageChanged = true;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Camera permission denied")),
        );
      }
    }
  }

  Future<void> _selectSource(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: const Text("Select Image Source"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Gallery",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                child: const Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserModel(
        userId: widget.user.userId,
        name: _nameController.text.trim(),
        email: widget.user.email, // Email cannot be changed
        teamName: _teamNameController.text.trim(),
        imageUrl: widget.user.imageUrl,
        createdAt: widget.user.createdAt,
        updatedAt: DateTime.now(),
        followers: widget.user.followers,
      );

      BlocProvider.of<UserUpdateBloc>(context).add(
        UserUpdateStarted(
          user: updatedUser,
          newImageFile: _hasImageChanged ? _imageFile : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: mainColor,
        foregroundColor: mainWhite,
      ),
      body: BlocConsumer<UserUpdateBloc, UserUpdateState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.goNamed(RouteNames.profile);
          } else if (state is UserUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserUpdateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Image Section
                      Center(
                        child: Stack(
                          children: [
                            _imageFile != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundColor: mainColor,
                                    backgroundImage: FileImage(_imageFile!),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundColor: mainColor,
                                    backgroundImage: widget.user.imageUrl.isNotEmpty
                                        ? NetworkImage(widget.user.imageUrl)
                                        : const NetworkImage(profileImage) as ImageProvider,
                                  ),
                            Positioned(
                              bottom: -10,
                              right: 0,
                              child: IconButton(
                                iconSize: 30,
                                onPressed: () async {
                                  _selectSource(context);
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Name Field
                      CustomTextInputField(
                        controller: _nameController,
                        iconData: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name!";
                          }
                          return null;
                        },
                        labelText: "Name",
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      
                      // Email Field (Read-only)
                      CustomTextInputField(
                        controller: TextEditingController(text: widget.user.email),
                        iconData: Icons.email,
                        validator: (value) => null, // No validation needed for read-only field
                        labelText: "Email",
                        obscureText: false,
                        enabled: false, // Make email field read-only
                      ),
                      const SizedBox(height: 20),
                      
                      // Team Name Field
                      CustomTextInputField(
                        controller: _teamNameController,
                        iconData: Icons.group,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your team name!";
                          }
                          return null;
                        },
                        labelText: "Team",
                        obscureText: false,
                      ),
                      const SizedBox(height: 30),
                      
                      // Update Button
                      CustomButton(
                        buttonText: "Update Profile",
                        width: double.infinity,
                        buttonColor: mainColor,
                        buttonTextColor: mainWhite,
                        onPressed: _updateProfile,
                      ),
                      const SizedBox(height: 16),
                      
                      // Cancel Button
                      CustomButton(
                        buttonText: "Cancel",
                        width: double.infinity,
                        buttonColor: Colors.grey,
                        buttonTextColor: mainWhite,
                        onPressed: () {
                          context.goNamed(RouteNames.profile);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}