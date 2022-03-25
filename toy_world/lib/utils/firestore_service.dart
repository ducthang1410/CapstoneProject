import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toy_world/models/model_message_chat.dart';
import 'package:toy_world/utils/firestore_constants.dart';


final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
  return firebaseFirestore
      .collection(FirestoreConstants.pathMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy(FirestoreConstants.timestamp, descending: true)
      .limit(limit)
      .snapshots();
}

void sendMessage(String content, int type, String groupChatId, int currentUserId, int peerId) {

  Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());

  DocumentReference documentReference = firebaseFirestore
      .collection(FirestoreConstants.pathMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .doc();

  //model
  MessageChat messageChat = MessageChat(
    fromId: currentUserId,
    toId: peerId,
    timestamp: myTimeStamp,
    content: content,
    type: type,
  );

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
      documentReference,
      messageChat.toJson(),
    );
  });
}