import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class DrfDatabase {
  final dio = Dio();
  List datalist = [];
  var data;
  // final domain = '10.0.2.2:8000';
  final domain = '18.180.75.44';

  Future gettodolist(int index, String uuid) async {
    final response = await dio.get(
      'http://$domain/todos/todolist/$index/$uuid',
    );
    return response.data['todo'];
  }

  Future getopacitylength(String uuid) async {
    final response = await dio.get(
      'http://$domain/todos/todolist/len/$uuid',
    );
    final jsonlist = response.data['listlen'];
    return jsonlist;
  }

  // ignore: type_annotate_public_apis
  Future<Map<String, dynamic>> retrievetodo(var index) async {
    final responce = await dio.get(
      'http://$domain/todos/retrieve/$index',
    );
    data = responce.data as Map<String, dynamic>;
    return data;
  }

  // ignore: type_annotate_public_apis
  Future createtodo(String title, String date, int owner) async {
    // var _requestimage;
    // if (_image != null) {
    //   _requestimage = await MultipartFile.fromFile(_image,
    //       filename: '$_title${_date}image.jpeg');
    // }
    final response = await dio.post(
      'http://$domain/todos/create',
      data: FormData.fromMap(
        {
          'title': title,
          'date': date,
          'owner': owner,
          // 'image': _requestimage,
        },
      ),
    );
    data = response.data;
  }

  Future updatetodo(int index, String title, String date, int owner) async {
    // var _requestimage;
    // if (_image != null) {
    //   _requestimage = await MultipartFile.fromFile(_image,
    //       filename: '$_title${_date}image.jpeg');
    // }
    final response = await dio.patch(
      'http://$domain/todos/update/$index',
      data: FormData.fromMap(
        {
          'title': title,
          'date': date,
          'owner': owner,
          // 'image': _requestimage,
        },
      ),
    );
    data = response.data;
  }

  Future boolchange(int pk, {required bool boolvalue}) async {
    final response = await dio.patch(
      'http://$domain/todos/donebool/$pk',
      data: {
        'donebool': boolvalue,
      },
    );
    data = response.data;
  }

  Future deletetodo(int pk) async {
    final responce = await dio.delete(
      'http://$domain/todos/delete/$pk',
    );
    data = responce.data;
  }

  Future userretrieve(String uuid) async {
    final responce = await dio.get(
      'http://$domain/todos/user/retrieve/$uuid',
    );
    return responce.data['todouser'];
  }

  Future usercreate(String uuid) async {
    final responce = await dio.post(
      'http://$domain/todos/user/create',
      data: {
        'uuid': uuid,
        'name': 'name',
      },
    );
    data = responce.data;
  }

  Future usernameupdate(String username, int pk) async {
    final response = await dio.patch(
      'http://$domain/todos/user/update/$pk',
      data: {
        'name': username,
      },
    );
    data = response.data;
  }

  Future userlist() async {
    final responce = await dio.get(
      'http://$domain/todos/user/list',
    );
    data = responce.data;
    return data;
  }

  Future userdisplayupdate(List displayuser, int pk) async {
    final response = await dio.patch(
      'http://$domain/todos/user/update/$pk',
      data: {
        'displayuser': displayuser,
      },
    );
    data = response.data;
  }

  Future getnotificationtarget(String uuid) async {
    final response = await dio.get(
      'http://$domain/todos/notificationtarget/$uuid',
    );
    final jsonlist = response.data['todo'];
    final datalist = jsonDecode(jsonlist);
    return datalist;
  }

  Future gettargetlength(String uuid) async {
    final response = await dio.get(
      'http://$domain/todos/notification/overdue/$uuid',
    );
    final jsonlist = response.data['listlen'];
    return jsonlist;
  }
}
