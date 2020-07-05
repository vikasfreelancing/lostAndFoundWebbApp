import 'package:flutter/material.dart';
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/messagingModule/screens/contactDetails.dart';
import 'package:lost_and_found_web/model/lostItemDetails.dart' as model;
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/services/userService.dart';
import 'package:lost_and_found_web/widget/mylostcard.dart';

class LostItemDetails extends StatefulWidget {
  LostItemDetails({this.lostItemDetails});
  final model.LostItemDetailsModel lostItemDetails;
  @override
  _LostItemDetailsState createState() => _LostItemDetailsState();
}

class _LostItemDetailsState extends State<LostItemDetails> {
  model.LostItemDetailsModel lostItemDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.lostItemDetails = widget.lostItemDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Details of Found Item ",
                style: kAppNameStyle.copyWith(
                    color: Colors.green[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.all(5),
              height: 400,
              child: Card(
                color: Color(0xFFE2DFFE),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: ListTile(
                          leading: Icon(Icons.message),
                          title: Text(
                            'Founded by ${lostItemDetails.user.name}',
                            style: TextStyle(
                                color: Colors.purple[900],
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${lostItemDetails.lostItem.createdAt}',
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Image.network(
                                      lostItemDetails.foundItem.images),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: ButtonBar(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Image matched with request ",
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 10),
                                ),
                                FlatButton(
                                  child: Text(
                                    'CONTACT DETAILS',
                                    style: TextStyle(
                                        color: Colors.purple[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    ChatUser chatUser = ChatUser();
                                    chatUser.id = lostItemDetails.foundUser.id;
                                    /*  String id;
                                              String name;
                                              String email;
                                              String password;
                                              String phone;
                                              String aadhar;
                                              String message;
                                              String chatId;
                                              String lastMessage;
                                              Timestamp last;
                                              String profileImage;*/
                                    chatUser.name =
                                        lostItemDetails.foundUser.name;
                                    chatUser.email =
                                        lostItemDetails.foundUser.email;
                                    chatUser.password =
                                        lostItemDetails.foundUser.password;
                                    chatUser.phone =
                                        lostItemDetails.foundUser.phone;
                                    chatUser.aadhar =
                                        lostItemDetails.foundUser.aadhar;
                                    chatUser.chatId =
                                        lostItemDetails.foundUser.chatId;
                                    chatUser.profileImage =
                                        lostItemDetails.foundUser.profileImage;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContactDetails(
                                                  user: lostItemDetails.user,
                                                  chatUser: chatUser,
                                                )));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Details of Lost Item ",
                style: kAppNameStyle.copyWith(
                    color: Colors.red[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: MyLostCard(
              item: lostItemDetails.lostItem,
              viewDetails: false,
            ),
          )
        ],
      )),
    );
  }
}
