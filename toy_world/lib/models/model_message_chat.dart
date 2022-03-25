import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toy_world/utils/firestore_constants.dart';
class MessageChat {
  int fromId;
  int toId;
  Timestamp timestamp;
  String content;
  int type;

  MessageChat({
    required this.fromId,
    required this.toId,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.fromId: fromId,
      FirestoreConstants.toId: toId,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.type: type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    int fromId = doc.get(FirestoreConstants.fromId);
    int toId = doc.get(FirestoreConstants.toId);
    Timestamp timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    int type = doc.get(FirestoreConstants.type);
    return MessageChat(fromId: fromId, toId: toId, timestamp: timestamp, content: content, type: type);
  }
}
