import 'package:http/http.dart' as http;
import 'package:lost_and_found_web/dto/User.dart';
import 'dart:convert' as decoder;
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/model/findItem.dart';
import 'package:lost_and_found_web/model/LostItem.dart';
import 'package:lost_and_found_web/model/lostItemDetails.dart';

class ItemService {
  String data;
  int responseCode;
  Future<void> saveLostItem(User user, List<String> images) async {
    String url = "";
    for (String s in images) url += s + ",";
    print("Saving lost items with image urls : " + url);
    String endPoint = userPlatformbaseUrl + 'items/lost/save';
    print("endpoint : " + endPoint);
    print(decoder.jsonEncode(user.toJson()));
    http.Response response = await http.post(
      endPoint,
      body: decoder
          .jsonEncode({'images': url, 'userId': user.id, 'type': 'person'}),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response code: " + responseCode.toString());
    if (responseCode == 200) {
      data = response.body;
      print("Response : " + data);
    }
  }

  Future<void> saveFoundItem(User user, String url) async {
    print("saving found image in item service with url : " + url);
    print(decoder.jsonEncode(user.toJson()));
    http.Response response = await http.post(
      userPlatformbaseUrl + 'items/found/save',
      body: decoder
          .jsonEncode({'images': url, 'userId': user.id, 'type': 'person'}),
      headers: {"Content-Type": "application/json"},
    );
    responseCode = response.statusCode;
    print("Response Code : " + responseCode.toString());
    if (responseCode == 200) {
      data = response.body;
      print("Response body :" + data);
    }
  }

  Future<List<LostItem>> getLostItems(String userId) async {
    print(" Calling getLost Item Service");
    String url = (userId == null)
        ? userPlatformbaseUrl + 'items/lost/items'
        : userPlatformbaseUrl + 'items/lost/items?user_id=' + userId;
    http.Response response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200 && response.body != null) {
      print("Response get Lost Items : " + response.body);
      List<LostItem> items = (decoder.json.decode(response.body) as List)
          .map((i) => LostItem.fromJson(i))
          .toList();
      return items;
    } else
      return null;
  }

  Future<List<FoundItem>> getFoundItems(String userId) async {
    print(" Calling getFound Item Service");
    String url = (userId == null)
        ? userPlatformbaseUrl + 'items/found/items'
        : userPlatformbaseUrl + 'items/found/items?user_id=' + userId;
    http.Response response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("Response get Found Items : " + response.body);
      List<FoundItem> items = (decoder.json.decode(response.body) as List)
          .map((i) => FoundItem.fromJson(i))
          .toList();
      return items;
    } else
      return null;
  }

  Future<LostItemDetailsModel> getLostItemDetails(String itemId) async {
    if (itemId == null) return null;
    String url =
        userPlatformbaseUrl + 'items/lost/item/details?item_id=' + itemId;
    http.Response response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("Response get Lost Item Details : " + response.body);
      LostItemDetailsModel lostItemDetails =
          LostItemDetailsModel.fromJson(decoder.json.decode(response.body));
      return lostItemDetails;
    } else
      return null;
  }
}
