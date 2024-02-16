import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/models/people_attending.dart';
import 'package:event/models/user_data.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PeopleAttending extends StatefulWidget {
  const PeopleAttending({super.key});

  @override
  State<PeopleAttending> createState() => _PeopleAttendingState();
}

class _PeopleAttendingState extends State<PeopleAttending> {
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
          backgroundColor: Constants.primaryColor,
          leading: IconButton(
            color: Constants.tertiaryColor,
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          title: DelegatedText(
            text: "People Attending",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
        ),
        backgroundColor: Constants.basicColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DelegatedText(
                text: 'Below is the list of people that will be in attending',
                fontSize: 15,
                fontName: 'InterReg',
                truncate: false,
              ),
              SizedBox(
                height: size.height * .75,
                child: SingleChildScrollView(
                  child: StreamBuilder<List<PeopleAttendingModel>>(
                      stream: databaseService
                          .getListOfAttendees(eventDetailController.eventID),
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
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: eventDataList.length,
                              itemBuilder: (context, index) {
                                final eventData = eventDataList[index];
                                return Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: eventDataList.length,
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<UserData?>(
                                          future: databaseService
                                              .getUserDetails(eventData.userId
                                                  .replaceAll("Users/", "")),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Constants
                                                            .primaryColor),
                                              );
                                            } else if (snapshot.hasData) {
                                              return Card(
                                                margin: const EdgeInsets.only(
                                                    top: 15),
                                                color: const Color.fromARGB(
                                                    255, 233, 233, 233),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Constants.basicColor,
                                                    maxRadius: 50,
                                                    minRadius: 50,
                                                    child:
                                                        StreamBuilder<String?>(
                                                      stream: databaseService
                                                          .getProfileImage(
                                                              eventData.userId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              "Something went wrong! ${snapshot.error}");
                                                        } else if (snapshot
                                                            .hasData) {
                                                          return ClipOval(
                                                              child:
                                                                  Image.network(
                                                            snapshot.data!,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          ));
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  title: DelegatedText(
                                                    text: "Richard Emmanuel",
                                                    fontSize: 18,
                                                    truncate: true,
                                                  ),
                                                  subtitle: DelegatedText(
                                                    text: "08146543239",
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50.0,
                                                              bottom: 30),
                                                      child: SvgPicture.asset(
                                                        'assets/empty.svg',
                                                        width: 50,
                                                        height: 200,
                                                      ),
                                                    ),
                                                    DelegatedText(
                                                      text:
                                                          "No List of Attendees Found",
                                                      fontSize: 20,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
