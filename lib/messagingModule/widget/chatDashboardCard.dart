import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/dto/chatMapping.dart';
import 'package:lost_and_found_web/messagingModule/screens/chat_screen.dart';
import 'package:lost_and_found_web/notifications/registerNotification.dart';
import 'package:lost_and_found_web/services/userService.dart';

class ChatDashboardCard extends StatefulWidget {
  ChatDashboardCard({this.user, this.chatUser});
  final User user;
  final ChatUser chatUser;
  @override
  _ChatDashboardCardState createState() => _ChatDashboardCardState();
}

class _ChatDashboardCardState extends State<ChatDashboardCard> {
  User user;
  ChatUser chatUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    chatUser = widget.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("I taped");
        if (chatUser.chatId != null) {
          var res = await Firestore.instance
              .collection('users')
              .where('email', isEqualTo: user.email)
              .getDocuments();
          String docId = res.documents.first.documentID;
          await Firestore.instance
              .collection('users')
              .document(docId)
              .updateData({'chattingWith': chatUser.email});
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(user: user, chatUser: chatUser, docId: docId),
              ));
        }
      },
      child: Center(
        child: Container(
          height: 100,
          child: Card(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: (chatUser.profileImage == null)
                        ? Center(
                            child: CircleAvatar(
                              radius: 30,
                              child: Image.asset("images/no_image.png"),
                            ),
                          )
                        : Stack(
                            children: <Widget>[
                              Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              )),
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          NetworkImage(chatUser.profileImage),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              chatUser.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              chatUser.lastMessage,
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w200),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: (chatUser.chatId != null)
                        ? Text(
                            TimeOfDay.fromDateTime(chatUser.last.toDate())
                                    .hour
                                    .toString() +
                                ":" +
                                TimeOfDay.fromDateTime(chatUser.last.toDate())
                                    .minute
                                    .toString(),
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w200),
                          )
                        : FlatButton(
                            child: Text(
                              "Invite",
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                            onPressed: () async {
                              print("Inviting");
                              ChatMapping chatMapping = await UserService()
                                  .createMapping(user.email, chatUser.email);
                              if (chatMapping != null) {
                                setState(() {
                                  chatUser.lastMessage = "Lets start chat";
                                  chatUser.chatId = chatMapping.id;
                                });
                              }
                            },
                          ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  CircleImage({this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    double _size = 60.0;
    return Center(
      child: new Container(
        width: _size,
        height: _size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
