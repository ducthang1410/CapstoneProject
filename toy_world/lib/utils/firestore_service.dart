import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toy_world/models/model_message_chat.dart';
import 'package:toy_world/models/model_trading_message.dart';
import 'package:toy_world/utils/firestore_constants.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future<void> updateDataFirestore(String collectionPath, String docPath,
    Map<String, dynamic> dataNeedUpdate) {
  return firebaseFirestore
      .collection(collectionPath)
      .doc(docPath)
      .update(dataNeedUpdate);
}

Future<String?> getBillId(String collectionPath, String docPath) async {
  DocumentReference documentReference =
      firebaseFirestore.collection(collectionPath).doc(docPath);
  String? billId;
  await documentReference.get().then((snapshot) {
    if (snapshot['billId'] != null) {
      billId = snapshot['billId'].toString();
    } else {
      billId = null;
    }
  });
  return billId;
}

Stream<DocumentSnapshot> getTradingMessageData(String groupChatId) {
  return firebaseFirestore
      .collection(FirestoreConstants.pathTradingMessageCollection)
      .doc(groupChatId)
      .snapshots();
}

Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
  return firebaseFirestore
      .collection(FirestoreConstants.pathMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy(FirestoreConstants.timestamp, descending: true)
      .limit(limit)
      .snapshots();
}

Stream<QuerySnapshot> getTradingChatStream(String groupChatId, int limit) {
  return firebaseFirestore
      .collection(FirestoreConstants.pathTradingMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy(FirestoreConstants.timestamp, descending: true)
      .limit(limit)
      .snapshots();
}

void sendMessage(String content, int type, String groupChatId,
    int currentUserId, int peerId) {
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

Stream<QuerySnapshot> getTradingMessageStream(
    String pathCollection, int limit) {
  return firebaseFirestore
      .collection(pathCollection)
      .orderBy(FirestoreConstants.timestamp, descending: true)
      .limit(limit)
      .snapshots();
}

void sendTradingMessage(
    String content, int type, String groupChatId, int currentUserId, peerId) {
  Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());

  DocumentReference documentReference = firebaseFirestore
      .collection(FirestoreConstants.pathTradingMessageCollection)
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

  updateDataFirestore(FirestoreConstants.pathTradingMessageCollection,
      groupChatId, {FirestoreConstants.lastChatTime: myTimeStamp});
}

createTradingConversation(
    title, tradingPostId, toyName, buyerId, sellerId, content, buyerName) {
  Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());
  String groupChatId;
  if (buyerId < sellerId) {
    groupChatId = "$buyerId-$sellerId-$tradingPostId";
  } else {
    groupChatId = "$sellerId-$buyerId-$tradingPostId";
  }

  DocumentReference documentReference = firebaseFirestore
      .collection(FirestoreConstants.pathTradingMessageCollection)
      .doc(groupChatId);

  //model
  TradingMessage tradingMessage = TradingMessage(
    sellerId: sellerId,
    buyerId: buyerId,
    isBillCreated: false,
    tradingPostId: tradingPostId,
    timestamp: myTimeStamp,
    title: title,
    contentPost: content,
    toyName: toyName,
    buyerName: buyerName
  );

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
      documentReference,
      tradingMessage.toJson(),
    );
  });
}
