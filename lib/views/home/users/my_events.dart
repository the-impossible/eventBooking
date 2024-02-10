import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/models/events.dart';
import 'package:event/routes/routes.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  DatabaseService databaseService = Get.put(DatabaseService());
  EventDetailController eventDetailController =
      Get.put(EventDetailController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () => Get.toNamed(Routes.createEvent),
                icon: const Icon(
                  Icons.add_circle,
                  size: 40,
                ),
                color: Constants.primaryColor,
              ),
            ),
          ],
          title: DelegatedText(
            text: "My Events",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
          backgroundColor: Constants.basicColor,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color.fromARGB(255, 241, 241, 241),
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: StreamBuilder<List<Events>>(
                        stream: databaseService.getUserSpecificEvents(
                            "Users/${FirebaseAuth.instance.currentUser!.uid}"),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50.0, bottom: 30),
                                    child: SvgPicture.asset(
                                      'assets/error.svg',
                                      width: 50,
                                      height: 200,
                                    ),
                                  ),
                                  DelegatedText(
                                    text: "Something Went Wrong!",
                                    fontSize: 20,
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final eventDataList = snapshot.data!;
                            if (eventDataList.isNotEmpty) {
                              return ListView.builder(
                                itemCount: eventDataList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final eventData = eventDataList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () => {
                                            eventDetailController.eventID =
                                                eventData.id,
                                            eventDetailController.getEvent()
                                          },
                                          child: Container(
                                            height: size.height * 0.28,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              color: Constants.basicColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      221, 207, 203, 203),
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FutureBuilder<String?>(
                                                  future:
                                                      databaseService.getImage(
                                                          eventData.image),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: CircularProgressIndicator(
                                                            color: Constants
                                                                .primaryColor),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            snapshot.data!,
                                                            height:
                                                                size.height *
                                                                    0.15,
                                                            width: size.width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Image.asset(
                                                        "assets/placeholder.png",
                                                        width: 50,
                                                        height: 40,
                                                      );
                                                    }
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      DelegatedText(
                                                        text: eventData.title,
                                                        fontSize: 20,
                                                        fontName: 'InterBold',
                                                        color: Constants
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      DelegatedText(
                                                        text: eventData.desc,
                                                        fontSize: 15,
                                                        fontName: 'InterMed',
                                                        color: Constants
                                                            .tertiaryColor,
                                                        truncate: true,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 5,),
                                                        child: Row(
                                                          children: [
                                                            DelegatedText(
                                                              text: "Status: ",
                                                              fontSize: 15,
                                                              fontName:
                                                                  'InterBold',
                                                              color: Constants
                                                                  .tertiaryColor,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            DelegatedText(
                                                              text: (eventData
                                                                      .status)
                                                                  ? "Approved"
                                                                  : "Pending",
                                                              fontSize: 15,
                                                              fontName:
                                                                  'InterBold',
                                                              color: Constants
                                                                  .tertiaryColor,
                                                            ),
                                                            const Spacer(),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_rounded,
                                                              color: Constants
                                                                  .primaryColor,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50.0, bottom: 30),
                                      child: SvgPicture.asset(
                                        'assets/empty.svg',
                                        width: 50,
                                        height: 200,
                                      ),
                                    ),
                                    DelegatedText(
                                      text: "No Event Found",
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
