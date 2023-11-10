import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/apis.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/model/chat_user.dart';
import 'package:flutter_demo/screens/profile_screen.dart';
import 'package:flutter_demo/widgets/chat_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<chat_user> _list = [];
  final List<chat_user> _searchList = [];
  bool _issearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_issearching) {
            setState(() {
              _issearching = !_issearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _issearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search here',
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (value) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(value.toLowerCase())) ;
                        {
                          _searchList.add(i);
                        }
                        setState(() {});
                      }
                    },
                  )
                : const Text('Chat'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _issearching = !_issearching;
                    });
                  },
                  icon: Icon(_issearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_rounded),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
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

                    _list = data
                            ?.map((e) => chat_user.fromJson(e.data()))
                            .toList() ??
                        [];

                    // for (var i in data!) {
                    //   log('Data : ${jsonEncode(i.data())}');
                    //   list.add(i.data()['name']);
                    // }
                    // }

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _issearching ? _searchList.length : _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _issearching
                                    ? _searchList[index]
                                    : _list[index]);
                            // return ChatUserCard();
                          });
                    } else {
                      return const Center(
                          child: Text(
                        'No connection found',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ));
                    }
                }
              }),
        ),
      ),
    );
  }
}
