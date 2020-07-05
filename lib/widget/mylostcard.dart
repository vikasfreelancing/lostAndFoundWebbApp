import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_web/model/LostItem.dart';
import 'package:lost_and_found_web/model/lostItemDetails.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/services/itemService.dart';
import 'package:lost_and_found_web/widget/lostItemDetails.dart';

class MyLostCard extends StatefulWidget {
  MyLostCard({this.item, this.viewDetails});
  final LostItem item;
  final bool viewDetails;
  @override
  _MyLostCardState createState() => _MyLostCardState();
}

class _MyLostCardState extends State<MyLostCard> {
  LostItem item;
  bool viewDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.item = widget.item;
    this.viewDetails = widget.viewDetails;
  }

  void showDetails(LostItem lostItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadingScreen(
                  message: "Getting Details",
                  task: () async {
                    LostItemDetailsModel lostItemDetails =
                        await ItemService().getLostItemDetails(lostItem.id);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LostItemDetails(
                                  lostItemDetails: lostItemDetails,
                                )));
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      '${item.createdAt}',
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    )),
                    Center(
                      child: Container(
                        child: Image.network(item.images),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: ButtonBar(
                    children: <Widget>[
                      Text(
                        (item != null && item.found != null && item.found)
                            ? "This Item is Founded "
                            : "This Item not yet founded",
                        style: TextStyle(color: Colors.purple, fontSize: 10),
                      ),
                      FlatButton(
                        disabledTextColor: Colors.purple[50],
                        child: Text(
                          'VIEW DETAILS',
                          style: TextStyle(
                              color: Colors.purple[900],
                              fontSize: 10,
                              fontWeight: (viewDetails &&
                                      item != null &&
                                      item.found != null &&
                                      item.found)
                                  ? FontWeight.bold
                                  : FontWeight.w200),
                        ),
                        onPressed: (viewDetails &&
                                item != null &&
                                item.found != null &&
                                item.found)
                            ? () {
                                showDetails(this.item);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
