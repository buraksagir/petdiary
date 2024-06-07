class Message {
  String? senderId;
  String? receiverId;
  String? message;
  String? timestamp;

  Message({this.senderId, this.receiverId, this.message, this.timestamp});

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['message'] = message;
    data['timestamp'] = timestamp;
    return data;
  }
}
