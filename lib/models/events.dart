import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  String name;
  int id;
  bool favorite;
  String owner;
  DateTime dateime;
  String eventType;
<<<<<<< HEAD
  String eventImageUri;
=======
  String owner_image;
  String event_image;

>>>>>>> 6650853b09b3e643da96d5c3f1a27cb9d400b401
  Event(
      {this.dateime,
      this.eventType,
        this.owner_image,
        this.event_image,
      this.id,
      this.eventImageUri,
      this.name,
      this.owner,
      this.favorite});
}

class EventDetails with ChangeNotifier {
  int id;
  String owner;
  String name;
  num latitude;
  num longitute;
  String eventImageUri;
  String description;
  DateTime dateTime;
  String duration;
  String type;
  bool registered;
  int count;
  String event_image;
  EventDetails({
    this.id,
    this.owner,
    this.eventImageUri,
    this.name,

    this.latitude,
    this.longitute,
    this.description,
    this.dateTime,
    this.duration,
    this.type,
    this.registered,
    this.count,
    this.event_image,
  });
}
