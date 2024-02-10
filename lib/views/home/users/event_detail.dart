import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/controllers/invitePeopleController.dart';
import 'package:event/routes/routes.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void showRsvp(BuildContext context) {
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
                    text: "RSVP to Henry's Marriage",
                    fontSize: 20,
                    fontName: "InterBold",
                    color: Constants.tertiaryColor,
                    truncate: true,
                  ),
                  const SizedBox(height: 10),
                  DelegatedText(
                    text:
                        "Kindly indicate if you will be in attendance or not!",
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
                            onPressed: () {},
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
                            onPressed: () {},
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
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
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
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                    future: databaseService
                        .getImage(eventDetailController.eventDetails!.image),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                    height: size.height * 0.15,
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
                              )
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
                  DelegatedText(
                    text: "People Attending",
                    fontSize: 15,
                    fontName: 'InterMed',
                    color: Constants.tertiaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/baner.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/baner.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/baner.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.peopleAttending),
                            child: DelegatedText(
                              text: "+ 10 more",
                              fontSize: 20,
                              fontName: 'InterMed',
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showRsvp(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child:
                            DelegatedText(text: "RSVP to Event", fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
