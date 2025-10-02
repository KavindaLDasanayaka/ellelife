import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/feed/data/reels_repo_impl.dart';
import 'package:ellelife/src/feed/domain/entities/reel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateReelPage extends StatefulWidget {
  const CreateReelPage({super.key});

  @override
  State<CreateReelPage> createState() => _CreateReelPageState();
}

class _CreateReelPageState extends State<CreateReelPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveReel(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Check if the current user is authorized to add reels
      final currentUser = UserAuthService().getCurrentUser();
      if (currentUser?.email != 'ellelifesl@gmail.com') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Only authorized users can add reels"),
            ),
          );
        }
        return;
      }

      final reel = Reel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        videoUrl: _videoUrlController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: Timestamp.now(),
      );

      try {
        await ReelsRepoImpl().addReel(reel);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reel added successfully")),
          );
          // Clear form
          _titleController.clear();
          _descriptionController.clear();
          _videoUrlController.clear();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to add reel: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Reel"),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInputField(
                controller: _titleController,
                iconData: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
                labelText: "Title",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextInputField(
                controller: _descriptionController,
                iconData: Icons.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
                labelText: "Description",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextInputField(
                controller: _videoUrlController,
                iconData: Icons.link,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a YouTube video URL";
                  }
                  // Basic YouTube URL validation
                  if (!value.contains("youtube.com") &&
                      !value.contains("youtu.be")) {
                    return "Please enter a valid YouTube URL";
                  }
                  return null;
                },
                labelText: "YouTube Video URL",
                obscureText: false,
              ),
              const SizedBox(height: 30),
              CustomButton(
                buttonText: "Add Reel",
                width: double.infinity,
                buttonColor: mainColor,
                buttonTextColor: mainWhite,
                onPressed: () => _saveReel(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
