import 'package:flutter/material.dart';
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/messagingModule/widget/chatDashboardCard.dart';
import 'package:lost_and_found_web/widget/sideMenu.dart';
import 'package:lost_and_found_web/constants/constants.dart';

class ChatDashboard extends StatefulWidget {
  ChatDashboard({this.chatUsers, this.user});
  final List<ChatUser> chatUsers;
  final User user;
  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> {
  User user;
  List<ChatUser> chatUsers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.user = widget.user;
    this.chatUsers = widget.chatUsers;
  }

  List<Widget> getCard() {
    List<Widget> cards = List();
    if (chatUsers != null && chatUsers.length == 0) {
      Container txt = Container(
          padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10),
          child: Text("No User for chat invite friends",
              style: kAppNameStyle.copyWith(color: Colors.green[900])));
      cards.add(txt);
    } else
      this.chatUsers.forEach((chatUser) {
        if (chatUser.email != user.email)
          cards.add(ChatDashboardCard(
            chatUser: chatUser,
            user: user,
          ));
      });
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5DDD5),
      drawer: NavDrawer(
        user: user,
      ),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text("Chat")),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: getCard(),
        ),
      ),
    );
  }
}
