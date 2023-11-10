import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_demo/model/chat_user.dart';
import 'package:flutter_demo/model/message.dart';

class APIs {
  ///for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  ///for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///for accessing storage firestore database
  static FirebaseStorage storage = FirebaseStorage.instance;

  ///to return current user
  static User get user => auth.currentUser!;

  ///for checking if user exists or not?

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user!.uid).get()).exists;
  }

  ///for storing self information
  static late chat_user me;

  ///for getting creating current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = chat_user.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  ///for creating a new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = chat_user(
        id: user!.uid,
        name: user!.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I am using chat",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return (await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  ///for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }

  /// for update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transfered: ${p0.bytesTransferred / 1000} kb');
    });

    ///updating image in firestoredatabase
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      "image": me.image,
    });
  }

  ///getting all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      chat_user user) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages')
        .snapshots();
  }

  ///useful for getting conversaton id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  ///sending message
  static Future<void> sendMessage(
    chat_user chatuser,
    String msg,
    Type type,
  ) async {
    print("message type ${type.name}");
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore.collection(
        'chats/${getConversationID(chatuser.id.toString())}/messages');
    await ref.doc(time).set(message.toJson());
  }

  ///read message
  static Future<void> updateMessageReadStatus(Message message) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    firestore
        .collection(
            'chats/${getConversationID(message.fromId.toString())}/messages')
        .doc(message.sent)
        .update({'read': time});
  }

  ///get only last message<
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      chat_user user) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
