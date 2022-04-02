import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toy_world/utils/firestore_constants.dart';

class TradingMessage {
  int sellerId;
  int buyerId;
  int tradingPostId;
  Timestamp timestamp;
  bool isBillCreated;
  String title;
  String? contentPost;
  String toyName;
  int? billId;

  TradingMessage(
      {required this.sellerId,
      required this.buyerId,
      required this.tradingPostId,
      required this.timestamp,
      required this.isBillCreated,
      required this.title,
      required this.toyName,
      this.contentPost,
      this.billId});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.sellerId: sellerId,
      FirestoreConstants.buyerId: buyerId,
      FirestoreConstants.tradingPostId: tradingPostId,
      FirestoreConstants.lastChatTime: timestamp,
      FirestoreConstants.isBillCreated: isBillCreated,
      FirestoreConstants.title: title,
      FirestoreConstants.contentPost: contentPost,
      FirestoreConstants.toyName: toyName,
      FirestoreConstants.billId: billId,
    };
  }

  factory TradingMessage.fromDocument(DocumentSnapshot doc) {
    int sellerId = doc.get(FirestoreConstants.sellerId);
    int buyerId = doc.get(FirestoreConstants.buyerId);
    int tradingPostId = doc.get(FirestoreConstants.tradingPostId);
    Timestamp timestamp = doc.get(FirestoreConstants.lastChatTime);
    bool isBillCreated = doc.get(FirestoreConstants.isBillCreated);
    String title = doc.get(FirestoreConstants.title);
    String contentPost = doc.get(FirestoreConstants.contentPost);
    String toyName = doc.get(FirestoreConstants.toyName);
    return TradingMessage(
        sellerId: sellerId,
        buyerId: buyerId,
        tradingPostId: tradingPostId,
        timestamp: timestamp,
        isBillCreated: isBillCreated,
        title: title,
        contentPost: contentPost,
        toyName: toyName,
    );
  }
}
