class User {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String aadhar;
  String message;
  String chatId;
  String profileImage;
  User();
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'aadhar': aadhar
      };
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        id = json['id'],
        phone = json['phone'],
        aadhar = json['aadhar'],
        profileImage = json['profileImage'];
}
