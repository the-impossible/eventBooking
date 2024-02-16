import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleAttendingModel {
  final String id;
  final bool respond;
  final String eventId;
  final String userId;
  final DateTime? created;

  PeopleAttendingModel({
    required this.id,
    required this.respond,
    required this.eventId,
    required this.userId,
    required this.created,
  });

  factory PeopleAttendingModel.fromJson(DocumentSnapshot snapshot) {
    return PeopleAttendingModel(
      id: snapshot.id,
      respond: snapshot['respond'],
      eventId: snapshot['eventId'],
      userId: snapshot['userId'],
      created: snapshot['created'] != null
          ? (snapshot['created'] as Timestamp).toDate()
          : null,
    );
  }
}
