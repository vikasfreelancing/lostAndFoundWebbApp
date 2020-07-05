import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_web/model/findItem.dart';

class MyFoundCard extends StatefulWidget {
  MyFoundCard({this.item});
  final FoundItem item;
  @override
  _MyFoundCardState createState() => _MyFoundCardState();
}

class _MyFoundCardState extends State<MyFoundCard> {
  FoundItem item;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        child: Card(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text('Posted by ${item.userId}'),
                subtitle: Text('${item.createdAt}'),
              ),
              Container(
                child: Image.network(item.images),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
