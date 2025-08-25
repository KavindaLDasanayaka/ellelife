import 'package:ellelife/core/Widgets/custom_button.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleTeamPage extends StatelessWidget {
  final Team team;
  const SingleTeamPage({super.key, required this.team});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${team.village} ${team.teamName}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              team.teamPhoto.isNotEmpty
                  ? Center(
                      child: Image.network(
                        team.teamPhoto,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    )
                  : Center(
                      child: Text(
                        "No Team Photo",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Text(
                team.teamName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                team.village,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: team.contactNo.toString(),
                width: double.infinity,
                buttonColor: Colors.lightBlue,
                buttonTextColor: mainWhite,
                onPressed: () {
                  _makePhoneCall(team.contactNo.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
