import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventDetails {
  final String id;
  final String title;
  final String desc;
  final bool isRestricted;
  final bool status;
  final String image;
  final String createdBy;
  final DateTime? date;
  final DateTime? created;

  EventDetails({
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

  factory EventDetails.fromJson(Map<String, dynamic> snapshot) {
    return EventDetails(
      id: snapshot['id'],
      title: snapshot['title'],
      desc: snapshot['desc'],
      isRestricted: snapshot['isRestricted'],
      status: snapshot['status'],
      image: snapshot['image'],
      createdBy: snapshot['createdBy'],
      date: snapshot['date'],
      created: snapshot['created'],
    );
  }

  factory EventDetails.fromMap(Map<String, dynamic> map, String id) {

    return EventDetails(
      id: id,
      title: map['title'],
      desc: map['desc'],
      isRestricted: map['isRestricted'],
      status: map['status'],
      image: map['image'],
      createdBy: map['createdBy'],
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : null,
      created: map['created'] != null
          ? (map['created'] as Timestamp).toDate()
          : null,
    );
  }
}
