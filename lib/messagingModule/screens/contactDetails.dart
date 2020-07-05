import 'package:flutter/material.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/dto/chatMapping.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/services/userService.dart';
import 'package:lost_and_found_web/widget/sideMenu.dart';
import 'package:lost_and_found_web/dto/ChatUser.dart';
import 'package:lost_and_found_web/messagingModule/screens/chat_screen.dart';

class ContactDetails extends StatefulWidget {
  ContactDetails({this.user, this.chatUser});
  final ChatUser chatUser;
  final User user;
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  ChatUser chatUser;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.user = widget.user;
    this.chatUser = widget.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(fontSize: 15, color: Colors.grey);
    TextStyle _textFieldStyle = TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: (chatUser.profileImage == null)
                    ? CircleIcon()
                    : CircleImage(
                        imageUrl: chatUser.profileImage,
                      )),
            Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Name:",
                          style: _textStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        chatUser.name,
                        style: _textFieldStyle,
                      ),
                    )
                  ],
                )),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Email:",
                        style: _textStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      chatUser.email,
                      style: _textFieldStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Phone:",
                        style: _textStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      chatUser.phone,
                      style: _textFieldStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "AADHAAR:",
                        style: _textStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      chatUser.aadhar,
                      style: _textFieldStyle,
                    ),
                  )
                ],
              ),
            ),
            (user.email != chatUser.email)
                ? Expanded(
                    flex: 1,
                    child: Center(
                      child: FlatButton(
                        child: Text(
                          "Send Message",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          if (chatUser.chatId != null) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    user: user,
                                    chatUser: chatUser,
                                  ),
                                ));
                          } else {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoadingScreen(
                                          message: "Preparing chat",
                                          task: () async {
                                            ChatMapping chatMapping =
                                                await UserService()
                                                    .createMapping(user.email,
                                                        chatUser.email);
                                            Navigator.pop(context);
                                            if (chatMapping != null) {
                                              chatUser.chatId = chatMapping.id;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                            user: user,
                                                            chatUser: chatUser,
                                                          )));
                                            }
                                          },
                                        )));
                          }
                        },
                        color: Colors.grey[50],
                      ),
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: Text(""),
                  )
          ],
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
    double _size = 200.0;
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

class CircleIcon extends StatelessWidget {
  CircleIcon({this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    double _size = 150.0;

    return Center(
      child: new Container(
        child: FlatButton(
          child: Icon(Icons.message),
        ),
        width: _size,
        height: _size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}
