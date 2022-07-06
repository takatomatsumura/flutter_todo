import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'api_root.dart';
import 'echo_handler.dart';
// import 'notification_handler.dart';
import 'todo.dart';

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
              Navigator.pushNamed(
                context,
                '/setting',
              );
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
  final contentController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final imagePicker = ImagePicker();
  XFile? image;
  final datetimeformat = DateFormat('y-M-d HH:mm');
  String uuid = '';
  var _todouser;
  Todo? todo;
  Map<String, dynamic> formValue = {};
  static final dateformat = DateFormat('y-M-d');
  static final timeformat = DateFormat('HH:mm');

  Future<XFile?> getImageCamera() async {
    image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image is XFile) {
      setState(
        () {
          final selectedImage = File(image!.path);
          formValue['image'] = MultipartFile(
            'picture',
            selectedImage.readAsBytes().asStream(),
            selectedImage.lengthSync(),
            filename: selectedImage.path.split('/').last,
          );
        },
      );
    }
    return image;
  }

  Future<XFile?> getImageGararry() async {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image is XFile) {
      setState(
        () {
          formValue['image'] = File(image!.path);
        },
      );
    }
    return image;
  }

  @override
  void initState() {
    super.initState();
    if (_id != '') {
      Future(
        () async {
          todo = await EchiRequest().retrieveTodo(_id);
          titleController.text = todo!.title;
          formValue['title'] = todo!.title;
          contentController.text = todo!.content ?? '';
          formValue['content'] = todo!.content;
          dateController.text = dateformat.format(todo!.deadline);
          formValue['deadline'] = todo!.deadline.toString();
          timeController.text = timeformat.format(todo!.deadline);
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
                      onSaved: (value) => formValue['title'] = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: contentController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '内容',
                        labelText: '内容',
                        filled: true,
                      ),
                      validator: (contentValue) {
                        if (contentValue == null || contentValue.isEmpty) {
                          return '必須項目です';
                        } else if (200 <= contentValue.length) {
                          return '200文字までしか入力できません。';
                        }
                        return null;
                      },
                      onSaved: (value) => formValue['content'] = value,
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
                        dateController.text = dateformat.format(selectedDate!);
                        formValue['date'] = selectedDate;
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
                        final selectedValue = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            selectedTime!.hour,
                            selectedTime.minute);
                        timeController.text = timeformat.format(selectedValue);
                        formValue['dayTime'] = selectedTime;
                      },
                    ),
                  ),
                  Column(
                    children: [
                      if (formValue['image'] is MultipartFile)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.file(File(image!.path)),
                        )
                      else if (todo?.imagePath != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.network(
                            ApiRoot.staticPath().toString() + todo!.imagePath!,
                          ),
                        )
                      else
                        const Text('画像は選択されていません'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 30,
                            onPressed: () async {
                              await getImageCamera();
                            },
                            icon: const Icon(Icons.camera),
                          ),
                          IconButton(
                            iconSize: 30,
                            onPressed: () async {
                              await getImageGararry();
                            },
                            icon: const Icon(Icons.photo),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: const Text('保存'),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        if (!formValue.containsKey('deadline')) {
                          formValue['deadline'] = DateTime(
                            formValue['date'].year,
                            formValue['date'].month,
                            formValue['date'].day,
                            formValue['dayTime'].hour,
                            formValue['dayTime'].minute,
                          ).toString();
                          formValue.remove('date');
                          formValue.remove('dayTime');
                        }
                        uuid = FirebaseAuth.instance.currentUser?.uid ?? '';
                        _todouser = await EchiRequest().userRetrieve(uuid);
                        formValue['owner'] = _todouser['myuuid'];
                        if (_id == '') {
                          // await Notificationoperation().notification();
                          await EchiRequest().createTodo(formValue
                              // titleController.text,
                              // // '$datestring $timestring',
                              // DateTime(),
                              // _todouser['myuuid'],
                              // _requestimage,
                              );
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home',
                            (_) => false,
                          );
                        } else {
                          // await Notificationoperation().notification();
                          await EchiRequest().updatetodo(
                            formValue,
                            _id,
                            //   _id,
                            //   titleController.text,
                            //   '${dateController.text} ${timeController.text}',
                            //   _todouser['myuuid'],
                            //   // _requestimage,
                          );
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
