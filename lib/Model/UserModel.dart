import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.image,
    this.name,
    this.about,
    this.createdAt,
    this.isOnline,
    this.lastActive,
    this.id,
    this.email,
    this.pushToken,
  });

  String? image;
  String? name;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? id;
  String? email;
  String? pushToken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    image: json["image"],
    name: json["name"],
    about: json["about"],
    createdAt: json["created_at"],
    isOnline: json["is_online"],
    lastActive: json["last_active"],
    id: json["id"],
    email: json["email"],
    pushToken: json["push_token"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "about": about,
    "created_at": createdAt,
    "is_online": isOnline,
    "last_active": lastActive,
    "id": id,
    "email": email,
    "push_token": pushToken,
  };
}
