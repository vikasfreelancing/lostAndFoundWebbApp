import 'package:flutter/material.dart';
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/model/LostItem.dart';
import 'package:lost_and_found_web/screens/deshboard.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/services/itemService.dart';
import 'package:lost_and_found_web/widget/mylostcard.dart';
import 'package:lost_and_found_web/widget/sideMenu.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/constants/message_constants.dart';
import 'package:transparent_image/transparent_image.dart';

class LostItemView extends StatefulWidget {
  LostItemView({this.items, this.user});
  final List<LostItem> items;
  final User user;
  @override
  _LostItemViewState createState() => _LostItemViewState();
}

class _LostItemViewState extends State<LostItemView> {
  var messageConstants = MessageConstants();
  List<LostItem> items;
  User user;
  void loadData() async {
    Navigator.pop(context);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    items = widget.items;
    user = widget.user;
    if (items == null) {
      loadData();
    }
  }

//  void X() async {
//    User user = await UserService().loginUser("1", "1");
//    await ItemService().getLostItems(user.id);
//  }
//
//  void Y() async {
//    User user = await UserService().loginUser("1", "1");
//    await ItemService().getFoundItems(user.id);
//  }

  List<Widget> getCard() {
    List<Widget> cards = List();
    if (items != null && items.length == 0) {
      Container txt = Container(
          padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10),
          child: Text(messageConstants.NO_REQUESTS,
              style: kAppNameStyle.copyWith(color: Colors.green[900])));
      cards.add(txt);
    } else
      this.items.forEach((lostItem) {
        cards.add(MyLostCard(
          item: lostItem,
          viewDetails: true,
        ));
      });
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        user: user,
      ),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text("Dash Board ")),
            Expanded(
                child: Container(
              width: 30,
              height: 30,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color(0xFFFB9932),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoard(
                                user: user,
                              )));
                },
              ),
            ))
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
