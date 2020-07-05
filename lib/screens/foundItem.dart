import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as UI;
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/facedetection/facepainter.dart';
import 'package:lost_and_found_web/services/itemService.dart';
import 'package:lost_and_found_web/services/uploadService.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:lost_and_found_web/widget/sideMenu.dart';
import 'loading.dart';
import 'deshboard.dart';
/*
* Item Service base url https://itemservice.herokuapp.com
* */

class FoundItem extends StatefulWidget {
  FoundItem(
      {this.user,
      this.image,
      this.customPainter,
      this.decodeImage,
      this.faces,
      this.message});
  final User user;
  final File image;
  final CustomPainter customPainter;
  final UI.Image decodeImage;
  final List<Face> faces;
  final String message;
  @override
  _FoundItemState createState() => _FoundItemState();
}

class _FoundItemState extends State<FoundItem> {
  @override
  void initState() {
    super.initState();
    this.user = widget.user;
    this.decodeImage = widget.decodeImage;
    this.faces = widget.faces;
    this.image = widget.image;
    this.message = widget.message;
  }

  _FoundItemState({this.user});
  User user;
  UI.Image decodeImage;
  File image;
  List<Face> faces;
  String message;
  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.green[900]);
  UploadService uploadService = UploadService();
  TextStyle styleCountGreen = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 30.0,
    color: Colors.green[900],
  );

  Widget get() {
    if (image == null) return null;
    List<Widget> I = List<Widget>();
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: SizedBox(
              width: decodeImage.width.toDouble(),
              height: decodeImage.height.toDouble(),
              child: CustomPaint(
                painter: FacePainter(decodeImage, faces),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  image = null;
                });
              },
              child: Icon(
                Icons.close,
                color: Colors.red[300],
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }

  TextStyle styleCountRed = TextStyle(
      fontFamily: 'Montserrat', fontSize: 30.0, color: Colors.red[900]);
  Future getImageFromCamera() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
              message: "Uploading Camera ",
              task: () async {
                File image = await ImagePicker.pickImage(
                    source: ImageSource.camera, maxWidth: 300, maxHeight: 400);
                this.image = image;
                final FirebaseVisionImage visionImage =
                    FirebaseVisionImage.fromFile(image);
                final FaceDetector faceDetector =
                    FirebaseVision.instance.faceDetector();
                List<Face> faces = await faceDetector.processImage(visionImage);
                this.faces = faces;
                String message = "";
                if (faces.length == 0) {
                  this.image = null;
                  print("No face found in image");
                  message = "No face found in image";
                } else {
                  UI.Image decodeImage =
                      await decodeImageFromList(image.readAsBytesSync());
                  this.decodeImage = decodeImage;
                  for (var face in faces) {
                    print(face.rightEyeOpenProbability);
                  }
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoundItem(
                      user: this.user,
                      image: this.image,
                      decodeImage: this.decodeImage,
                      faces: this.faces,
                      message: message,
                    ),
                  ),
                );
              }),
        ));
  }

  Future<void> upload() async {
    if (image == null) {
      print("No image selected");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoadingScreen(
                message: "Saving Image",
                task: () async {
                  dynamic s = await uploadService.uploadFile(image);
                  String imageUrl = s.toString();
                  print("calling item Service");
                  ItemService itemService = ItemService();
                  print(imageUrl);
                  await itemService.saveFoundItem(user, imageUrl);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoard(
                                user: user,
                                message:
                                    "Found Item Saved Successfully Wil Get in touch soon ",
                                color: Colors.green[900],
                              )));
                },
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(user.id);
    final uploadButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          print("uploading");
          await upload();
        },
        child: Text("Upload",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Color(0xff685EF2), fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      drawer: NavDrawer(
        user: user,
      ),
      appBar: AppBar(
        title: Text('Add new Lost Item'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Center(
                child: (image == null)
                    ? Text(
                        (message == null)
                            ? "Please Select Images of found Item"
                            : message,
                        style: style,
                      )
                    : Text(
                        "Image Selected Sucessfully",
                        style: style,
                      )),
          ),
          Expanded(
            flex: 8,
            child: image == null
                ? Center(
                    child: Text(
                      "No Image selected",
                      style: styleCountRed,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[get()],
                    ),
                  ),
          ),
          Expanded(
            flex: 5,
            child: Center(
                child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  child: uploadButton,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: getImageFromCamera,
                    child: Icon(
                      Icons.camera,
                      size: 50,
                    ),
                  ),
                ),
              ],
            )),
          )
        ],
      )),
    );
  }
}
