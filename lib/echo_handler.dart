import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'api_root.dart';
import 'todo.dart';

class EchiRequest {
  final http = Client();
  List datalist = [];

  Future getTodoList(int index, String uuid) async {
    final response = await http.get(ApiRoot.getTodoList(index, uuid));
    return jsonDecode(response.body)['todoList'];
  }

  Future getopacitylength(String uuid) async {
    final response = await http.get(ApiRoot.getopacitylength(uuid));
    final jsonlist = jsonDecode(response.body)['len'];
    return jsonlist;
  }

  Future<Todo> retrieveTodo(var index) async {
    final responce = await http.get(ApiRoot.retrieveTodo(index));
    final data = jsonDecode(responce.body)['todo'];
    final todo = Todo.fromMap(data);
    return todo;
  }

  Future createTodo(value) async {
    // var _requestimage;
    // if (_image != null) {
    //   _requestimage = await MultipartFile.fromFile(_image,
    //       filename: '$_title${_date}image.jpeg');
    // }
    // final response = await http.post(
    //   ApiRoot.createTodo(),
    //   // body: value,
    //   // body: {
    //   //   'title': title,
    //   //   'content': content,
    //   //   'owner': owner,
    //   //   // 'image': _requestimage,
    //   // },
    // );
    final request = MultipartRequest(
      'POST',
      ApiRoot.createTodo(),
    )
      ..fields['title'] = value['title']
      ..fields['content'] = value['content']
      ..fields['deadline'] = value['deadline']
      ..fields['owner'] = value['owner'];
    if (value['image']) request.files.add(value['image']);
    // print(request.files);
    // print(request.fields);
    final response = await http
        .send(request)
        .then((value) => value.stream.bytesToString())
        .onError((error, stackTrace) => error.toString())
        .catchError((error) => error.toString())
        .whenComplete(() => 'complete');
    return response;
  }

  Future updatetodo(value, index) async {
    // var _requestimage;
    // if (_image != null) {
    //   _requestimage = await MultipartFile.fromFile(_image,
    //       filename: '$_title${_date}image.jpeg');
    // }
    // print(ApiRoot.updateTodo(index));
    final response = await http.put(
      ApiRoot.updateTodo(index),
      body: value,
      // body: {
      // 'title': title,
      // 'content': content,
      // 'owner': owner,
      // 'image': _requestimage,
      // },
    );
    final data = response.body;
    return data;
  }

  Future boolchange(int pk, {bool? boolvalue}) async {
    final response = await http.put(
      ApiRoot.boolChange(pk),
      body: {
        'donebool': boolvalue.toString(),
      },
    );
    final data = response.body;
    return data;
  }

  Future deletetodo(int pk) async {
    final responce = await http.delete(ApiRoot.deleteTodo(pk));
    final data = responce.body;
    return data;
  }

  Future userRetrieve(String uuid) async {
    final responce = await http.get(ApiRoot.userRetreive(uuid));
    return jsonDecode(responce.body)['user'];
  }

  Future usercreate(String uuid) async {
    final responce = await http.post(
      ApiRoot.userCreate(),
      body: {
        'uuid': FirebaseAuth.instance.currentUser?.uid ?? '',
        'name': 'takato',
      },
    );
    final data = responce.body;
    return data;
  }

  Future usernameUpdate(String username, String pk) async {
    final response = await http.put(
      ApiRoot.userUpdate(pk),
      body: {
        'name': username,
      },
    );
    final data = response.body;
    return data;
  }

  Future userlist() async {
    final responce = await http.get(
      ApiRoot.userList(),
    );
    final data = responce.body;
    return data;
  }

  Future userdisplayupdate(List displayuser, int pk) async {
    final response = await http.patch(
      ApiRoot.userDisplayUpdate(pk),
      body: {
        'displayuser': displayuser,
      },
    );
    final data = response.body;
    return data;
  }

  Future getnotificationtarget(String uuid) async {
    final response = await http.get(ApiRoot.getNotificationTarget(uuid));
    final jsonlist = jsonDecode(response.body)['todo'];
    final datalist = jsonDecode(jsonlist);
    return datalist;
  }

  Future gettargetlength(String uuid) async {
    final response = await http.get(ApiRoot.getopacitylength(uuid));
    final jsonlist = jsonDecode(response.body)['listlen'];
    return jsonlist;
  }
}
