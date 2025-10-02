import 'dart:io';

import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:ellelife/src/user/data/user_storage.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _teamNameController;
  late TextEditingController _emailController;
  File? _selectedImage;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _teamNameController = TextEditingController(text: widget.user.teamName);
    _emailController = TextEditingController(text: widget.user.email);
    _imageUrl = widget.user.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teamNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    try {
      final imageUrl = await UserStorage().uploadImageToCloudinary(_selectedImage!);
      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image if selected
      if (_selectedImage != null) {
        await _uploadImage();
      }

      // Create updated user model
      final updatedUser = UserModel(
        userId: widget.user.userId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        teamName: _teamNameController.text.trim(),
        imageUrl: _imageUrl ?? widget.user.imageUrl,
        createdAt: widget.user.createdAt,
        updatedAt: DateTime.now(),
        followers: widget.user.followers,
      );

      // Update user in database
      await UserReposImpl().updateUser(widget.user.userId, updatedUser);

      // Show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back to profile page
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Profile picture section
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_imageUrl?.isNotEmpty ?? false)
                            ? NetworkImage(_imageUrl!)
                            : null,
                    child: _selectedImage == null && (_imageUrl?.isEmpty ?? true)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Text('Change Profile Picture'),
                ),
              ),
              const SizedBox(height: 20),
              // Name field
              const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextInputField(
                controller: _nameController,
                labelText: 'Enter your name',
                iconData: Icons.person,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Team/Bio field
              const Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextInputField(
                controller: _teamNameController,
                labelText: 'Enter your bio',
                iconData: Icons.info,
                obscureText: false,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Email field (readonly)
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextInputField(
                controller: _emailController,
                labelText: 'Email',
                iconData: Icons.email,
                obscureText: false,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Update button
              CustomButton(
                buttonText: _isLoading ? 'Updating...' : 'Update Profile',
                width: double.infinity,
                buttonColor: mainColor,
                buttonTextColor: mainWhite,
                onPressed: _isLoading ? () {} : _updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}