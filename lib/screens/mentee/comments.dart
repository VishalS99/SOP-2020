import 'dart:async';
import 'package:inductions_20/theme/mentee.dart';
import 'package:flutter/material.dart';
import 'package:inductions_20/screens/mentee/widgets/custom_comment.dart';
import 'package:inductions_20/screens/mentee/data/comments.dart';
import 'config/jwtparse.dart';
import 'config/extractjwt.dart';
import 'package:http/http.dart';
import 'dart:convert' show jsonEncode;

class TaskComment extends StatefulWidget {
  final List task;
  TaskComment({this.task});

  TaskCommentState createState() => TaskCommentState(this.task);
}

class TaskCommentState extends State<TaskComment>
    with SingleTickerProviderStateMixin {
  var taskdes;

  var task;
  TaskCommentState(this.task);
  List _users;
  List _date;
  List _time;
  List _messages;
  List _pos;
  var username;
  Color color;
  var user = "";

  TextEditingController textEditingController;
  ScrollController scrollController;

  bool enableButton = false;
  @override
  void initState() {
    _users = [];
    _date = [];
    _time = [];
    _messages = [];
    _pos = [];
    color = theme.tertiaryColor;
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    super.initState();

    _getcomments();
  }

  Future<void> _getcomments() async {
    CommentsList commentsList1 = CommentsList(task[1]);
    await commentsList1.extractComment();

    setState(() {
      this._users = commentsList1.user;
      this._messages = commentsList1.comments;
      this._time = commentsList1.time;
      this._date = commentsList1.dates;
      this.username = commentsList1.username;
      this._pos = commentsList1.pos;
    });
  }

  void handleSendMessage() async {
    var text = textEditingController.value.text;

    final RegExp regex = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (text.contains(regex)) {
      showAlertDialog(
          context, "message containing emojis or photos is restricted");
    } else {
      try {
        ProvideJwt provideJwt = ProvideJwt();
        await provideJwt.extractjwt();
        String jwt = provideJwt.jwt;
        var res = tryParseJwt(jwt);
        var rollno = res["roll"];

        String url =
            "https://spider.nitt.edu/inductions20test/api/task/forum_comment";
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        };

        var json1 = jsonEncode({
          "rollno": "$rollno",
          "task_id": task[1],
          "profile_id": task[3],
          "comment": "$text",
          "username": "$username",
          "is_mentor": false,
          "reply_id": 0
        });

        Response response = await post(url, headers: headers, body: json1);
        int statusCode = response.statusCode;

        if (statusCode == 200) {
          print("submitted");
        } else if (statusCode == 404) {
          print("404 error");
        }

        try {
          setState(() {
            textEditingController.clear();
            _messages.add(text);
            _users.add(username);
            DateTime dateTime = new DateTime.now();
            String datetime = "$dateTime";
            String date = datetime.substring(0, 10);
            var hr = int.parse(datetime.substring(11, 13));
            var min = int.parse(datetime.substring(14, 16));

            var times = "$hr:$min";
            _date.add("$date");
            _time.add("$times");
            _pos.add(false);
            enableButton = false;
          });
        } catch (e) {
          print("error:$e");
        }
      } catch (e) {
        print("error:$e");
      }
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.ease, duration: Duration(milliseconds: 500));
      });
    }
  }

  double commentwidth;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 400) {
      commentwidth = 210;
    } else if (width <= 600) {
      commentwidth = 230;
    } else if (width <= 900) {
      commentwidth = 290;
    } else {
      commentwidth = 390;
    }
    var textInput = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              onChanged: (text) {
                setState(() {
                  enableButton = text.isNotEmpty;
                });
              },
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration.collapsed(
                  hintText: "Type a comment",
                  hintStyle: (TextStyle(color: Colors.white12)),
                  fillColor: theme.fontColor),
              controller: textEditingController,
            ),
          ),
        ),
        enableButton
            ? IconButton(
                color: theme.tertiaryColor,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: theme.fontColor,
                onPressed: handleSendMessage,
              )
            : IconButton(
                color: theme.tertiaryColor,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: theme.fontColor,
                onPressed: null,
              )
      ],
    );
    task = widget.task;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('${task[0]}'),
          backgroundColor: theme.blackColor,
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: 370,
              margin: EdgeInsets.all(10),
              child: Material(
                color: theme.blackColor,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        ''' This will be an interactive field between you and your friends, regarding the task''',
                        style: TextStyle(
                            color: theme.tertiaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  bool reverse = false;

                  if (_users[index] == username) {
                    reverse = true;
                  }
                  if (_pos[index] == true) {
                    color = Colors.amber;
                    user = '''${_users[index]} * ''';
                  } else {
                    color = theme.tertiaryColor;
                    user = '''${_users[index]} ''';
                  }

                  var avatar = Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, bottom: 8.0, right: 8.0),
                    child: CircleAvatar(
                      child: Text("${_users[index][0]}"),
                    ),
                  );

                  var triangle = CustomPaint(
                    painter: Triangle(color),
                  );

                  var messagebody = CommentBox(
                      '''${_messages[index]}''',
                      color,
                      theme.blackColor,
                      commentwidth,
                      '''$user''',
                      '''${_date[index]}''',
                      '''${_time[index]}''');

                  Widget message;

                  if (reverse) {
                    message = Stack(
                      children: <Widget>[
                        messagebody,
                        Positioned(right: 0, bottom: 0, child: triangle),
                      ],
                    );
                  } else {
                    message = Stack(
                      children: <Widget>[
                        Positioned(left: 0, bottom: 0, child: triangle),
                        messagebody,
                      ],
                    );
                  }

                  if (reverse) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message,
                        ),
                        avatar,
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        avatar,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Divider(height: 2.0),
            textInput
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, text) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(text),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  State<StatefulWidget> createState() => null;
}
