class ChatMapping {
  String id;
  String firstEmail;
  String secondEmail;
  ChatMapping();

  ChatMapping.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstEmail = json['firstEmail'],
        secondEmail = json['secondEmail'];
}
