import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'echo_handler.dart';

String _uuid = '';
Map<String, dynamic> _user = {};
Map<String, dynamic> _detail = {};
Widget _editbutton = Container();

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future(
      () async {
        final id = ModalRoute.of(context)!.settings.arguments;
        _detail = await DrfDatabase().retrievetodo(id);
        _uuid = FirebaseAuth.instance.currentUser?.uid.toString() ?? '';
        _user = await DrfDatabase().userretrieve(_uuid);
        if (_detail['owner']['id'] == _user['id']) {
          _editbutton = FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/form',
                arguments: id,
              );
            },
            child: const Icon(Icons.edit),
          );
          setState(() {});
        } else {
          _editbutton = Container();
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (_) => false,
            );
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
      body: Detail(),
      floatingActionButton: _editbutton,
    );
  }
}

class Detail extends StatelessWidget {
  Detail({super.key});
  final datetimeformat = DateFormat('y-M-d HH:mm');
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    return ListView(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: DrfDatabase().retrievetodo(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  height: 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('タイトル：'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              "${data!['title']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('〆切日時：'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            datetimeformat.format(
                              DateTime.parse(
                                data['date'],
                              ).add(
                                const Duration(hours: 9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('作成者　：'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data['owner']['name']}',
                          ),
                        ),
                      ],
                    ),
                    const Text('画像'),
                    data['image'] == null
                        ? const Text('画像はありません')
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 300,
                            ),
                            child: Image.network(
                              data['image'],
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}