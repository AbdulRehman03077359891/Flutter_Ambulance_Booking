import 'package:amdulancebooking/Controllers/animation_controller.dart';
import 'package:amdulancebooking/Controllers/business_controller.dart';
import 'package:amdulancebooking/Widgets/Admin/admin_horizontal_ambu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmbuLanceData extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const AmbuLanceData(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AmbuLanceData> createState() => _AmbuLanceDataState();
}

class _AmbuLanceDataState extends State<AmbuLanceData> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController dishPriceController = TextEditingController();
  var businessController = Get.put(BusinessController());
  var animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    businessController.getHospitals(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "View Dishes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: businessController.allHospitals.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  businessController.allHospitals[index]
                                              ["selected"] ==
                                          true
                                      ? ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFE63946))),
                                          onPressed: () {
                                            businessController.getAmbulances(
                                              index,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add_box,
                                                  color: Colors.white),
                                              Text(
                                                businessController
                                                        .allHospitals[index]
                                                    ["name"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ))
                                      : ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white)),
                                          onPressed: () {
                                            businessController.getAmbulances(
                                              index,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add_box,
                                                  color: Color(0xFFE63946)),
                                              Text(
                                                businessController
                                                        .allHospitals[index]
                                                    ["name"],
                                                style: const TextStyle(
                                                    color: Color(0xFFE63946)),
                                              )
                                            ],
                                          )),
                                ],
                              );
                            }),
                      ),
                      businessController.selectedAmbulances.isEmpty
                          ? SizedBox(height: MediaQuery.of(context).size.height*.7,
                            child: const Center(
                             child: Text(
                               "No Ambulance Available",
                               style: TextStyle(color: Color(0xFFE63946)),
                             ),
                                                          ),
                          )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  businessController.selectedAmbulances.length,
                              itemBuilder: (context, index) {
                                return AdminHorizontalAmbuCard(
                                  ambuName: businessController
                                      .selectedAmbulances[index]["ambuName"],
                                  ambuContact: businessController
                                      .selectedAmbulances[index]["ambuContact"],
                                  ambuPlate: businessController
                                      .selectedAmbulances[index]["ambuPlate"],
                                  ambuSize: businessController
                                      .selectedAmbulances[index]["ambuSize"],
                                  description: businessController
                                      .selectedAmbulances[index]["discription"],
                                  imageUrl: businessController
                                      .selectedAmbulances[index]["ambuPic"],
                                  index: index,
                                  ambuKey: businessController
                                      .selectedAmbulances[index]["ambuKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                );
                              })
                    ],
                  ),
                );
        },
      ),
    );
  }
}
