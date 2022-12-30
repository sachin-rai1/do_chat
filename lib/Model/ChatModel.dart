import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  ChatModel({
    this.toId,
    this.msg,
    this.read,
    this.fromId,
    this.type,
    this.sent,
  });

  String? toId;
  String? msg;
  String? read;
  String? fromId;
  Type? type;
  String? sent;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    toId: json["toId"],
    msg: json["msg"],
    read: json["read"],
    fromId: json["FromId"],
    type: json["type"] ==  Type.image.name ? Type.image :Type.text,
    sent: json["sent"],
  );

  Map<String, dynamic> toJson() => {
    "toId": toId,
    "msg": msg,
    "read": read,
    "FromId": fromId,
    "type": type?.name,
    "sent": sent,
  };
}
enum Type{
  text , image
}
