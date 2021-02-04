import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web2/model/answer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController askController = TextEditingController();

  Answer _currentAnswer;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _handleGetAnswer() async {
    String questionText = askController.text.trim();
    if (questionText == null ||
        questionText.length == 0 ||
        !questionText.contains("?")) {
      _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("Please ask a valid question."),duration:Duration(seconds: 2) ,));
      return;
    }
    try {
      http.Response response = await http.get("https://yesno.wtf/api");
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        Answer answer = Answer.fromMap(responseBody);
        setState(() {
          _currentAnswer = answer;
        });
      }
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  _handleResetOperation(){
    askController.text = "";
    setState(() {
      _currentAnswer = null;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("I Know Everything"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            //decoration: ,
            child: TextField(
              controller: askController,
              decoration: InputDecoration(
                  labelText: "Ask a Question", border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _currentAnswer != null
              ? Stack(
                  children: [
                    Container(
                      height: 250,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(_currentAnswer.image),
                              fit: BoxFit.cover)),
                    ),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        _currentAnswer.answer.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ))
                  ],
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: _handleGetAnswer,
                child:
                    Text("Get Answer", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: _handleResetOperation,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
