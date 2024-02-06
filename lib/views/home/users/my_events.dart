import 'package:event/components/delegatedText.dart';
import 'package:event/routes/routes.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

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
                    child: ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => Get.toNamed(
                                  Routes.eventDetails,
                                ),
                                child: Container(
                                  height: size.height * 0.28,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Constants.basicColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(221, 207, 203, 203),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            "assets/baner.png",
                                            height: size.height * 0.15,
                                            width: size.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DelegatedText(
                                              text: "Henry's Marriage",
                                              fontSize: 20,
                                              fontName: 'InterBold',
                                              color: Constants.primaryColor,
                                            ),
                                            DelegatedText(
                                              text:
                                                  "Am inviting you to my forth-coming wedding",
                                              fontSize: 15,
                                              fontName: 'InterMed',
                                              color: Constants.tertiaryColor,
                                              truncate: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Row(
                                                children: [
                                                  DelegatedText(
                                                    text: "Status: ",
                                                    fontSize: 15,
                                                    fontName: 'InterBold',
                                                    color:
                                                        Constants.tertiaryColor,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  DelegatedText(
                                                    text: "Pending",
                                                    fontSize: 15,
                                                    fontName: 'InterBold',
                                                    color:
                                                        Constants.tertiaryColor,
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color:
                                                        Constants.primaryColor,
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
                    ),
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
