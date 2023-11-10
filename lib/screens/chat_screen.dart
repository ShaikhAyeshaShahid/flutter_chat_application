import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/apis.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/model/chat_user.dart';
import 'package:flutter_demo/model/message.dart';
import 'package:flutter_demo/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final chat_user user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  bool _showEmoji = false;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: (){
            if(_showEmoji)
              {
                setState(() {
                  _showEmoji =!_showEmoji;
                });
                return Future.value(false);
              }
            else
              {
                return Future.value(true);
              }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                          case ConnectionState.active:
                          case ConnectionState.done:
                            // if (snapshot.hasData) {
                            final data = snapshot.data?.docs;
                            // log('Data: ${jsonEncode(data![0].data())}');

                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            // for (var i in data!) {
                            //   log('Data : ${jsonEncode(i.data())}');
                            //   list.add(i.data()['name']);
                            // }
                            // }

                            // _list.clear();
                            //
                            // _list.add(Message(
                            //     toId: 'xyz',
                            //     msg: 'hi',
                            //     read: '',
                            //     type: Type.text,
                            //     fromId: APIs.user.uid,
                            //     sent: '12:00 AM'));
                            //
                            // _list.add(Message(
                            //     toId: APIs.user.uid,
                            //     msg: 'hi',
                            //     read: '',
                            //     type: Type.text,
                            //     fromId: 'xyz',
                            //     sent: '12:00 AM'));

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount:
                                      // _issearching ? _searchList.length :
                                      _list.length,
                                  padding: EdgeInsets.only(top: mq.height * 0.01),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCard(
                                      message: _list[index],
                                    );
                                    // Text('Message:  ${_list[index]}');
                                    // ChatUserCard(
                                    //   user: _issearching
                                    //       ? _searchList[index]
                                    //       : _list[index]);
                                    // return ChatUserCard();
                                  });
                            } else {
                              return Center(
                                  child: Text(
                                'Say Hi 👋 ',
                                style: TextStyle(
                                    fontSize: mq.width * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ));
                            }
                        }
                      }),
                ),
                _chatInput(),

                if(_showEmoji)
                SizedBox(
                  height: mq.height * 0.35,
                  child: EmojiPicker(
                    textEditingController: _textEditingController,
                    // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      bgColor: Colors.white,
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black87)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.2),
            child: CachedNetworkImage(
              width: mq.width * 0.06,
              height: mq.height * 0.06,
              imageUrl: widget.user.image.toString(),
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                'Last seen not available',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: (){
                      if(_showEmoji)
                      setState(() {
                        _showEmoji =!_showEmoji;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Type here',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  // SizedBox(
                  //   width: mq.width * 0.2,
                  // ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                print("Type.image1 ${Type.image}");
                APIs.sendMessage(
                    widget.user, _textEditingController.text, Type.image);
                _textEditingController.text = '';
              }
            },
            padding:
                const EdgeInsets.only(top: 10, right: 5, bottom: 10, left: 5),
            shape: const CircleBorder(),
            minWidth: 0,
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
