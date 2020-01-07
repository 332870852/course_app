import 'package:flutter/material.dart';

 Future NavugatorPush(context,{@required page})async{
  var result= await Navigator.push(
       context,
       PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation){
         return  SlideTransition(
           position: Tween<Offset>(
               begin: Offset(1.0, 0.0),
               end:Offset(0.0, 0.0)
           )
               .animate(CurvedAnimation(
               parent: animation,
               curve: Curves.fastOutSlowIn
           )),
           child:  page,
         );
       }));
  return result;
 }