import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'echo_handler.dart';
import 'notification_handler.dart';

var _id;

class FormPage extends StatelessWidget {
  const FormPage({super.key});
  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            iconSize: 40,
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      body: const _FormPageWidget(),
    );
  }
}

class _FormPageWidget extends StatefulWidget {
  const _FormPageWidget();

  @override
  _FormPageStateWidget createState() => _FormPageStateWidget();
}

class _FormPageStateWidget extends State<_FormPageWidget> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final datetimeformat = DateFormat('y-M-d HH:mm');
  String minute = '';
  String hour = '';
  String datestring = '';
  String timestring = '';
  // var _image;
  // final picker = ImagePicker();
  String uuid = '';
  String detailimage = '';
  var _todouser;
  var _detail;
  final dateformat = DateFormat('y-M-d');
  final timeformat = DateFormat('HH:mm');
  // var _requestimage;
  // String? _imageurl;

  // Future _getImagecamera() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   setState(
  //     () {
  //       if (pickedFile != null) {
  //         _image = File(pickedFile.path);
  //         _requestimage = pickedFile.path;
  //       }
  //     },
  //   );
  // }

  // Future _getImagegallery() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(
  //     () {
  //       if (pickedFile != null) {
  //         _image = File(pickedFile.path);
  //         _requestimage = pickedFile.path;
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    if (_id != '') {
      Future(
        () async {
          _detail = await DrfDatabase().retrievetodo(_id);
          titleController.text = _detail['title'];
          dateController.text = dateformat.format(
            DateTime.parse(_detail['date']).add(
              const Duration(hours: 9),
            ),
          );
          timeController.text = timeformat.format(
            DateTime.parse(_detail['date']).add(
              const Duration(hours: 9),
            ),
          );
          // _imageurl = _detail['image'];
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'タイトル',
                        labelText: 'タイトル',
                        filled: true,
                      ),
                      validator: (titlevalue) {
                        if (titlevalue == null || titlevalue.isEmpty) {
                          return '必須項目です';
                        } else if (200 <= titlevalue.length) {
                          return '200文字までしか入力できません。';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〆切日時',
                        labelText: '〆切日時',
                        filled: true,
                      ),
                      validator: (datevalue) {
                        if (datevalue == null || datevalue.isEmpty) {
                          return '必須項目です';
                        }
                        return null;
                      },
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (selectedDate != null) {
                          datestring =
                              dateformat.format(selectedDate).toString();
                        }
                        dateController.text = dateformat.format(selectedDate!);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〆切時間',
                        labelText: '〆切時間',
                        filled: true,
                      ),
                      validator: (timevalue) {
                        if (timevalue == null || timevalue.isEmpty) {
                          return '必須項目です';
                        }
                        return null;
                      },
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          if (selectedTime.minute < 10) {
                            minute = '0${selectedTime.minute}';
                          } else {
                            minute = '${selectedTime.minute}';
                          }
                          if (selectedTime.hour > 9) {
                            hour = '${selectedTime.hour}';
                          } else {
                            hour = '0${selectedTime.hour}';
                          }
                          timestring = '$hour:$minute';
                        }
                        timeController.text = timestring;
                      },
                    ),
                  ),
                  // _image == null
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: _imageurl == null
                  //             ? const Text('画像が選択されていません。')
                  //             : ConstrainedBox(
                  //                 constraints: const BoxConstraints(
                  //                     maxHeight: 300, maxWidth: 300),
                  //                 child: Image.network(_imageurl!),
                  //               ),
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ConstrainedBox(
                  //           constraints: const BoxConstraints(
                  //               maxHeight: 300, maxWidth: 300),
                  //           child: Image.file(_image),
                  //         ),
                  //       ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Colors.blue,
                  //         onPrimary: Colors.white,
                  //         shape: const CircleBorder(),
                  //       ),
                  //       onPressed: _getImagecamera,
                  //       child: const Icon(Icons.camera_alt),
                  //     ),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Colors.blue,
                  //         onPrimary: Colors.white,
                  //         shape: const CircleBorder(),
                  //       ),
                  //       onPressed: _getImagegallery,
                  //       child: const Icon(Icons.photo),
                  //     ),
                  //   ],
                  // ),
                  ElevatedButton(
                    child: const Text('保存'),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        uuid = FirebaseAuth.instance.currentUser?.uid ?? '';
                        // _todouser = await DrfDatabase().userretrieve(uuid);
                        if (_id == '') {
                          // await Notificationoperation().notification();
                          // await DrfDatabase().createtodo(
                          //   titleController.text,
                          //   '$datestring $timestring',
                          //   _todouser['id'],
                          //   // _requestimage,
                          // );
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home',
                            (_) => false,
                          );
                        } else {
                          // await Notificationoperation().notification();
                          // await DrfDatabase().updatetodo(
                          //   _id,
                          //   titleController.text,
                          //   '${dateController.text} ${timeController.text}',
                          //   _todouser['id'],
                          // _requestimage,
                          // );
                          await Navigator.of(context).pushNamed(
                            '/detail',
                            arguments: _id,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
