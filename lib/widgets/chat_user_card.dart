import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/apis.dart';
import 'package:flutter_demo/helper/my_date_util.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/model/chat_user.dart';
import 'package:flutter_demo/model/message.dart';
import 'package:flutter_demo/screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final chat_user user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;

              final _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                _message = _list[0];
              }

              return ListTile(
                // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: CachedNetworkImage(
                    width: mq.width * 0.055,
                    height: mq.height * 0.055,
                    imageUrl: widget.user.image.toString(),
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                title: Text(widget.user.name.toString()),
                subtitle: Text(
                  _message != null
                      ? _message!.msg.toString()
                      : widget.user.about.toString(),
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : _message!.read!.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
                        // trailing:
                        Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent.toString()),
                            style: TextStyle(
                              color: Colors.black54,
                            )),
              );
            },
          )),
    );
  }
}
