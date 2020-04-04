import 'package:flutter/material.dart';
import 'navigationbar.dart';
import 'config.dart';

class Review extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  final _formkey = GlobalKey<FormState>();
  
  Map data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
    backgroundColor: config.bgColor,
    resizeToAvoidBottomPadding: true,
    appBar: AppBar(
      title: Text('Review'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: config.bgColor,
    ),
    body: SingleChildScrollView(
     child: Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text('Review for ${data['repo_det']}', style: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor)),
        SizedBox(height: 10),
          Container(
          padding: EdgeInsets.all(30),
          child:  Form(
          key: _formkey,
          child:  TextFormField(
          style: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
          maxLines: null,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     width: config.bordWid,
                     color: config.fontColor,
                   ), 
                 ),
             labelText: 'Your Review',
             labelStyle: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
             hintText: '',
          ),
          validator: (String value){
            if(value.isEmpty)
            return 'Please enter your review';
            else
            return null;
          },
          )
          )
         ),
         SizedBox(height: 10),
         FlatButton(
          onPressed: (){
            if(_formkey.currentState.validate())
            return null;
          },
          child:  Text('Send', style: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor)),
         ),
      ]
    ),
    ),
    bottomNavigationBar: NavigationBar(0),
    );
  }
}