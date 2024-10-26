import 'package:amdulancebooking/Controllers/animation_controller.dart';
import 'package:amdulancebooking/Controllers/fire_controller.dart';
import 'package:amdulancebooking/Screen/Chat/choose_chat.dart';
import 'package:amdulancebooking/Screen/User/personal_data.dart';
import 'package:amdulancebooking/Screen/User/user_requests.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDrawerWidget extends StatefulWidget {
  final String userUid, accountName, accountEmail;

  const UserDrawerWidget({
    super.key,
    required this.userUid,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  State<UserDrawerWidget> createState() => _UserDrawerWidgetState();
}

class _UserDrawerWidgetState extends State<UserDrawerWidget> {
  final FireController fireController = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
    fetchData();});
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Drawer(
        backgroundColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 50,
        child: ListView(
          children: [
            fireController.isLoading.value
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .265,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE63946),
                      ),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 245, 222, 224)),
                    arrowColor: const Color(0xFFE63946),
                    currentAccountPicture:                           GestureDetector(
                            onTap: () {
                              if (fireController.userData["profilePic"] != null) {
                                animateController.showSecondPage(
                                  "Profile Picture",
                                  fireController.userData["profilePic"] ?? 'assets/images/profilePlaceHolder.jpg',
                                  context,
                                );
                              }
                            },
                            child: Hero(
                              tag: "Profile Picture",
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFFE63946),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 245, 222, 224),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  image: DecorationImage(
                                    image: fireController.userData["profilePic"] != null
                                        ? CachedNetworkImageProvider(fireController.userData["profilePic"])
                                        : const AssetImage('assets/images/profilePlaceHolder.jpg') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    accountName: Text(
                      fireController.userData["userName"] ?? 'Unknown user',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [BoxShadow(color: Colors.black87, blurRadius: 20)],
                      ),
                    ),
                    accountEmail: Text(
                      fireController.userData["userEmail"] ?? 'Unknown email',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [BoxShadow(color: Colors.black87, blurRadius: 20)],
                      ),
                    ),
                  ),
            _buildListTile(
              icon: Icons.person_rounded,
              title: "Personal Data",
              onTap: () {
                Get.to(
                  UserPersonalData(
                    imageUrl: fireController.userData["profilePic"]??'',
                    userName: fireController.userData["userName"],
                    userUid: widget.userUid,
                    gender: fireController.userData["userGender"],
                    contact: fireController.userData["userContact"],
                    dob: fireController.userData["dateOfBirth"],
                    address: fireController.userData["userAddress"],
                    userEmail: fireController.userData["userEmail"],
                  ),
                );
              },
            ),
            _buildListTile(
              icon: Icons.request_page,
              title: "Requests",
              onTap: () {Get.to(UsersRequests(userUid: widget.userUid, userName: fireController.userData["userName"], userEmail: fireController.userData["userEmail"]));},
            ),
            _buildListTile(
              icon: Icons.chat,
              title: "Chats",
              onTap: () {
                Get.to(UserChatsScreen(userUid: widget.userUid, userName: fireController.userData["userName"], userEmail: fireController.userData["userEmail"], profilePicture: fireController.userData["profilePic"], status: false,));
              },
            ),
            _buildListTile(
              icon: Icons.logout,
              title: "LogOut",
              onTap: () {
                fireController.logOut();
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildListTile({required IconData icon, required String title, required Function() onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE63946),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFFE63946)),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFFE63946),
      ),
      onTap: onTap,
    );
  }
}