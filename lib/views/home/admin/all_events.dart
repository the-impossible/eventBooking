import 'package:event/components/delegatedText.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/background.jpg"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DelegatedText(
                            text: 'All Events',
                            fontSize: 30,
                            fontName: 'InterMed',
                            color: Constants.basicColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: DelegatedText(
                              text: 'Below are events you can attend',
                              fontSize: 15,
                              fontName: 'InterReg',
                              color: Constants.basicColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  color: const Color.fromARGB(255, 241, 241, 241),
                  height: size.height * 0.7,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                height: size.height * 0.28,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Constants.basicColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(221, 207, 203, 203),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          "assets/data_entry.png",
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
                                            truncate: true,
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
                                                  text: "Thu, Jun 27",
                                                  fontSize: 15,
                                                  fontName: 'InterBold',
                                                  color:
                                                      Constants.tertiaryColor,
                                                ),
                                                const SizedBox(width: 10),
                                                DelegatedText(
                                                  text: "9:00 AM",
                                                  fontSize: 15,
                                                  fontName: 'InterBold',
                                                  color:
                                                      Constants.tertiaryColor,
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Constants.primaryColor,
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
