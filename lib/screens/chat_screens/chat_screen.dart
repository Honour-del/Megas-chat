
import 'dart:async';
import 'dart:io';
import 'dart:math';
// import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';
import 'package:megas_chat/models/call/call_utilities.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/cached_image.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart'as path;
// import 'package:image/image.dart' as ImD;
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megas_chat/models/messages.dart';
import 'package:megas_chat/models/resources/chat_methods.dart';
// import 'package:permission_handler/permission_handler.dart';
import '../home_view.dart';
import 'callscreens/strings.dart';
import 'callscreens/user_provider.dart';
import 'chat_page/component/chat_tile.dart';
import 'image_upload_provider.dart';
import 'storage_methods.dart';


class ChatScreen extends StatefulWidget {
  static final routeName = "/Chat_Screen";
  final String receiverId;
  final String currentUserId;


  final int index;
  final Map<String, dynamic> data;
  final bool showAvatar;



  ChatScreen({Key key,this.receiverId, this.index, this.data, this.currentUserId, this.showAvatar = true}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  static const int maxDuration = 120;//will change this later
  final StorageMethods _storageMethods = StorageMethods();
  ImageUploadProvider _imageUploadProvider;



  // void onEmojiSelected(Emoji emoji){
  //   textFieldEditingController.text = emoji.text;
  // }

  void clearText() => textFieldEditingController.text = "";

  TextEditingController textFieldEditingController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();
  UserProvider _repository = UserProvider(); // repository
  Users sender;
  Users receiver;
  final String currentUserId = currentUser?.id;

  bool isTyping = false;
  bool isLoading = false;
  bool showEmojiPicker = false;

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  ooo(){
    return PopupMenuButton(
        color: Theme.of(context).scaffoldBackgroundColor,
        icon: Icon(Icons.more_vert),
        initialValue: [1],
        itemBuilder: (ctx) => [
          PopupMenuItem(child: new Text("Search in text",style: Theme.of(context).textTheme.bodyText2)),
          PopupMenuItem(child: new Text("Wallpaper",style: Theme.of(context).textTheme.bodyText2)),
          PopupMenuItem(child: new Text("Clear chat",style: Theme.of(context).textTheme.bodyText2)),
          PopupMenuItem(child: new Text("Block",style: Theme.of(context).textTheme.bodyText2)),
        ]
    );
  }

  @override
  void initState() {
    super.initState();
    isRecording = false;
    remainingDuration = maxDuration;
    _repository.getCurrentUser().then((user) {
      // currentUserId = user.uid;
       setState(() {
         sender = Users(
           username: user.uid,
           displayName: user.displayName,
           photoUrl: user.photoURL,
         );
       });
    });
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  //the permission handler is not yet determined!1
  // Future<void> _handleCameraAndMic(Permission permission) async{
  //   final status =  await permission.request();
  //   return status;
  // }

  customAppBar(){
    return AppBar(
      elevation: 0.7,
      backgroundColor: Theme.of(context).appBarTheme.color,
      shadowColor:  PURPLE_COLOR,
      title: Text("name", style: TextStyle(color: WHITE_COLOR, fontSize: 24, fontWeight: FontWeight.bold),),
      centerTitle: false,
      automaticallyImplyLeading: true,
      leading: CircleAvatar(backgroundColor: BLACK_COLOR,
          backgroundImage: AssetImage(picture)),
      actions: [
        IconButton(icon: Icon(Icons.call, color: WHITE_COLOR,), onPressed: (){}),
        IconButton(icon: Icon(Icons.video_call, color: WHITE_COLOR,), onPressed: () async =>
         CallUtils.dial(
          from: sender,
          to: receiver,
          context: context,
        ),),
        ooo(),//the popMenu button
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: [
          Flexible(
            child: messageListView(),
          ),
          chatScreenControl(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container(),
        ],
      ),
    );
  }
  //the message view of the chat page
  Widget messageListView(){
    return StreamBuilder(
      stream: messageReference.doc(widget.currentUserId).collection(widget.receiverId).orderBy("timeStamp", descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.data == null){
          return Center(
            child: circularProgress(),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,  //8:58
          itemBuilder: (context, index){
            return chatMessages(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  postMess(){
    messageReference.doc(currentUserId)
        .collection("messages")
        .add({
      "userId" : currentUserId,
    });
  }

  //////the conversation view
  Widget chatMessages(DocumentSnapshot snapshot){
    Map<String, dynamic> _docdata = snapshot.data as Map<String, dynamic>;
    Message _message = Message.fromDocument(snapshot, _docdata);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  //////Sender layout
  Widget senderLayout(Message  message){
    Radius messageRadius  = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: DARK_PURPLE_COLOR,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
          bottomRight: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessages(message),
      ),
    );
  }


  //////// this is how receiver's layout will look like
  Widget receiverLayout(Message message){
    Radius messageRadius  = Radius.circular(10);
    return FutureBuilder(
        future: usersReference.doc
          (widget.currentUserId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress();
          }
          // Map<String, dynamic> _docdata = dataSnapshot.data();
          // Users user = Users.fromDocument(dataSnapshot.data, _docdata);
          return Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(picture),),
              Container(
                margin: EdgeInsets.only(top: 12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.65,
                ),
                decoration: BoxDecoration(
                  color: PURPLE_COLOR,
                  borderRadius: BorderRadius.only(
                    bottomRight: messageRadius,
                    topRight: messageRadius,
                    bottomLeft: messageRadius,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: getMessages(message),
                ),
              ),
            ],
          );
        }
    );
  }

  // getMessage(DocumentSnapshot snapshot){
  //   return Text(
  //     snapshot['message'],
  //     style: TextStyle(
  //       color: Colors.black,
  //       fontSize: 16,
  //     ),
  //   );
  // }

  getMessages(Message message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    )
        : message.photoUrl != null
        ? CachedImage(
      message.photoUrl,
      height: 250,
      width: 250,
      radius: 10,
    )
        : Text("Url was null");
  }

//the controller of the chat screen
  Widget chatScreenControl(){
    setWritingTo(bool val) {
      setState(() {
        isTyping = val;
      });
    }
    addMedia(context){
      showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.white,
        builder: (context){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    IconButton(onPressed: () => Navigator.maybePop(context), icon: Icon(Icons.close,color: Colors.black,)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "context and tools",
                          style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: [
                    ModuleTile(
                        title: "Media",
                        subtitle: "Share media",
                        icon: Icons.perm_media,
                        onTap: () => pickImage(source: ImageSource.gallery),
                    ),
                    ModuleTile(
                      title: "Share Music",
                      subtitle: "Share any type of audio",
                      icon: Icons.music_note,
                    ),
                    ModuleTile(
                        title: "Document",
                        subtitle: "Share files",
                        icon: Icons.tab,
                        // onTap: ,
                    ),
                    // ModuleTile(
                    //   title: "Contact",
                    //   subtitle: "Share contacts",
                    //   icon: Icons.contacts,
                    // ),
                    // ModuleTile(
                    //   title: "Location",
                    //   subtitle: "Share a location",
                    //   icon: Icons.add_location,
                    // ),
                  ],
                ),
              ),
            ],
          );
        }
      );
    }

    return Container(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width*0.05,
          left:MediaQuery.of(context).size.width*0.05,
          top: MediaQuery.of(context).size.height*0.01,
          bottom: MediaQuery.of(context).size.height*0.01),
      child: Row(
         children: [
          GestureDetector(
            onTap: () => addMedia(context),
            child: Container(
              padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width*0.03,
              left:MediaQuery.of(context).size.width*0.03,
                  top: MediaQuery.of(context).size.height*0.03,
                  bottom: MediaQuery.of(context).size.height*0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: DARK_PURPLE_COLOR,),
              ),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: TextField(
              controller: textFieldEditingController,
              style: TextStyle(color: BLACK_COLOR),
              onChanged: (val){
                (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message....",
                hintStyle: TextStyle(color: BLACK_COLOR),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(50)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.black45,
                suffixIcon: GestureDetector(
                  onTap: (){},
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: DARK_PURPLE_COLOR,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        // keyboard is visible
                        hideKeyboard();
                        // EmojiKeyboard(
                        //   onEmojiSelected: onEmojiSelected,
                        // );
                      } else {
                        //keyboard is hidden
                        showKeyboard();
                        hideEmojiContainer();
                      }
                    },
                    icon: Icon(Icons.face),
                  ),
                ),
              ),
            ),
          ),
          isTyping ? Container() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,),
            child: IconButton(icon: Icon(_iconData), color: DARK_PURPLE_COLOR, onPressed: (){
              _recordButtonPress();
            },),
          ),
          isTyping ? Container() : GestureDetector(child: IconButton(icon: Icon(Icons.camera_enhance, color: DARK_PURPLE_COLOR,), onPressed: () => pickImage(source: ImageSource.camera),),onTap: () => pickImage(source: ImageSource.camera),),

          isTyping ? Container(margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: DARK_PURPLE_COLOR,
            shape: BoxShape.circle,
          ),
            child: IconButton(
                icon: Icon(Icons.send, color: WHITE_COLOR,size: 15,),
                onPressed: () => sendMessage()),
          ) : Container(),
        ],
      ),
    );
  }

  IconData _iconData = Icons.mic;
  bool _isRecording = false;
  String _recordLabel;
  Stopwatch _stopwatch = Stopwatch();

  Future<void> _recordButtonPress() async {
    // if (await Permission.microphone.request().isGranted) {
    //   setState(() {
    //     if (!_isRecording) {
    //       setState(() {
    //         _recordLabel = 'Recording...';
    //       });
    //       _startRecording();
    //       _stopwatch.start();
    //       _isRecording = true;
    //       _iconData = Icons.stop;
    //     } else {
    //       _recordLabel = 'Tap the button to start recording';
    //       _stopwatch.reset();
    //       _stopRecording();
    //       _stopwatch.stop();
    //       _isRecording = false;
    //       _iconData = Icons.mic;
    //     }
    //   });
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Audio and Microphone permission is required to work.",
    //       toastLength: Toast.LENGTH_LONG,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 3,
    //   );
    // }
  }


  bool isRecording;
  int remainingDuration;
  Timer timer;
  Record record;
  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    // Start recording
    await record.start(path: path.join(directory.path, fileName()));

  }


  Widget buildTime(){
    final String minutes = formatNumber(remainingDuration ~/ 60);
    final String seconds = formatNumber(remainingDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String formatNumber(int number){
    String numberStr = number.toString();
    if(number < 10){
      numberStr = '0' + numberStr;
    }
    return numberStr;
  }

  Future<void> _stopRecording() async {
    timer?.cancel();
    await record.stop();
    setState(() {
      isRecording = false;
      remainingDuration = maxDuration;
    });
    // widget.onStop;
  }


  // Future<void> _stopRecording() async {
  //   Record recording = await Record.stop();
  //   Scaffold.of(context).showSnackBar(new SnackBar(
  //       content: new Text("File Saved Successfully.")));
  //   print("Path : ${recording.pa},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
  //
  // }



  String fileName(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return 'recording_$formattedDate${now.hour}_${now.minute}_${now.second}.mp4';
  }

  emojiContainer() {
    // return EmojiPicker(
    //   bgColor: DARK_MODE_OR,
    //   indicatorColor: WHITE_COLOR,
    //   rows: 3,
    //   columns: 7,
    //   onEmojiSelected: (emoji, category) {
    //     setState(() {
    //       isTyping = true;
    //     });
    //
    //     textFieldEditingController.text = textFieldEditingController.text + emoji.emoji;
    //   },
    //   recommendKeywords: ["face", "happy", "party", "sad"],
    //   numRecommended: 50,
    // );
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await pickImages(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiverId,
        senderId: currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  ImagePicker _picker = ImagePicker();
  Future<dynamic> pickImages({@required ImageSource source}) async {
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 700,
    );
    return await compressImage(pickedFile);
  }

  static Future compressImage(PickedFile imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final int rand = Random().nextInt(10000);

    // ImD.Image image = ImD.decodeJpg(bytes);

    // ImD.copyResize(image, width: 500, height: 500);

    return new File('$path/img_$rand.jpg');
      // ..writeAsBytesSync(ImD.encodeJpg(image, quality: 85));
  }


  sendMessage() async{ // send message function
    if(isLoading)
      circularProgress();
    var text = textFieldEditingController.text;
    Message _message = Message(
    receiverId: widget.receiverId,//Not sure if ths is a mistake
    senderId: widget.currentUserId,
    message: text, type: 'text',
    timestamp: DateTime.now(),
    );
    ChatMethods.addMessageToDb(_message);
    displayToastMessage('sent', context);
    setState(() {
     isTyping = false;
     isLoading = false;
    });
    textFieldEditingController.text = "";

    // _chatMethods.addMessageToDb(_message);

    if (text != '')
      textFieldEditingController.clear();
  }
}


class ModuleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  final IconButton icons;

  const ModuleTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.icons,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini:  false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon, color: Colors.black,
            size: 30,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey,fontSize: 14, ),
        ),
        title: Text(
          title, style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



