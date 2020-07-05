import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String aadhar;
  String message;
  String chatId;
  String lastMessage;
  Timestamp last;
  String profileImage;
  ChatUser();
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'aadhar': aadhar,
        'chatId': chatId,
      };
  ChatUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        id = json['id'],
        phone = json['phone'],
        chatId = json['chatId'],
        profileImage = json['profileImage'];
}
