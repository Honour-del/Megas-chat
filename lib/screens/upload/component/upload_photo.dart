import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:megas_chat/screens/upload/component/upload_components.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:uuid/uuid.dart';
import 'upload_components.dart';


class UploadPhoto extends StatefulWidget {
  static final routeName = '/upload_photo';

  final Users currentUser;
  UploadPhoto({this.currentUser});

  // get file => _file;

  // const UploadPhoto({Key? key}) : super(key: key);

  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() :displayUploadFormScreen();
  }

  displayUploadScreen() {
    return Scaffold(
      appBar: header(context, strTitle: "Upload", disappearedBackButton: false),
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                size: 200,
                color: Theme.of(context).appBarTheme.color,
              ),
              imgButt(),
              SizedBox(height: 60,),
              // vidButt(),
            ],
          ),
        ),
      ),
    );
  }
  imgButt(){
    return Padding(
      padding:
      EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9)),
        child: Text(
          "upload image",
          style: TextStyle(color: WHITE_COLOR, fontSize: 20),
        ),
        color: Theme.of(context).appBarTheme.color,
        onPressed: () => takeImage(context),
      ),
    );
  }
  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(title: Text("Mega Posts", style: TextStyle(fontSize: 24, color: WHITE_COLOR, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: WHITE_COLOR,
            ),
            onPressed: clearImagePostInfo),
        actions: [
          TextButton(
            onPressed: uploading ? null : ()  => handleSubmit(),
            //uploading ? null : () => controlUploadAndSave(),
            child: Text(
              "Share",
              style: TextStyle(color: WHITE_COLOR, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
              height: 230,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      )),
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).cardTheme.color,
              backgroundImage: AssetImage(picture),
              // backgroundImage: currentUser.photoUrl.isEmpty
              //     ? AssetImage('assets/photo.jpeg')
              //     : CachedNetworkImageProvider(currentUser.photoUrl),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: BLACK_COLOR),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Put some comment on your post",
                  hintStyle: TextStyle(
                    color: BLACK_COLOR,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_pin_circle, color: DARK_PURPLE_COLOR, size: 36,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: BLACK_COLOR),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Display your location here",
                  //hintStyle: TextStyle(color: BLACK_COLOR,),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  clearImagePostInfo() {
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image nImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(nImageFile, quality: 75));//this can be increased and decreased later
    setState(() {                                                // it depends on the space of the cloud use bvy the app
      file = compressedImageFile;
    });
  }


  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await Uploads.uploadPhoto(file);

    Uploads.createPostInFireStore(mediaUrl: downloadUrl, caption: descriptionTextEditingController.text, location: locationTextEditingController.text);

    locationTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }


  handleSubmit() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String mediaUrl = await Uploads.uploadPhoto(file);
    Uploads.createPostInFireStore(
      mediaUrl: mediaUrl,
      caption: descriptionTextEditingController.text,
      location: locationTextEditingController.text,
    );
    descriptionTextEditingController.clear();
    locationTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  ImagePicker _picker = ImagePicker();
  captureImageWithCamera() async {
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 700,
    );
    File image = File(pickedFile.path);
    setState(() {
      this.file = image;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    PickedFile pickedFile  = await _picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 970,
    );
    File image = File(pickedFile.path);
    setState(() {
      file = image;
    });
  }

  cancel() {
    Navigator.pop(context);
  }

     takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Post",
            style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "Capture Image",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image From Gallery",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: cancel,
            ),
          ],
        );
      },
    );
  }
}
