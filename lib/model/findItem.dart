class FoundItem {
  String id;
  String images;
  String userId;
  String type;
  String createdAt;
  String modifiedAt;
  Map<String, dynamic> toJson() => {
        'id': id,
        'images': images,
        'userId': userId,
        'type': type,
        'createdAt': createdAt,
        'modifiedAt': modifiedAt
      };
  FoundItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        images = json['images'],
        userId = json['userId'],
        type = json['type'],
        createdAt = json['createdAt'],
        modifiedAt = json['modifiedAt'];
}
