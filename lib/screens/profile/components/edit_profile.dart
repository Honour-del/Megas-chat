//import 'package:cached_network_image/cached_network_image.dart';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImD;
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/auth_services.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/sizeConfig.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../home_view.dart';

class EditProfile extends StatefulWidget {
  static final routeName = "/Edit_Profile";
  final String currentUserId;

  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  Users user;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }
  //
  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersReference.doc(widget.currentUserId).get();
    Map<String, dynamic> _docdata = doc.data as Map<String, dynamic>;
    user = Users.fromDocument(doc, _docdata);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Display Name',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: 'Update Display Name',
              errorText:
              _displayNameValid ? null : 'Display Name is too short'),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Bio',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update Bio',
            errorText: _bioValid ? null : 'Bio too long',
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
          displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100 || bioController.text.isEmpty
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      usersReference.doc(widget.currentUserId).update({
        'displayName': displayNameController.text,
        'bio': bioController.text,
        'photoUrl': _image,
      });
      print(displayNameController.text);
      print(bioController.text);
      SnackBar snackbar = SnackBar(content: Text('Profile updated !'));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _image != null ? AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () async{
              await updateProfileData();
              Navigator.pushAndRemoveUntil(
                  context,
                  BouncyPageRoute(widget: HomePage()),
                      (route) => false);
            }
          ),
        ],
      ) : customAppBar(),
      body:ListView(// isLoading ? circularProgress() :
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(10), bottom: getProportionateScreenHeight(8)),
                child: _image == null ? GestureDetector(
                  onTap: () => takeImage(context),
                  child: CircleAvatar(
                    backgroundImage: user.photoUrl.isEmpty || _image == null ? AssetImage('assets/photo.png') : CachedNetworkImage(imageUrl: user.photoUrl),
                     //backgroundImage: CachedNetworkImageProvider(currentUser.photoUrl),
                    // CachedNetworkImageProvider(user?.rl),
                    radius: 50,
                  ),
                ) : customOnNull(),
              ),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(16), right: getProportionateScreenWidth(16),
                  top: getProportionateScreenHeight(16), bottom: getProportionateScreenHeight(16)
                ),
                child: Column(
                  children: <Widget>[
                    buildDisplayNameField(),
                    buildBioField(),
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: updateProfileData,
                child: Text(
                  'Update Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20),),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: AuthService.logout,
                child: Text(
                  'LogOut',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  File _image;
  String images;
  bool uploading = false;
  String pProfId = Uuid().v4();
  Future getImageFromGallery() async {
    var image = await _picker.getImage(
        source:  ImageSource.gallery,
    );
    File theImage = File(image.path);
    setState(() {
      this._image = theImage;
      print("Image Path $_image");
    });
  }

  ImagePicker _picker = ImagePicker();
  Future getImageFromCamera() async {
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 700,
    );
    File image = File(pickedFile.path);
    setState(() {
      this._image = image;
    });
  }

  Future uploadProfilePic(BuildContext context,) async{
    Reference profileReference = FirebaseStorage.instance.ref().child(('post_$images.jpg'));
    UploadTask uploadTask = profileReference.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;//.whenComplete(() => profileReference);
    await taskSnapshot.ref.getDownloadURL();
    setState(() {
      displayToastMessage("Profile picture is successfully uploaded", context);
    });
  }

  handleSubmit() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String mediaUrl = await uploadProfilePic(context);
    createPostInFireStore(
      photoURL: mediaUrl,
    );
    setState(() {
      _image = null;
      uploading = false;
      pProfId = Uuid().v4();
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await uploadProfilePic(context);

    createPostInFireStore(photoURL: downloadUrl, );
    setState(() {
      _image = null;
      uploading = false;
      pProfId = Uuid().v4();
    });
  }

  createPostInFireStore({ String photoURL, String location, String caption}) {
    //currentUser = Users(uid: currentUser?.uid);
    FirebaseFirestore.instance
        .doc(widget.currentUserId)
        .collection('users')
        .doc(pProfId)
        .set({
      'url': photoURL,
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image nImageFile = ImD.decodeImage(_image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$images.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(nImageFile, quality: 80));//this can be increased and decreased later
    setState(() {                                                // it depends on the space of the cloud use bvy the app
      _image = compressedImageFile;
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
              onPressed: getImageFromCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image From Gallery",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: getImageFromGallery,
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

  customOnNull(){
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          uploading ? linearProgress() : Text(""),
          SizedBox(height: 10,),
          ClipOval(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black26,
                  child: Image.file(_image,fit: BoxFit.cover,)
              ),
            ),
          )
        ],
      ),
    );
  }

  customAppBar(){
    return AppBar(
      backgroundColor: DARK_PURPLE_COLOR,
      // leading: Icon(Icons.arrow_back),
      title: Text("Mega CHATz", style: TextStyle(color: WHITE_COLOR, fontSize: 30),),
      actions: [
        IconButton(icon: Icon(Icons.send,size: 20, color: WHITE_COLOR,), onPressed: uploading ? null : ()  => handleSubmit(),),
      ],
    );
  }


}
//isLoading
//           ? circularProgress()
//           :