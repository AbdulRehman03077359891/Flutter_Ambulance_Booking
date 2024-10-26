import 'package:amdulancebooking/Controllers/admin_dashboard_controller.dart';
import 'package:amdulancebooking/Controllers/chat_controller.dart';
import 'package:amdulancebooking/Widgets/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestDetailScreen extends StatelessWidget {
  final String adminUid, adminName, adminEmail;
  final String? adminProfilePic;
  final String userUid;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String userContact;
  final String userCnic;
  final String userGender;
  final String userBloodType;
  final String ambuKey;
  final String ambuPic;
  final String status;
  final String appliedAt;
  final String reqKey;

  const RequestDetailScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.userCnic,
    required this.userGender,
    required this.userBloodType,
    required this.ambuKey,
    required this.ambuPic,
    required this.status,
    required this.appliedAt,
    required this.reqKey,
    required this.adminUid,
    required this.adminName,
    required this.adminEmail,
    this.adminProfilePic,
    this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController adminDashboardController =
        Get.put(AdminDashboardController());
    final ChatController chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Request Details',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE63946),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE63946)),
              ),
            ),
            const Divider(),
            buildDetailRow('user Name:', userName),
            buildDetailRow('user Email:', userEmail),
            buildDetailRow('user Contact:', userContact),
            buildDetailRow('user CNIC:', userCnic),
            buildDetailRow('Gender:', userGender),
            buildDetailRow('BloodType:', userBloodType),
            buildDetailRow('Status:', status),
            buildDetailRow('Applied At:', appliedAt),
            const SizedBox(height: 20),
            const Divider(),
            ambuPic.isNotEmpty
                ? Image.network(
                    ambuPic,
                    fit: BoxFit.fitWidth,
                  )
                : const SizedBox(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                E1Button(
                    onPressed: () {
                      adminDashboardController.updateRequest(
                          reqKey, 'Rejected', adminUid, adminName, adminEmail);
                    },
                    backColor: Colors.white,
                    text: "Reject",
                    textColor: const Color(0xFFE63946)),
                E1Button(
                    onPressed: () {
                      adminDashboardController.updateRequest(
                          reqKey, 'Accepted', adminUid, adminName, adminEmail);
                      chatController.createConversation(
                        adminUid,
                        adminName,
                        adminEmail,
                        adminProfilePic,
                        userUid,
                        userName,
                        userEmail,
                        userProfilePic,
                      );
                    },
                    backColor: Colors.white,
                    text: "Accept",
                    textColor: const Color(0xFFE63946)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
