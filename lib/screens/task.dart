import 'package:inductions_20/screens/data/task_description.dart';
import 'package:inductions_20/screens/data/mentee_profile.dart';
import 'package:inductions_20/screens/widgets/custom_box.dart';
import 'package:flutter/material.dart';
import 'package:inductions_20/screens/widgets/custom_graph.dart';
import 'package:inductions_20/screens/mentee_home.dart';
import 'package:inductions_20/screens/comments.dart';
import 'package:http/http.dart' as http;
import 'package:inductions_20/screens/feedbacks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';
import 'package:inductions_20/Themes/styling.dart';
import 'package:inductions_20/screens/widgets/custom_comment.dart';
import 'package:inductions_20/screens/task_description.dart';
import 'package:inductions_20/screens/data/mentee_progress.dart';
class TASK extends StatefulWidget{
  
  List task;
  TASK({this.task});

  TASKState createState() => TASKState(task);


}
class TASKState extends State<TASK> with SingleTickerProviderStateMixin {


  var taskdes;
  List res_desc=[];
  List res_link=[];

  var submitbarcolor=theme.fontColor;
  var user;
  var basic_per = 0.0;
  var advance_per=0.0;
  var overall_per;
  var decoverall_per;
  var sub_count=56;
  List task;
  TASKState(this.task);
  var decbasic_per;
  var decadvance_per;
  var decbasic_barper;
  var decadvance_barper;
  var feed_time="5:30";
  var recent_time;
  var recent_date;
  Map  feedbacks={
    "5:30":"you got to change this"
  };
  var mentorname;
  var mentorcontact;
  TextEditingController textEditingController;
  List taskSubmitted=[];
 List<Tab> myTabs = <Tab>[
    Tab(text: 'Description'),
    Tab(text: 'Progress'),
  ];

  TabController  _tabController;
 
 
  @override
  void initState() {
    
    
    super.initState();
   
      _tabController = TabController(
      length: 2, 
      vsync: this,
      initialIndex: 0,
    )..addListener(() {
        setState(() {
          if(_tabController.index==1)
           submitbarcolor=theme.tertiaryColor;
          else
           submitbarcolor=theme.fontColor;
        });
      });
 this.myTabs = <Tab>[
    Tab(text: 'Description'),
    Tab(text: 'Progress'),
  ];
  textEditingController = TextEditingController();
   this.overall_per=((this.basic_per+ this.advance_per)/2);
   this.decoverall_per=this.overall_per*100 ;
   decbasic_per=this.basic_per*100;
   decadvance_per= this.advance_per*100;

   task_desc();
    
    }


  Future<void> task_desc() async{
  
  Task_details task_details= Task_details(task[1]);
  await task_details.extractTaskDetails();
  setState(() {
    
    this.taskdes=task_details.task_description;
    this.res_desc=task_details.task_resources_desc;
    this.res_link=task_details.task_resources_link;
    this.sub_count=task_details.no_submissions;
   });

  Mentee_progress mentee_progress = Mentee_progress(task[1]);

  await mentee_progress.extractProgressDetails();

  setState(() {
       

  basic_per=mentee_progress.basic_per/100;
  advance_per= mentee_progress.advance_per/100;
  feed_time=mentee_progress.recent_feedback;
  feedbacks=mentee_progress.previous_feedbacks;

  String date=  feed_time.substring(0, 10);

   int hr =int.parse(feed_time.substring(11,13))-12+5;
   int min =int.parse(feed_time.substring(14,16))+30;
   int sec= int.parse(feed_time.substring(17,19));
  if(min>=60)
  { hr++;
    min=min-60;
   }

   this.recent_date=date;

   this.recent_time="$hr:$min:$sec";
  this.taskSubmitted= mentee_progress.submitted_links;

   this.overall_per=((this.basic_per+ this.advance_per)/2);
   this.decoverall_per=this.overall_per*100 ;
   decbasic_per=this.basic_per*100;
   decadvance_per= this.advance_per*100;

  });


   Mentor_details mentor_details = Mentor_details(task[3]);
   await mentor_details.mentor_extract();
   
   setState(() {
     this.mentorname= mentor_details.mentor_name;
     this.mentorcontact= mentor_details.mentor_contact; 
       });




  }  
    @override
  void dispose() {
  _tabController.dispose();
  super.dispose();
  }
  
  double bottombarwidth;
  double submitedlinkswidth;
  double commentwidth;
  double submissionwidth;
  double percentbarwidth;
  double linkinputwidth;
  double previousfeedbackwidth;
  double reviewpadding;
  double leftpaddingwidth;
  @override
  Widget build(BuildContext context) {

  final width = MediaQuery.of(context).size.width;
  if (width <= 350) {
     submitedlinkswidth=4*(width/5);
     submissionwidth=110;
     commentwidth=3*(width/4);
     reviewpadding=10;
     linkinputwidth=370;
     bottombarwidth=105;
     percentbarwidth=120;
     leftpaddingwidth=5;
     previousfeedbackwidth=320;
     decbasic_barper=this.basic_per*percentbarwidth;
     decadvance_barper= this.advance_per*percentbarwidth;

  } else if (width <= 600) {
     submitedlinkswidth=4*(width/5);
     submissionwidth=110;
     commentwidth=3*(width/4);
     linkinputwidth=370;
     leftpaddingwidth=25;
     reviewpadding=10;
     previousfeedbackwidth=320;
     bottombarwidth=width/3;
     percentbarwidth=130;
     decbasic_barper=this.basic_per*percentbarwidth;
     decadvance_barper= this.advance_per*percentbarwidth;
  } else if (width <= 900) {
     submitedlinkswidth=4*(width/5);
     submissionwidth=110;
     commentwidth=3*(width/4);
     bottombarwidth=width/3;
     leftpaddingwidth=25;
     linkinputwidth=370;
     reviewpadding=10;
     previousfeedbackwidth=320;
     percentbarwidth=130;
     decbasic_barper=this.basic_per*percentbarwidth;
     decadvance_barper= this.advance_per*percentbarwidth;
  } else {
     submitedlinkswidth=4*(width/5);
     submissionwidth=110;
     commentwidth=390;
     leftpaddingwidth=180;
     bottombarwidth=430;
     percentbarwidth=600;
     linkinputwidth=500;
     reviewpadding=340;
     previousfeedbackwidth=400;
     decbasic_barper=this.basic_per*percentbarwidth;
     decadvance_barper= this.advance_per*percentbarwidth;
  }  
  task= widget.task;
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
            backgroundColor:  theme.primaryColor,
            appBar: AppBar(
                    leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
                             Navigator.push(context, 
                             MaterialPageRoute(builder: (context) =>homepage()),);
                             },), 
                    title: Text('${task[0]}'),
                    backgroundColor: theme.blackColor ,
                    bottom: TabBar(
                    controller: _tabController,
                    tabs: myTabs  ),),

            floatingActionButton: _tabController.index ==0 ? 
            FloatingActionButton(
            backgroundColor: theme.fontColor,
            child: ListView(
            children: <Widget>[
            Padding(padding: const EdgeInsets.only(bottom:0),),
            Circular_percentage(48, 8, this.overall_per, Text("$decoverall_per"), theme.advancetaskColor),
            ]
            )
            ): null,
            bottomNavigationBar:  Container(
                height: 50, 
                width: 370, 
                child: Material(
                  color: theme.blackColor,
                  elevation: 10.0,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(      
                  padding: EdgeInsets.only(left:1),
                  width:bottombarwidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: <Widget>[
                
                   Padding(padding: EdgeInsets.only(top:16, left:leftpaddingwidth, right: 0),
                   
                   child:  Text("${sub_count} submission",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: theme.tertiaryColor,
                   ) )),])),
                   
                   Custom_box('Submit',(){
                   _tabController.animateTo((_tabController.index+1));
                   double width = MediaQuery.of(context).size.width;
                   print(width);
                   },bottombarwidth,50,15,theme.blackColor,15,0,0),
                   Custom_box('Comments',(){
                                   List a=task;
                                   Navigator.push(context, 
                                   PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation)=>TASKcomments(task: a),
                                   transitionsBuilder: (context, animation, secondaryAnimation, child){
                                   return SlideTransition(
                                     position: Tween<Offset>(
                                     begin: const Offset(0.0, 1.0),
                                     end: Offset.zero,
                                     ).animate(animation),
                                child: SlideTransition(
                                     position: Tween<Offset>(
                                     end: const Offset(0.0, 1.0),
                                     begin: Offset.zero,
                                     ).animate(secondaryAnimation),
                                     child: child,
                                ),
                              );
                            }
                            )
                            ); },bottombarwidth,50,15,theme.blackColor,15,0,0)
           ] ),), ),  
        body: TabBarView(
              controller: _tabController,
              children: myTabs.map((Tab tab){
              final String label = tab.text.toLowerCase();
              if(label!='progress')
                  return Task_description(theme.primaryColor,taskdes, res_link, res_desc, mentorname, mentorcontact);
              else {
        return ListView(
        children: <Widget>[
        Padding(
             padding: const EdgeInsets.all(0.0),
             child: Column(      
                    children: <Widget>[

                    Container(
                    margin:  const EdgeInsets.all( 10.0),
                    padding: const EdgeInsets.only(left:18.0),
                    width:linkinputwidth ,
                    decoration: BoxDecoration(
                                color: theme.secondaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                    child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: theme.fontColor,
                    ),
                    decoration: InputDecoration.collapsed(
                    hintText: "Submit the Link of the task",
                    
                    hintStyle:(TextStyle(color: Colors.white24 )),
                    fillColor: theme.fontColor
              ),
             controller: textEditingController,
            ),
          ),
          Custom_box('Submit',()async{  
                              var text = textEditingController.value.text;
                                if(taskSubmitted.length>5)
                               {
                                     showAlertDialog(context,"submitted links should not be above 5");
                               }
                               else{
                               try {
                              var response = 
                                 await http.head(text);
                                      textEditingController.clear();
                                      setState(() {
                                      taskSubmitted.add(text);
                               });
                                } catch (e) {
                                         showAlertDialog(context, "Invalid link");
                                  }
                               }},68,38,14,theme.tertiaryColor,10,3,10),
          Container(
          child: Column(
                 children: <Widget>[
                 Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                   Padding( 
                   padding:const EdgeInsets.all(15.0),
                   child:Text("Submited Links:", style: TextStyle(color: theme.fontColor,
                   fontWeight: FontWeight.bold),)),]
                 ),
                for(int i=0; i<taskSubmitted.length; i++)
                Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Custom_box('''${taskSubmitted[i]}''',(){  
                  launch('${taskSubmitted[i]}');},submitedlinkswidth,38,15,theme.primaryLightColor,10,3,0),
                  IconButton(
                      icon: Icon( Icons.clear ,
                      color: theme.fontColor,
                      size: 20,), onPressed:(){
                                          setState(() {
                                          taskSubmitted.remove(taskSubmitted[i]);
                                          });
                 },),
                ]
    ),],), ) ],)),
    new Divider(
    color: theme.fontColor,
    height: 50,
    thickness: 1,),
    Row(
    children:<Widget>[
            Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, bottom: 8.0, right: 8.0),
                  child: CircleAvatar(
                            child: Text("${mentorname[0]}"),
                         ),
            ),
            Padding(padding: const EdgeInsets.only(left:12.0),
            child: CustomPaint(painter: Triangle(),)),
            Comment_box('''${feedbacks[feed_time]}''', theme.tertiaryColor,theme.fontColor, commentwidth,'''$mentorname''','''$recent_date''','''$recent_time'''),
            ]),
            Custom_box('Previous feedbacks',(){
                            print(mentorname);
                            Navigator.push(context, 
                            PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation)=>TASKfeedback(feedbacks, task[0], mentorname),
                            transitionsBuilder: (context, animation, secondaryAnimation, child){
                            return SlideTransition(
                            position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,

                              
                                ).animate(animation),
                                child: SlideTransition(
                                     position: Tween<Offset>(
                                     end: const Offset(0.0, 1.0),
                                     begin: Offset.zero,
                                     ).animate(secondaryAnimation),
                                     child: child,
                                ),
                              );
                            }
                            )
  
                            );},previousfeedbackwidth,50,14.5,theme.blackColor,15,10,0)    ,  
         
    Container(
  
    margin:  EdgeInsets.only(top:30.0, left:reviewpadding, right: reviewpadding),
    padding: const EdgeInsets.all(20.0),
    
    color: theme.blackColor,
    child: Column(
    children: <Widget>[
    TextFormField(
    textAlign: TextAlign.center,
    style: TextStyle(
           color: theme.fontColor
           ),
    decoration: InputDecoration(
    hintText:'add a comment with the request',
    hintStyle: TextStyle(
    color: theme.fontColor,
    fontSize: 15
    ) ),   ),
    Custom_box('Send Request to Review',(){},420,50,14.5,theme.tertiaryColor,15,8,10),
    ],)),

    Padding(padding: const EdgeInsets.only(bottom:40),),

    Circular_percentage(180.0,15.0, this.advance_per, 
            Circular_percentage(130.0, 15.0,this.basic_per,Text("$decoverall_per", style: TextStyle(color: theme.fontColor),),theme.tertiaryColor)
            , theme.advancetaskColor),
    Container(
    margin: const EdgeInsets.only(bottom:20, top:20,left:10, right: 10),
    padding: const EdgeInsets.all(20.0),
    color: theme.blackColor,
    child: Table(
    children:[
          TableRow(
          children: <Widget>[
          Padding( padding:const EdgeInsets.only(bottom:15.0, top:2),
            child:Text("Completion",
                  style: TextStyle(
                  color: theme.fontColor,
                  fontWeight: FontWeight.bold),)),
            Padding( padding:const EdgeInsets.only(bottom:15.0, top:2),
            child:Text(" ")),
            ]),
          TableRow(
          children: <Widget>[
          Row(
            children:<Widget>[
            Container(width: decbasic_barper, height: 15, 
                      color: theme.tertiaryColor,),]),
            Container(width: percentbarwidth, height: 40, 
                      padding: const EdgeInsets.only (top:0, left:10),
                      child: Text('Basic Task : ${decbasic_per} %', style: TextStyle(color: theme.fontColor, ),),
                      )
                    ]
          ),
          TableRow(
          children: <Widget>[
          Row(
            children:<Widget>[
            Container(width: decadvance_barper, height: 15, 
                      color: theme.advancetaskColor,
                      ) ]),
            Container(width: percentbarwidth, height: 40, 
                      padding: const EdgeInsets.only (top:0, left:10),
                      child: Text('Advance Task : ${decadvance_per} %', style: TextStyle(color: theme.fontColor, ),),
                      )
                    ]
                 )
               ]))
]);
             }    
     
           }).toList(),
        ), ),
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }}