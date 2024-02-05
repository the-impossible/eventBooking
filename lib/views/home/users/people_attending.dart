import 'package:event/components/delegatedText.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PeopleAttending extends StatefulWidget {
  const PeopleAttending({super.key});

  @override
  State<PeopleAttending> createState() => _PeopleAttendingState();
}

class _PeopleAttendingState extends State<PeopleAttending> {
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
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(top: 15),
                            color: const Color.fromARGB(255, 233, 233, 233),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Constants.basicColor,
                                maxRadius: 50,
                                minRadius: 50,
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/user.png",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
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
