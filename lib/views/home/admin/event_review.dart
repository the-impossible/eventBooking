import 'package:event/components/delegatedText.dart';
import 'package:event/routes/routes.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventReview extends StatefulWidget {
  const EventReview({super.key});

  @override
  State<EventReview> createState() => _EventReviewState();
}

class _EventReviewState extends State<EventReview> {
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
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Get.toNamed(Routes.eventDetails),
                            child: Card(
                              margin: const EdgeInsets.only(top: 15),
                              color: const Color.fromARGB(255, 233, 233, 233),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.comment,
                                  color: Constants.primaryColor,
                                ),
                                title: DelegatedText(
                                  text: "Henry's Marriage",
                                  fontSize: 18,
                                  fontName: "InterMed",
                                  truncate: true,
                                ),
                                subtitle: DelegatedText(
                                  text: "Pending",
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
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
