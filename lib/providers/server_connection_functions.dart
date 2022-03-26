import 'package:dio/dio.dart';
import '../models/events.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:network_to_file_image/network_to_file_image.dart';
import '../providers/info_provider.dart';
//import 'package:path/path.dart' as path; //otherwise context error

class Server_Connection_Functions {
  Future<Map<String, dynamic>> getProfileData(BuildContext context) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    print(username);

    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', '/auth/profile/view/$username'),
      headers: headers,
    );
    int statusCode = response.statusCode;
    print('$statusCode');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }
  Future<Map<String, dynamic>> getHostData(BuildContext context,String Username) async {
    String username =Username;
    print("HOST NAME////////////////////////////${username}");

    String accessToken =
    Provider.of<AccessTokenData>(context, listen: false).getAccessToken();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', '/auth/profile/view/$username'),
      headers: headers,
    );
    int statusCode = response.statusCode;
    print('$statusCode');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }

  Future<bool> registerForEvent(
    int eventId,
    BuildContext context,
  ) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersRegisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtuotgbeta.azurewebsites.net', 'events/register/'),
        headers: headersRegisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK" ? true : false; //return registration status
  }

  Future<bool> unregisterForEvent(int eventId, BuildContext context) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersUnregisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtuotgbeta.azurewebsites.net', 'events/unregister/'),
        headers: headersUnregisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code unregister event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK"
        ? false
        : true; //return registration status not unregistration status
  }

  Future<bool> fetchListOfEvents(BuildContext context) async {
    List<Event> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    print('///////access token event fetch 🙂');
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEvents = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', 'events'),
      headers: headersEvents,
    );
    int statusCode = response.statusCode;

    List<dynamic> resp = json.decode(response.body);
    eves = resp.map<Event>((e) {
      return Event(
          eventImageUri: e['image'],
          favorite: e['registered'],
          name: e['name'],
          owner: e['owner'],
          id: e['id'],
          eventType: e['type_event'],
          dateime: DateTime.parse(e['date_time']),
          owner_image: e['owner_pic'],
          event_image: e['image']);
    }).toList();

    Provider.of<EventsData>(context, listen: false).setEvents(eves);
    print(resp);
    return true;
  }
  Future<bool> fetchListOfProjects(BuildContext context) async {
    List<Project> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    print('///////access token event fetch 🙂');
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEvents = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', '/projects/all/'),
      headers: headersEvents,
    );
    int statusCode = response.statusCode;

    List<dynamic> resp = json.decode(response.body);
    eves = resp.map<Project>((e) {
      return Project(
        discord: e['discord'],
          description: e['description'],


          name: e['name'],
          owner: e['owner'],
          id: e['id'],


          owner_pic: e['owner_pic'],
          image: e['image']);
    }).toList();

    Provider.of<ProjectData>(context, listen: false).setEvents(eves);
    print(resp);
    return true;
  }
  Future<bool> fetchListOfUserProjects(BuildContext context) async {
    String username =
    Provider.of<UsernameData>(context, listen: false).username[0];
    print(username);
    List<Project> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    print('///////access token event fetch 🙂');
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEvents = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', '/auth/profile/view/$username'),
      headers: headersEvents,
    );
    int statusCode = response.statusCode;

    List<dynamic> resp = json.decode(response.body);
    eves = resp.map<Project>((e) {
      return Project(

          description: e['description'],



          name: e['name'],

          id: e['id'],



          image: e['image']);
    }).toList();

    Provider.of<ProjectData>(context, listen: false).setEvents(eves);
    print(resp);
    return true;
  }
  Future<int> createEvent(BuildContext context, String name, String description,
      int type, DateTime dateTime, TimeOfDay timeOfDay, File image) async {
    var accessToken =
    await Provider.of<AccessTokenData>(context, listen: false).accessToken;

    var hours =
    await Provider.of<AddEventScreenData>(context, listen: false).hours;
    print('$hours');
    int minutes =
    await Provider.of<AddEventScreenData>(context, listen: false).minutes;
    print('$minutes');

    var accessTokenValue = accessToken[0];
    print('1');
    int owner1 = Provider.of<OwnerIdData>(context, listen: false).ownerID[0];

    Map<String, String> headersCreateEvent = {
      "Content-type": "multipart/form-data",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('1');
    DateTime date_time = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    print('1');

    ///
    Response response;
    var dio = Dio();
    var formdata = FormData.fromMap({
      "owner": owner1,
      "name": "$name",
      "description": "$description",
      "date_time": "${date_time.toIso8601String()}",
      "duration": "$hours:$minutes:00",
      "latitude": "27.204600000",
      "longitude": "77.497700000",
      "type_event": "${type.toString()}",

      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path,
      )
    });
    response = await dio.post(
      'https://dtuotgbeta.azurewebsites.net/events/create/',
      data: formdata,
      options: Options(
        headers: headersCreateEvent,
      ),
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );

    ///
    //   Map mapjsonBody = {
    //     "owner": owner1,
    //     "name": "$name",
    //     "description": "$description",
    //     "date_time": "${date_time.toIso8601String()}",
    //     "duration": "$hours:$minutes:00",
    //     "latitude": "27.204600000",
    //     "longitude": "77.497700000",
    //     "type_event": "${type.toString()}",
    //     "user_registered": true,
    //     "image": image.readAsBytesSync()
    //   };
    //   print('1');

    //   http.Response response = await http.post(
    //       Uri.https('dtuotgbeta.azurewebsites.net', 'events/create/'),
    //       headers: headersCreateEvent,
    //       body: json.encode(mapjsonBody));
    //   print('///////resp CREATE EVENT  ${response.body}');
    //   print('1');
    //   Map<String, dynamic> resp = json.decode(response.body);
    return response.statusCode;
    //
  }
  Future<int> editEvent(BuildContext context, String name, String description,
      int type, DateTime dateTime, TimeOfDay timeOfDay, File image,int id,) async {
    bool edited;
    var accessToken =
    await Provider.of<AccessTokenData>(context, listen: false).accessToken;

    var hours =
    await Provider.of<AddEventScreenData>(context, listen: false).hours;
    print('$hours');
    int minutes =
    await Provider.of<AddEventScreenData>(context, listen: false).minutes;
    print('$minutes');

    var accessTokenValue = accessToken[0];
    print('1');
    int owner1 = Provider.of<OwnerIdData>(context, listen: false).ownerID[0];

    Map<String, String> headersCreateEvent = {
      "Content-type": "multipart/form-data",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('1');
    DateTime date_time = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    print('1');

    ///
    Response response;
    var dio = Dio();
    var formdata = FormData.fromMap({
     "owner": owner1,
      "name": "$name",
      "description": "$description",
      "date_time": "${date_time.toIso8601String()}",
      "duration": "$hours:$minutes:00",
      "latitude": "27.204600000",
      "longitude": "77.497700000",
      "type_event": "${type.toString()}",

      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path,
      )
    });
    response = await dio.patch(
      'https://dtuotgbeta.azurewebsites.net/events/edit/${id}',
      data: formdata,
      options: Options(
        headers: headersCreateEvent,
      ),
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );

    ///
    //   Map mapjsonBody = {
    //     "owner": owner1,
    //     "name": "$name",
    //     "description": "$description",
    //     "date_time": "${date_time.toIso8601String()}",
    //     "duration": "$hours:$minutes:00",
    //     "latitude": "27.204600000",
    //     "longitude": "77.497700000",
    //     "type_event": "${type.toString()}",
    //     "user_registered": true,
    //     "image": image.readAsBytesSync()
    //   };
    //   print('1');

    //   http.Response response = await http.post(
    //       Uri.https('dtuotgbeta.azurewebsites.net', 'events/create/'),
    //       headers: headersCreateEvent,
    //       body: json.encode(mapjsonBody));
    //   print('///////resp CREATE EVENT  ${response.body}');
    //   print('1');
    //   Map<String, dynamic> resp = json.decode(response.body);
    return response.statusCode;
    //
  }
  Future<dynamic> deleteevent(int id, BuildContext context) async {
    String accessToken =
    Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersInvite = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {"id": "${id}"};
    http.Response response = await http.delete(
        Uri.https('dtuotgbeta.azurewebsites.net', '/events/delete/${id}'),
        headers: headersInvite,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code deleted event $statusCode');
    print("deleted boiiiiii");

    return Text("deleted boiiiiii");
  }
  Future<int> editProject(BuildContext context, String name, String description, File image,int id






      ) async {
    var accessToken =
    await Provider.of<AccessTokenData>(context, listen: false).accessToken;



    var accessTokenValue = accessToken[0];
    print('1');
    int owner1 = Provider.of<OwnerIdData>(context, listen: false).ownerID[0];

    Map<String, String> headersCreateEvent = {
      "Content-type": "multipart/form-data",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('1');

    print('1');

    ///
    Response response;
    var dio = Dio();
    var formdata = FormData.fromMap({
      "owner": owner1,
      "name": "$name",
      "description": "$description",
      "id":'$id',



      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path,

      ),
      "discord": "LOLOLOL",
    });
    response = await dio.post(
      'https://dtuotgbeta.azurewebsites.net/projects/create/',
      data: formdata,
      options: Options(
        headers: headersCreateEvent,
      ),
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );

    ///
    //   Map mapjsonBody = {
    //     "owner": owner1,
    //     "name": "$name",
    //     "description": "$description",
    //     "date_time": "${date_time.toIso8601String()}",
    //     "duration": "$hours:$minutes:00",
    //     "latitude": "27.204600000",
    //     "longitude": "77.497700000",
    //     "type_event": "${type.toString()}",
    //     "user_registered": true,
    //     "image": image.readAsBytesSync()
    //   };
    //   print('1');

    //   http.Response response = await http.post(
    //       Uri.https('dtuotgbeta.azurewebsites.net', 'events/create/'),
    //       headers: headersCreateEvent,
    //       body: json.encode(mapjsonBody));
    //   print('///////resp CREATE EVENT  ${response.body}');
    //   print('1');
    //   Map<String, dynamic> resp = json.decode(response.body);
    return response.statusCode;
    //
  }

  Future<int> createProject(BuildContext context, String name, String description, File image,






  ) async {
    var accessToken =
        await Provider.of<AccessTokenData>(context, listen: false).accessToken;



    var accessTokenValue = accessToken[0];
    print('1');
    int owner1 = Provider.of<OwnerIdData>(context, listen: false).ownerID[0];

    Map<String, String> headersCreateEvent = {
      "Content-type": "multipart/form-data",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('1');

    print('1');

    ///
    Response response;
    var dio = Dio();
    var formdata = FormData.fromMap({
      "owner": owner1,
      "name": "$name",
      "description": "$description",



      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path,

      ),
      "discord": "LOLOLOL",
    });
    response = await dio.post(
      'https://dtuotgbeta.azurewebsites.net/projects/create/',
      data: formdata,
      options: Options(
        headers: headersCreateEvent,
      ),
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );

    ///
    //   Map mapjsonBody = {
    //     "owner": owner1,
    //     "name": "$name",
    //     "description": "$description",
    //     "date_time": "${date_time.toIso8601String()}",
    //     "duration": "$hours:$minutes:00",
    //     "latitude": "27.204600000",
    //     "longitude": "77.497700000",
    //     "type_event": "${type.toString()}",
    //     "user_registered": true,
    //     "image": image.readAsBytesSync()
    //   };
    //   print('1');

    //   http.Response response = await http.post(
    //       Uri.https('dtuotgbeta.azurewebsites.net', 'events/create/'),
    //       headers: headersCreateEvent,
    //       body: json.encode(mapjsonBody));
    //   print('///////resp CREATE EVENT  ${response.body}');
    //   print('1');
    //   Map<String, dynamic> resp = json.decode(response.body);
    return response.statusCode;
    //
  }

  Future<dynamic> invite(String email, BuildContext context) async {
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersInvite = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {"email": "$email"};
    http.Response response = await http.post(
        Uri.https('dtuotgbeta.azurewebsites.net', 'auth/send-invites/'),
        headers: headersInvite,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }
  Future<dynamic> deleteproject(int id, BuildContext context) async {
    String accessToken =
    Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersInvite = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {"id": "${id}"};
    http.Response response = await http.delete(
        Uri.https('dtuotgbeta.azurewebsites.net', '/projects/${id}'),
        headers: headersInvite,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');

    return Text("deleted boiiiiii");
  }

  // //
  Future<Map<String, dynamic>> timeTableDownload(BuildContext context) async {
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    print('1');

    Map<String, String> headersTimeTable = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('2');
    http.Response response = await http.get(
      Uri.https('dtuotgbeta.azurewebsites.net', 'timetable/',
          {"year": "2k19", "batchgrp": "A", "batchnum": "1"}),
      headers: headersTimeTable,
    );
    print('3');
    int statusCode = response.statusCode;

    Map<String, dynamic> resp = json.decode(json.decode(response.body));
    print(statusCode);
    print(resp.toString());
    print('${DateTime.now().weekday}weekday');
    //
    await Provider.of<TimeTableData>(context, listen: false).set(resp);

    //
    return resp;
  }
}
