import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/models/events.dart';
import 'package:event/routes/routes.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EventReview extends StatefulWidget {
  const EventReview({super.key});

  @override
  State<EventReview> createState() => _EventReviewState();
}

class _EventReviewState extends State<EventReview> {
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
          title: DelegatedText(
            text: "Pending Review",
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
                text: 'Below is the list of event that are pending review',
                fontSize: 15,
                fontName: 'InterReg',
                truncate: false,
              ),
              SizedBox(
                height: size.height * .7,
                child: SingleChildScrollView(
                  child: StreamBuilder<List<Events>>(
                      stream: databaseService.getAllEventsPendingReviews(),
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
                                return InkWell(
                                  onTap: () => {
                                    eventDetailController.eventID =
                                        eventData.id,
                                    eventDetailController.getEvent("details")
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(top: 15),
                                    color: const Color.fromARGB(
                                        255, 233, 233, 233),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.comment,
                                        color: Constants.primaryColor,
                                      ),
                                      title: DelegatedText(
                                        text: eventData.title,
                                        fontSize: 18,
                                        fontName: "InterMed",
                                        truncate: true,
                                      ),
                                      subtitle: DelegatedText(
                                        text: (eventData.status)
                                            ? "Approved"
                                            : "Pending",
                                        fontSize: 15,
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Constants.primaryColor,
                                      ),
                                    ),
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
                                    text: "No Pending Event Found",
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
