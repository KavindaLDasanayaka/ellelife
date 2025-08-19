import 'dart:io';

import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/core/utils/mood.dart';

import 'package:ellelife/src/feed/presentation/bloc/post_create_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _captionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //pick the image
  Future<void> _pickImage(ImageSource source, Mood mood) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      BlocProvider.of<PostCreateBloc>(
        context,
      ).add(ImageSelectEvent(file: File(pickedImage.path), mood: mood));
    }
  }

  Future<void> _savePost(File? imageFile, Mood mood) async {
    BlocProvider.of<PostCreateBloc>(context).add(
      PostCreatingEvent(
        caption: _captionController.text,
        mood: mood,
        imageFile,
      ),
    );
    _captionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SingleChildScrollView(
              child: BlocConsumer<PostCreateBloc, PostCreateState>(
                listener: (context, state) {
                  if (state is PostCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Posts Created Successfully")),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PostCreateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PostCreateInitial) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextInputField(
                            controller: _captionController,
                            iconData: Icons.text_fields,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a caption";
                              }
                              return null;
                            },
                            labelText: "Caption",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          DropdownButton<Mood>(
                            value: state.mood,
                            items: Mood.values.map((Mood mood) {
                              return DropdownMenuItem(
                                value: mood,
                                child: Text("${mood.name} ${mood.emoji}"),
                              );
                            }).toList(),
                            onChanged: (Mood? newMood) {
                              BlocProvider.of<PostCreateBloc>(context).add(
                                MoodSelection(mood: newMood!, state.imageFile),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          state.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: kIsWeb
                                      ? Image.network(state.imageFile!.path)
                                      : Image.file(state.imageFile!),
                                )
                              : Text(
                                  "No Image Selected",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: mainWhite,
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                buttonColor: mainColor,
                                buttonTextColor: mainWhite,
                                buttonText: "User Camera",
                                width: MediaQuery.of(context).size.width * 0.43,
                                onPressed: () {
                                  _pickImage(ImageSource.camera, state.mood);
                                },
                              ),
                              CustomButton(
                                buttonColor: mainColor,
                                buttonTextColor: mainWhite,
                                buttonText: "User Gallery",
                                width: MediaQuery.of(context).size.width * 0.43,
                                onPressed: () {
                                  _pickImage(ImageSource.gallery, state.mood);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            buttonText: "Create Post",
                            width: double.infinity,
                            buttonColor: mainColor,
                            buttonTextColor: mainWhite,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _savePost(state.imageFile, state.mood);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(),
                        CustomButton(
                          buttonText: "Create New post",
                          width: double.infinity,
                          buttonColor: mainColor,
                          buttonTextColor: mainWhite,
                          onPressed: () {
                            BlocProvider.of<PostCreateBloc>(
                              context,
                            ).add(PostInitEvent());
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
