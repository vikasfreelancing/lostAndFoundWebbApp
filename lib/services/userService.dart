import 'package:http/http.dart' as http;
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'dart:convert' as decoder;
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/dto/chatMapping.dart';

class UserService {
  String data;
  int responseCode;
  Future<User> registerUser(User user) async {
    print(decoder.jsonEncode(user.toJson()));
    http.Response response = await http.post(
      userPlatformbaseUrl + 'user/register',
      body: decoder.jsonEncode(user.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response code : " + responseCode.toString());

    if (responseCode == 441) {
      User temp = User();
      temp.message = "Email Already in use ";
      return temp;
    }

    if (responseCode == 200 && response != null && response.body != null) {
      data = response.body;
      print("response : " + data);
      User user = User.fromJson(decoder.json.decode(data));
      user.message = "Registered sucessfully";
      return user;
    } else
      return null;
  }

  Future<User> loginUser(String email, String password) async {
    print("User Email :" + email);
    print("User Password :" + password);
    http.Response response = await http.post(
      userPlatformbaseUrl + 'user/login',
      body: decoder
          .jsonEncode({'email': email.trim(), 'password': password.trim()}),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response Code : " + responseCode.toString());
    if (responseCode == 200 && response.body != null) {
      data = response.body;
      print("Response Body : " + data);
      if (response == null || data == null) return null;
      try {
        User user = User.fromJson(decoder.json.decode(data));
      } on Exception {
        return null;
      }
      return User.fromJson(decoder.json.decode(data));
    } else
      return null;
  }

  Future<List<ChatUser>> getAllUsers(String email) async {
    print(" Calling get All Users Service");
    String url = userPlatformbaseUrl + 'user/all?email=' + email;
    http.Response response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("Response get All Users : " + response.body);
      List<ChatUser> items = (decoder.json.decode(response.body) as List)
          .map((i) => ChatUser.fromJson(i))
          .toList();
      return items;
    } else
      return null;
  }

  Future<ChatMapping> createMapping(
      String firstEmail, String secondEmail) async {
    print("First  Email :" + firstEmail);
    print("secound  Email :" + secondEmail);
    http.Response response = await http.post(
      userPlatformbaseUrl + 'user/createChatMapping',
      body: decoder.jsonEncode(
          {'firstEmail': firstEmail.trim(), 'secondEmail': secondEmail.trim()}),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response Code : " + responseCode.toString());
    if (responseCode == 200 && response.body != null) {
      data = response.body;
      print("Response Body : " + data);
      return ChatMapping.fromJson(decoder.json.decode(data));
    } else
      return null;
  }

  Future<User> saveProfileImage(String email, String imageUrl) async {
    print("email :" + email);
    print("Image Url  :" + imageUrl);
    http.Response response = await http.post(
      userPlatformbaseUrl + 'user/saveProfileImage',
      body: decoder
          .jsonEncode({'profileImage': imageUrl.trim(), 'email': email.trim()}),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response Code : " + responseCode.toString());
    if (responseCode == 200 && response.body != null) {
      data = response.body;
      print("Response Body : " + data);
      return User.fromJson(decoder.json.decode(data));
    } else
      return null;
  }
}
