import 'package:flutter/material.dart';
import 'config.dart';
import 'navigationbar.dart';

class Bio extends StatefulWidget {
  @override
  _BioState createState() => _BioState();
}

class _BioState extends State<Bio> {
  
   
  final _formkey  = GlobalKey<FormState>();
  String name, githubacc, year =  '', dept;
  
  @override

  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: config.bgColor,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Bio'),
        centerTitle: true,
        backgroundColor: config.bgColor,
      ),
      body:Builder(
        builder: (context) => SingleChildScrollView(
      child: Container(
      padding: EdgeInsets.all(30),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
               style: TextStyle(
                color: config.fontColor,
              ),
              cursorColor: config.fontColor,
              decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     width: config.bordWid,
                     color: config.fontColor,
                   ), 
                 ),
                labelText: 'Name',
                labelStyle: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
                ),
              maxLines: null,
              validator: (String value){
                if(value.isEmpty)
                return 'Enter your name';
                else{
                  this.setState((){
                    this.name = value;
                  });
                  return null;
                }
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              style: TextStyle(
                color: config.fontColor,
              ),
              cursorColor: config.fontColor,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     width: config.bordWid,
                     color: config.fontColor,
                   ), 
                 ),
                labelText: 'Dept',
                labelStyle: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
                ),
              maxLines: null,
              validator: (String value){
                if(value.isEmpty)
                return 'Enter your Dept';
                else{
                 this.setState((){
                    this.dept = value;
                });
                return null;
                }
              },
            ),
            SizedBox(height: 15),
            TextFormField(
               style: TextStyle(
                color: config.fontColor,
              ),
              cursorColor: config.fontColor,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     width: config.bordWid,
                     color: config.fontColor,
                   ), 
                 ),
                labelText: 'Github account',
                labelStyle: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
                ),
              maxLines: null,
              validator: (String value){
                if(value.isEmpty)
                return 'Enter your Github account';
                 else{
                  this.setState((){
                    this.githubacc = value;
                  });
                  return null;
                }
              },
            ),
             SizedBox(height: 15),
             TextFormField(
                style: TextStyle(
                color: config.fontColor,
              ),
              cursorColor: config.fontColor,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     width: config.bordWid,
                     color: config.fontColor,
                   ), 
                 ),
                labelText: 'Year',
                labelStyle: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor),
                hintText: '',
                ),
              maxLines: null,
              validator: (String value){
                int data = int.tryParse(value);
                 if (value.isEmpty)
                    return 'Please enter year';
                 else if (data <= 0 || data > 4)
                    return 'Please enter a correct year';
                  else{
                  this.setState((){
                    this.year = value;
                  });
                  return null;
                }
              },
            ),
            SizedBox(height: 25),
            FlatButton(
              onPressed: (){
            if(_formkey.currentState.validate())
               {
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                    backgroundColor: config.success,
                    content: Text('Submitted', style: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor)),
                 )
                 );
               }
               else 
               print('failure'); 
            }, 
            child: Text('Submit', style: TextStyle( fontSize: 20, fontFamily: config.fontFamily, color: config.fontColor))),
          ],
        )
      ),
    ),
    ),
  ), 
    bottomNavigationBar: NavigationBar(2),
    );
  }
}