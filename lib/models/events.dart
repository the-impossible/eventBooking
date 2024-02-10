import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String id;
  final String title;
  final String desc;
  final bool isRestricted;
  final bool status;
  final String image;
  final String createdBy;
  final DateTime? date;
  final DateTime? created;

  Events({
    required this.id,
    required this.title,
    required this.desc,
    required this.isRestricted,
    required this.status,
    required this.image,
    required this.createdBy,
    required this.date,
    required this.created,
  });

  factory Events.fromJson(DocumentSnapshot snapshot) {
    return Events(
      id: snapshot.id,
      title: snapshot['title'],
      desc: snapshot['desc'],
      isRestricted: snapshot['isRestricted'],
      status: snapshot['status'],
      image: snapshot['image'],
      createdBy: snapshot['createdBy'],
      date: snapshot['date'] != null
          ? (snapshot['date'] as Timestamp).toDate()
          : null,
      created: snapshot['created'] != null
          ? (snapshot['created'] as Timestamp).toDate()
          : null,
    );
  }

}

