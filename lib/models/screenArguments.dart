import 'package:nilay_dtuotg_2/models/events.dart';

import '../providers/server_connection_functions.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  bool editing;
  Event event;
    String username;
  int id;
  Server_Connection_Functions scf;
  List<Event> eves;
  BuildContext context;
  bool hostpressed;
  List<List<Event>> ownerlist;
  ScreenArguments({this.editing,this.event,this.username, this.id, this.scf, this.eves, this.context,this.hostpressed,this.ownerlist});
}
