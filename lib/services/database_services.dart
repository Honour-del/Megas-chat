import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/posts/components/post_widget.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/consts.dart';
class DataBase{

  static Future<DocumentSnapshot> getData() async {
    final User alien = FirebaseAuth.instance.currentUser;
    return usersReference.doc(alien.uid).get();
  }

  static Future<Users> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersReference.doc(userId).get();
    if (userDocSnapshot.exists) {
      Map<String, dynamic> doc = userDocSnapshot.data();
      return Users.fromDocument(userDocSnapshot, doc);
    }
    return Users();
  }


  static Future<List<String>> getUserFollowersIds(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .doc(userId)
        .collection('userFollowers')
        .get();

    List<String> followers =
    followersSnapshot.docs.map((doc) => doc.id).toList();
    return followers;
  }


  static Future<List<String>> getUserFollowingIds(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .doc(userId)
        .collection('userFollowing')
        .get();

    List<String> following =
    followingSnapshot.docs.map((doc) => doc.id).toList();
    return following;
  }

  static Future<List<Post>> getDeletedPosts(
      String userId, PostStatus postStatus) async {
    String collection;
    postStatus == PostStatus.archivedPost
        ? collection = 'archivedPosts'
        : collection = 'deletedPosts';

    QuerySnapshot feedSnapshot = await postReference
        .doc(userId)
        .collection(collection)
        .orderBy('timestamp', descending: true)
        .get();
    Map<String, dynamic> d = feedSnapshot.docs as Map<String, dynamic> ;
    List<Post> posts =
    feedSnapshot.docs.map((doc) => Post.fromDocument(doc, d)).toList();
    return posts;
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postReference
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
    Map<String, dynamic> d = userPostsSnapshot.docs as Map<String, dynamic> ;
    List<Post> posts =
    userPostsSnapshot.docs.map((doc) => Post.fromDocument(doc, d)).toList();
    return posts;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await activityFeedRef
        .doc(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();
    Map<String, dynamic> d = feedSnapshot.docs.last.data() ;
    List<Post> posts =
    feedSnapshot.docs.map((doc) => Post.fromDocument(doc, d)).toList();
    return posts;
  }

  static Future<List<Post>> getAllFeedPosts() async {
    List<Post> allPosts = [];

    QuerySnapshot usersSnapshot = await usersReference.get();

    for (var userDoc in usersSnapshot.docs) {
      QuerySnapshot feedSnapshot = await postReference
          .doc(userDoc.id)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .get();

      for (var postDoc in feedSnapshot.docs) {
        Map<String, dynamic> d = feedSnapshot.docs as Map<String, dynamic> ;
        Post post = Post.fromDocument(postDoc, d);
        allPosts.add(post);
      }
    }
    return allPosts;
  }

  static void followUser(
      {String currentUserId, String userId, String receiverToken}) {
    // Add user to current user's following collection
    followingRef
        .doc(currentUserId)
        .collection('following')
        .doc(userId)
        .set({'timestamp': Timestamp.fromDate(DateTime.now())});

    // Add current user to user's followers collection
    followersRef
        .doc(userId)
        .collection('follower')
        .doc(currentUserId)
        .set({'timestamp': Timestamp.fromDate(DateTime.now())});

    Post post = Post(
      ownerId: userId,
    );
  }
  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user from current user's following collection
    followingRef
        .doc(currentUserId)
        .collection('following')
        .doc(userId)

        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current user from user's followers collection
    followersRef
        .doc(userId)
        .collection('follower')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    Post post = Post(
      ownerId: userId,
    );

    // deleteActivityItem(
    //   comment: null,
    //   currentUserId: currentUserId,
    //   isFollowEvent: true,
    //   post: post,
    //   isCommentEvent: false,
    //   isLikeEvent: false,
    //   isLikeMessageEvent: false,
    //   isMessageEvent: false,
    // );
  }

  static Future<List<Post>> getStoriesByUserId(
      String userId, bool checkDate) async {
    final Timestamp timeNow = Timestamp.now();

    QuerySnapshot snapshot;
    List<Post> userStories = [];

    if (checkDate) {
      snapshot = await postReference
          .doc(userId)
          .collection('stories')
          .where('timeEnd', isGreaterThanOrEqualTo: timeNow)
          .get();
    } else {
      snapshot = await postReference
          .doc(userId)
          .collection('stories')
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> docdata = snapshot.docs.last.data();
        Post story = Post.fromDocument(doc, docdata);
        userStories.add(story);
      }
      return userStories;
    }
    return null;
  }
  static Future<List<Users>> getUserFollowingUsers(String userId) async {
    List<String> followingUserIds = await getUserFollowingIds(userId);
    List<Users> followingUsers = [];

    for (var userId in followingUserIds) {
      DocumentSnapshot userSnapshot = await usersReference.doc(userId).get();
      Map<String, dynamic> abc = userSnapshot.data();
      Users user = Users.fromDocument(userSnapshot, abc);
      followingUsers.add(user);
    }

    return followingUsers;
  }


}