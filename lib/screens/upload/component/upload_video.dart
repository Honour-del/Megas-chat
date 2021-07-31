import 'dart:io';
import 'package:flutter/material.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;
import 'package:megas_chat/utils/utilities.dart';
import 'package:uuid/uuid.dart';

import 'upload_components.dart';

class UploadVideo extends StatefulWidget {
  // get  video => _video;

  // const UploadVideo({Key? key}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();

  takeVideo(BuildContext context) {}
}

class _UploadVideoState extends State<UploadVideo> {
  File _video;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return displayUploadVideoScreen();
  }

  displayUploadVideoScreen() {
    return Scaffold(
      appBar: AppBar(title: Text("Mega Posts", style: TextStyle(fontSize: 24, color: WHITE_COLOR, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: WHITE_COLOR,
            ),
            onPressed: clearVideoPostInfo),
        actions: [
          FlatButton(
            onPressed: uploading ? null : ()  => handleSubmitVideo(),
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
                child: GestureDetector(
                  onDoubleTap: onTap,
                  onTap: onTapUploadView,
                  // child: AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,child: VideoPlayer(_videoPlayerController)),
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).cardTheme.color,
              backgroundImage: AssetImage('assets/photo.png'),
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


  compressingVideo() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image nVideoFile = ImD.decodeImage(_video.readAsBytesSync());
    final compressedVideoFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(nVideoFile, quality: 65));//this can be increased and decreased later
    setState(() {                                                // it depends on the space of the cloud use bvy the app
      _video = compressedVideoFile;
    });
  }

  clearVideoPostInfo() {
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      _video = null;
    });
  }

  controlUploadAndSaveVideo() async {
    setState(() {
      uploading = true;
    });
    // await compressingPhoto();
    String downloadUrl = await Uploads().uploadVideo(_video);
    Uploads.createPostInFireStore(mediaUrl: downloadUrl, caption: descriptionTextEditingController.text, location: locationTextEditingController.text);
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      _video = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }


  handleSubmitVideo() async {
    setState(() {
      uploading = true;
    });
    await compressingVideo();
    String mediaUrl = await Uploads().uploadVideo(_video);
    Uploads.createPostInFireStore(
      mediaUrl: mediaUrl,
      caption: descriptionTextEditingController.text,
      location: locationTextEditingController.text,
    );
    descriptionTextEditingController.clear();
    locationTextEditingController.clear();
    setState(() {
      _video = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  _pickVidFromGallery() async{
    // PickedFile pickedFile = await _picker.getVideo(source: ImageSource.gallery);
    // _video = File(pickedFile.path);
    // _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
    //   setState(() {});
    //     _videoPlayerController.play();
    // });
  }

  _pickVidFromCamera() async{
    // PickedFile pickedFile = await _picker.getVideo(source: ImageSource.camera);
    // _video = File(pickedFile.path);
    // _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
    //   setState(() {});
    //     _videoPlayerController.play();
    // });
  }

   takeVideo(vContext) {
    return showDialog(
      context: vContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Post",
            style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "Capture Video",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: _pickVidFromCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select Video From Gallery",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: _pickVidFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: BLACK_COLOR),
              ),
              onPressed: cancelIt,
            ),
          ],
        );
      },
    );
  }

  cancelIt(){
    Navigator.pop(context);
  }

  onTapUploadView(){
    return Center(
      child: InteractiveViewer(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          // child: AspectRatio(
          //   aspectRatio:  _videoPlayerController.value.aspectRatio,child: VideoPlayer(_videoPlayerController),
          // ),
        ),
      ),
    );
  }


  onTap() {
    // return GestureDetector(
    //   onTap: (){
    //     setState(() {
    //       if(_videoPlayerController.value.isPlaying){
    //         //pause the video while playing
    //         _videoPlayerController.pause();
    //       }else{
    //         //play the video while it is paused
    //         _videoPlayerController.play();
    //       }
    //     });
    //   },
    //   child: Icon(_videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
    // );
  }

}
