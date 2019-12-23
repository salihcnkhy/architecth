import 'package:flutter/material.dart';

class User {

  String uid;
  Map<DateTime,Map<int,bool>> dates = Map<DateTime,Map<int,bool>>();
  User({@required this.uid,@required this.dates});
 
}

User user = new User(dates: null,uid: null);