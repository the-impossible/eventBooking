import 'package:contacts_service/contacts_service.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/invitePeopleController.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool isLoading = true;
  List<Contact> global_contacts = [];
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    getContactsPermission();
  }

  void getContactsPermission() async {
    if (await Permission.contacts.isGranted) {
      getAllContacts();
    } else {
      await Permission.contacts.request();
      getAllContacts();
    }
  }

  void getAllContacts() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    List<Contact> localContacts = await ContactsService.getContacts();
    setState(() {
      global_contacts = localContacts;
    });
    navigator!.pop(Get.context!);
  }

  InvitePeopleController invitePeopleController =
      Get.put(InvitePeopleController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: DelegatedText(
            text: "Invite Contact",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Center(
                  child: DelegatedText(
                    text: "Select the contact you want to invite",
                    fontSize: 15,
                    fontName: "InterReg",
                    color: Constants.tertiaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemCount: global_contacts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Contact contact = global_contacts[index];
                            bool isSelected =
                                selectedContacts.contains(contact);

                            return ListTile(
                              title: DelegatedText(
                                text: "${contact.displayName}",
                                fontSize: 15,
                                fontName: "InterReg",
                                color: Constants.tertiaryColor,
                              ),
                              subtitle: DelegatedText(
                                text: (contact.phones!.isNotEmpty)
                                    ? "${contact.phones![0].value}"
                                    : "",
                                fontSize: 15,
                                fontName: "InterReg",
                                color: Constants.tertiaryColor,
                              ),
                              leading: (contact.avatar != null &&
                                      contact.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.avatar!),
                                    )
                                  : CircleAvatar(
                                      child: Text(
                                        "${contact.initials()} ",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "InterReg",
                                          color: Constants.tertiaryColor,
                                        ),
                                      ),
                                    ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Constants.primaryColor,
                                      size: 25,
                                    )
                                  : const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedContacts.remove(contact);
                                  } else {
                                    selectedContacts.add(contact);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            invitePeopleController.selectedContacts = selectedContacts;
            invitePeopleController.inviteContact();
          },
          backgroundColor: Constants.primaryColor,
          child: const Icon(
            Icons.mail,
            size: 25,
          ),
        ),
      ),
    );
  }
}
