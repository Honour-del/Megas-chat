class ChatMessage {
  String key;
  String senderId;
  String message;
  bool seen;
  String createdAt;
  String timeStamp;


  String senderName;
  String receiverId;

  ChatMessage({
    this.key,
    this.senderId,
    this.message,
    this.seen,
    this.createdAt,
    this.receiverId,
    this.senderName,
    this.timeStamp
  });

  factory ChatMessage.fromDoc(Map<dynamic, dynamic> doc) => ChatMessage(
      key: doc["key"],
      senderId: doc["sender_id"],
      message: doc["message"],
      seen: doc["seen"],
      createdAt: doc["created_at"],
      timeStamp:doc['timeStamp'],
      senderName: doc["senderName"],
      receiverId: doc["receiverId"]
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "sender_id": senderId,
    "message": message,
    "receiverId": receiverId,
    "seen": seen,
    "created_at": createdAt,
    "senderName": senderName,
    "timeStamp":timeStamp
  };
}
