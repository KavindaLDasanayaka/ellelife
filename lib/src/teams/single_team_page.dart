import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleTeamPage extends StatelessWidget {
  final Team team;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SingleTeamPage({super.key, required this.team});

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        // Fallback to dial if direct call is not available
        final Uri dialUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(dialUri)) {
          await launchUrl(dialUri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackBar('Could not launch phone dialer for $phoneNumber');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error making phone call: $e');
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    // Convert int to string and ensure it's properly formatted
    String phoneStr = phoneNumber;
    // Remove any non-digit characters (if any)
    phoneStr = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return phoneStr;
  }

  void _showErrorSnackBar(String message) {
    // Get the current context from the widget tree
    final context = _scaffoldKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

              GestureDetector(
                onTap: () {
                  _makePhoneCall(_formatPhoneNumber(team.contactNo));
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Text(
                        _formatPhoneNumber(team.contactNo),
                        style: TextStyle(
                          fontSize: 16,
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
