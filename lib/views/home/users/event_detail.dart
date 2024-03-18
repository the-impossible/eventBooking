import 'dart:math';

import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/ApproveEvent.dart';
import 'package:event/controllers/deleteCandidateController.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/controllers/invitePeopleController.dart';
import 'package:event/controllers/respondToEventController.dart';
import 'package:event/models/people_attending.dart';
import 'package:event/models/user_data.dart';
import 'package:event/routes/routes.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void showRsvp(BuildContext context, details) {
  RespondToEventController respondToEventController =
      Get.put(RespondToEventController());

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
    ),
    backgroundColor: const Color.fromARGB(255, 218, 213, 213),
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    builder: (context) {
      return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DelegatedText(
                    text: details.title,
                    fontSize: 20,
                    fontName: "InterBold",
                    color: Constants.tertiaryColor,
                    truncate: true,
                  ),
                  const SizedBox(height: 10),
                  DelegatedText(
                    text: details.desc,
                    fontSize: 15,
                    fontName: "InterReg",
                    color: Constants.tertiaryColor,
                    truncate: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              respondToEventController.respondToEvent(
                                  true,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  details.id);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: DelegatedText(text: "Accept", fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              respondToEventController.respondToEvent(
                                  false,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  details.id);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[500],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: DelegatedText(text: "Decline", fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
    },
  );
}

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  EventDetailController eventDetailController =
      Get.put(EventDetailController());

  DatabaseService databaseService = Get.put(DatabaseService());
  InvitePeopleController invitePeopleController =
      Get.put(InvitePeopleController());

  ApproveEventController approveEventController =
      Get.put(ApproveEventController());

  DeleteEventController deleteEventController =
      Get.put(DeleteEventController());

  @override
  Widget build(BuildContext context) {
    String dateTimeToString(DateTime date) {
      DateFormat outputFormat = DateFormat("MMM d y, hh:mma");
      return outputFormat.format(date);
    }

    String date = dateTimeToString(eventDetailController.eventDetails!.date!);

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Visibility(
              visible: (databaseService.userData!.type == 'adm')
                  ? true
                  : (eventDetailController.eventDetails!.createdBy ==
                          "Users/${FirebaseAuth.instance.currentUser!.uid}")
                      ? true
                      : false,
              child: IconButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this event, NB: This action is not reversible?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteEventController.eventID =
                                  eventDetailController.eventDetails!.id;
                              deleteEventController.deleteEvent();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  )
                },
                icon: const Icon(
                  Icons.restore_from_trash_sharp,
                  size: 30,
                ),
                color: Constants.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Visibility(
                visible: (databaseService.userData!.type == 'adm')
                    ? false
                    : (eventDetailController.eventDetails!.createdBy ==
                            "Users/${FirebaseAuth.instance.currentUser!.uid}")
                        ? (eventDetailController.eventDetails!.status == true)
                            ? true
                            : false
                        : false,
                child: IconButton(
                  onPressed: () => {
                    invitePeopleController.eventID =
                        eventDetailController.eventDetails!.id,
                    Get.toNamed(Routes.contactList)
                  },
                  icon: const Icon(
                    Icons.person_add_alt,
                    size: 30,
                  ),
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
          title: DelegatedText(
            text: "Event Details",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
          backgroundColor: Constants.basicColor,
          leading: IconButton(
            color: Constants.tertiaryColor,
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: SizedBox(
              height: size.height * .8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String?>(
                      future: databaseService
                          .getImage(eventDetailController.eventDetails!.image),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Constants.primaryColor),
                          );
                        } else if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapshot.data!,
                                height: size.height * 0.2,
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
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: DelegatedText(
                        text: eventDetailController.eventDetails!.title,
                        fontSize: 20,
                        fontName: 'InterBold',
                        color: Constants.primaryColor,
                        truncate: false,
                      ),
                    ),
                    DelegatedText(
                      text: eventDetailController.eventDetails!.desc,
                      fontSize: 15,
                      fontName: 'InterMed',
                      color: Constants.tertiaryColor,
                      truncate: false,
                    ),
                    const Divider(
                      height: 20,
                      color: Constants.primaryColor,
                      thickness: 1,
                    ),
                    Container(
                      height: size.height * 0.2,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Constants.basicColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(221, 207, 203, 203),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DelegatedText(
                                  text: "Event Time",
                                  fontSize: 15,
                                  fontName: 'InterMed',
                                  color: Constants.tertiaryColor,
                                ),
                                const SizedBox(height: 10),
                                DelegatedText(
                                  text: date,
                                  fontSize: 20,
                                  fontName: 'InterBold',
                                  color: Constants.primaryColor,
                                  truncate: true,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    DelegatedText(
                                      text: "Event Type: ",
                                      fontSize: 15,
                                      fontName: 'InterMed',
                                      color: Constants.tertiaryColor,
                                    ),
                                    const SizedBox(height: 10),
                                    DelegatedText(
                                      text: (eventDetailController
                                              .eventDetails!.isRestricted)
                                          ? "Restricted!"
                                          : "UnRestricted!",
                                      fontSize: 20,
                                      fontName: 'InterBold',
                                      color: Constants.primaryColor,
                                      truncate: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    DelegatedText(
                                      text: "Created By: ",
                                      fontSize: 15,
                                      fontName: 'InterMed',
                                      color: Constants.tertiaryColor,
                                    ),
                                    const SizedBox(height: 10),
                                    FutureBuilder<UserData?>(
                                      future: databaseService.getUserName(
                                          eventDetailController
                                              .eventDetails!.createdBy),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                                color: Constants.primaryColor),
                                          );
                                        } else if (snapshot.hasData) {
                                          return DelegatedText(
                                            text: (snapshot.data!.name.isEmpty)
                                                ? snapshot.data!.name
                                                : snapshot.data!.username,
                                            fontSize: 20,
                                            fontName: 'InterBold',
                                            color: Constants.primaryColor,
                                            truncate: true,
                                          );
                                        } else {
                                          return DelegatedText(
                                            text: "Failed to get user",
                                            fontSize: 20,
                                            fontName: 'InterBold',
                                            color: Constants.primaryColor,
                                            truncate: true,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: Constants.primaryColor,
                      thickness: 1,
                    ),
                    // People attending text
                    Visibility(
                      visible: (eventDetailController.eventDetails!.createdBy ==
                                  "Users/${FirebaseAuth.instance.currentUser!.uid}" ||
                              databaseService.userData!.type == 'adm')
                          ? true
                          : false,
                      child: DelegatedText(
                        text: "People Attending",
                        fontSize: 15,
                        fontName: 'InterMed',
                        color: Constants.tertiaryColor,
                      ),
                    ),
                    // People attending image
                    Visibility(
                      visible: (eventDetailController.eventDetails!.createdBy ==
                                  "Users/${FirebaseAuth.instance.currentUser!.uid}" ||
                              databaseService.userData!.type == 'adm')
                          ? true
                          : false,
                      child: SizedBox(
                        height: size.height * .3,
                        child: SingleChildScrollView(
                          child: StreamBuilder<List<PeopleAttendingModel>>(
                              stream: databaseService.getListOfAttendees(
                                  eventDetailController.eventID),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Column(
                                      children: [
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
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: min(eventDataList.length, 3),
                                      itemBuilder: (context, index) {
                                        final eventData = eventDataList[index];
                                        return StreamBuilder<String?>(
                                          stream:
                                              databaseService.getProfileImage(
                                                  eventData.userId),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Something went wrong! ${snapshot.error}");
                                            } else if (snapshot.hasData) {
                                              return InkWell(
                                                onTap: () => {
                                                  Get.toNamed(
                                                      Routes.peopleAttending)
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                Image.network(
                                                              snapshot.data!,
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: DelegatedText(
                                                          text: (eventDataList
                                                                          .length -
                                                                      3 >
                                                                  1)
                                                              ? "${max(0, eventDataList.length - 3)} more"
                                                              : "",
                                                          fontSize: 20,
                                                          fontName: 'InterMed',
                                                          color: Constants
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
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
                                              height: 100,
                                            ),
                                          ),
                                          DelegatedText(
                                            text: "No List of Attendees Found",
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
                    ),
                    // Users  responding to event button
                    Visibility(
                      visible: (databaseService.userData!.type == 'adm')
                          ? false
                          : true,
                      child: StreamBuilder<bool>(
                        stream: databaseService.hasResponded(
                            FirebaseAuth.instance.currentUser!.uid,
                            eventDetailController.eventDetails!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Return a loading indicator while the future is still loading
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Constants.primaryColor),
                            );
                          } else if (snapshot.hasError) {
                            // Return an error message if the future encountered an error
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
                          } else {
                            // Check if the future has completed and returned true
                            if (snapshot.data == false) {
                              return Visibility(
                                visible: (eventDetailController
                                            .eventDetails!.createdBy ==
                                        "Users/${FirebaseAuth.instance.currentUser!.uid}")
                                    ? false
                                    : true,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showRsvp(context,
                                            eventDetailController.eventDetails);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      child: DelegatedText(
                                          text: "Respond to Event",
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Return an empty container if the future returned false
                              return Container();
                            }
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: (databaseService.userData!.type == 'adm')
                          ? true
                          : false,
                      child: StreamBuilder<bool>(
                        stream: databaseService.hasApproved(
                            eventDetailController.eventDetails!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Return a loading indicator while the future is still loading
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Constants.primaryColor),
                            );
                          } else if (snapshot.hasError) {
                            // Return an error message if the future encountered an error
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
                          } else {
                            // Check if the future has completed and returned true
                            if (snapshot.data == false) {
                              return Visibility(
                                visible: (snapshot.data == true) ? false : true,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, bottom: 30),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        approveEventController.approveUserEvent(
                                            eventDetailController
                                                .eventDetails!.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      child: DelegatedText(
                                          text: "Submit Approval",
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Return an empty container if the future returned false
                              return Container();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: (eventDetailController.eventDetails!.createdBy ==
                  "Users/${FirebaseAuth.instance.currentUser!.uid}")
              ? true
              : false,
          child: FloatingActionButton(
            onPressed: () {
              eventDetailController.eventID =
                  eventDetailController.eventDetails!.id;
              eventDetailController.getEvent("update");
            },
            backgroundColor: Constants.primaryColor,
            child: const Icon(
              Icons.edit,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
