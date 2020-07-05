import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/messagingModule/screens/chatDashBoard.dart';
import 'package:lost_and_found_web/model/LostItem.dart';
import 'package:lost_and_found_web/screens/lostItemViewList.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/services/itemService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_web/services/userService.dart';
import 'package:lost_and_found_web/widget/profile.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({this.user});
  final User user;
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final _auth = FirebaseAuth.instance;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  void loadData() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          message: "Loading Data ",
          task: () async {
            List<LostItem> items = await ItemService().getLostItems(user.id);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LostItemView(
                          items: items,
                          user: user,
                        )));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('logo2.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          user: user,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('View Requests'),
            onTap: () {
              loadData();
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Chat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                            message: "Loading chat ",
                            task: () async {
                              List<ChatUser> chatUsers =
                                  await UserService().getAllUsers(user.email);
                              for (ChatUser chatUser in chatUsers) {
                                if (chatUser.chatId != null) {
                                  final messages = await Firestore.instance
                                      .collection('messages')
                                      .where('chatId',
                                          isEqualTo: chatUser.chatId)
                                      .orderBy('time', descending: true)
                                      .limit(1)
                                      .getDocuments();
                                  if (messages != null &&
                                      messages.documents.length > 0) {
                                    chatUser.lastMessage =
                                        messages.documents.first.data['text'];
                                    chatUser.last =
                                        messages.documents.first.data['time'];
                                  } else {
                                    chatUser.lastMessage = "Lets Start chat";
                                    chatUser.last = Timestamp.now();
                                  }
                                } else {
                                  chatUser.lastMessage =
                                      "Invite your friend to start chat ";
                                  chatUser.last = Timestamp.now();
                                }
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatDashboard(
                                            user: user,
                                            chatUsers: chatUsers,
                                          )));
                            },
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
