import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/delegatedForm2.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/controllers/updateEventController.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:event/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateEvent extends StatefulWidget {
  const UpdateEvent({super.key});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  final _formKey = GlobalKey<FormState>();

  UpdateEventController updateEventController =
      Get.put(UpdateEventController());
  EventDetailController detailEventController =
      Get.put(EventDetailController());
  DatabaseService databaseService = Get.put(DatabaseService());

  TextEditingController _start = TextEditingController();
  TextEditingController _end = TextEditingController();
  var pickedDateTime;
  String textValue = 'Unrestricted Event';
  bool? isSwitched = false;

  @override
  void initState() {
    super.initState();
    UpdateEventController updateEventController =
        Get.put(UpdateEventController());
    EventDetailController detailEventController =
        Get.put(EventDetailController());
    updateEventController.titleController.text =
        detailEventController.eventDetails!.title;
    updateEventController.descController.text =
        detailEventController.eventDetails!.desc;
    processStatus(detailEventController.eventDetails!.isRestricted);
    processDate(detailEventController.eventDetails!.date);
  }

  _pickDateTime(TextEditingController controller) async {
    DateTime dateTime = DateTime.now();

    DateTime? pickedDate = await Constants.pickDate(context, dateTime);
    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await Constants.pickTime(context, dateTime);
    if (pickedTime == null) return;

    dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);

    setState(() {
      var date = DateFormat.yMEd().format(dateTime);
      var time = DateFormat.jm().format(dateTime);
      String eventDate = "$date, $time";
      controller.text = eventDate;
      updateEventController.eventDate = eventDate;
    });
  }

  File? image;

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        updateEventController.image = image;
        updateEventController.imageName = pickedFile.name;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        delegatedSnackBar("Failed to Capture image: $e", false),
      );
    }
  }

  Future<void> processStatus(status) async {
    setState(() {
      isSwitched = status;
      if (status) {
        textValue = 'Restricted Event';
      } else {
        textValue = 'Unrestricted Event';
      }
    });
  }

  Future<void> processDate(date) async {
    setState(() {
      // Convert DateTime to string
      String dateString = DateFormat('MMM-dd-yy hh:mm a').format(date);
      _start.text = dateString;
    });
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Restricted Event';
        updateEventController.isRestricted = true;
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Unrestricted Event';
        updateEventController.isRestricted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DelegatedText(
                      text: "Edit Your Event",
                      fontSize: 20,
                      fontName: "InterBold",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: InkWell(
                        onTap: () => {pickImage()},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (image != null)
                              ? Image.file(
                                  image!,
                                  width: size.width,
                                  height: size.height * 0.25,
                                  fit: BoxFit.cover,
                                )
                              : (detailEventController.eventDetails?.image !=
                                      null)
                                  ? FutureBuilder<String?>(
                                      future: databaseService.getImage(
                                          detailEventController
                                              .eventDetails!.image
                                              .toString()),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                    )
                                  : Image.asset(
                                      "assets/placeholder.png",
                                      height: size.height * 0.25,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DelegatedForm2(
                      hintText: 'Event Name',
                      validator: FormValidator.validateField,
                      keyboardInputType: TextInputType.multiline,
                      maxLines: 1,
                      formController: updateEventController.titleController,
                    ),
                    DelegatedForm2(
                      hintText: 'Event Description',
                      validator: FormValidator.validateField,
                      keyboardInputType: TextInputType.multiline,
                      maxLines: 4,
                      formController: updateEventController.descController,
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: isSwitched!,
                            onChanged: toggleSwitch,
                            activeColor: Constants.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        DelegatedText(text: textValue, fontSize: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormField(
                            text: _start,
                            obscureText: false,
                            fontSize: 20.0,
                            icon: Icons.date_range,
                            label: "Event Date & Time",
                            onTap: () => _pickDateTime(_start),
                            validator: FormValidator.validateField,
                            fillColor: Colors.white,
                            keyboardInputType: TextInputType.none,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updateEventController.eventDate = _start.text;
                              updateEventController.eventId =
                                  detailEventController.eventDetails!.id;
                              updateEventController.updateEvent();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child:
                              DelegatedText(text: "Update Event", fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
