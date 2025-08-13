import 'dart:io';

import 'package:ellelife/core/Widgets/Custom_text_Input_field.dart';
import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/teams/data/team_storage.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:ellelife/src/teams/presentation/bloc/team_register_bloc.dart';
import 'package:ellelife/src/teams/presentation/bloc/teams_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TeamRegister extends StatefulWidget {
  const TeamRegister({super.key});

  @override
  State<TeamRegister> createState() => _TeamRegisterState();
}

class _TeamRegisterState extends State<TeamRegister> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _teamNameController = TextEditingController();

  final TextEditingController _teamVillageController = TextEditingController();

  final TextEditingController _teamContactNoController =
      TextEditingController();

  final TextEditingController _teamImageController = TextEditingController();

  File? _imageFile;

  //pick the image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveTeam() async {
    try {
      if (_imageFile != null) {
        final imageUrl = await TeamStorage().uploadImageToCloudinary(
          _imageFile!,
        );
        _teamImageController.text = imageUrl!;
        print(_teamImageController.text);
      }

      final team = Team(
        teamId: "",
        teamName: _teamNameController.text.trim(),
        village: _teamVillageController.text.trim(),
        contactNo: int.parse(_teamContactNoController.text),
        teamPhoto: _teamImageController.text,
      );

      BlocProvider.of<TeamRegisterBloc>(
        context,
      ).add(TeamRegisteringEvent(team: team));
    } catch (err) {
      throw Exception("Error in saving team $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Your Team")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              BlocBuilder<TeamRegisterBloc, TeamRegisterState>(
                builder: (context, state) {
                  if (state is TeamRegisteringState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TeamRegisteredState) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "Team Registered Successfull!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: mainWhite,
                            ),
                          ),
                          CustomButton(
                            buttonText: "Go Back",
                            width: double.infinity,
                            buttonColor: mainColor,
                            buttonTextColor: mainWhite,
                            onPressed: () {
                              Navigator.pop(context);
                              BlocProvider.of<TeamsBloc>(
                                context,
                              ).add(TeamsInitEvent());
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state is TeamRegisterErrorState) {
                    return const Center(child: Text("Team Saving Error!"));
                  } else {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextInputField(
                            controller: _teamNameController,
                            iconData: Icons.group,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter team name";
                              }
                            },
                            labelText: "Team Name",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextInputField(
                            controller: _teamVillageController,
                            iconData: Icons.location_pin,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter village of the team";
                              }
                            },
                            labelText: "Village",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextInputField(
                            controller: _teamContactNoController,
                            iconData: Icons.call,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter contact number";
                              }
                            },
                            labelText: "Mobile No",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                mainColor,
                              ),
                            ),
                            onPressed: () {
                              _pickImage();
                            },
                            child: Text(
                              "Select Team Photo",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: mainWhite,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _imageFile!,
                                    width: 200,
                                    height: 150,
                                  ),
                                )
                              : Text(
                                  "No Image Selected",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: mainWhite,
                                  ),
                                ),
                          const SizedBox(height: 35),
                          CustomButton(
                            buttonText: "Save Team",
                            width: double.infinity,
                            buttonColor: mainColor,
                            buttonTextColor: mainWhite,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveTeam();
                              }
                            },
                          ),
                        ],
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
