class Todo {
  Todo(
    this.title,
    this.content,
    this.deadline,
    this.owner,
  );
  factory Todo.fromMap(Map<String, dynamic> value) {
    final edges = value['edges']['owner'][0];
    final todo = Todo(
      value['title'],
      value['content'] ?? '',
      DateTime.parse(value['deadline']),
      Owner(
        edges['name'],
        edges['myuuid'],
      ),
    );
    todo.imagePath = value['image_path'];
    return todo;
  }
  final String title;
  final String? content;
  final DateTime deadline;
  final Owner owner;
  late String? imagePath;
}

class Owner {
  Owner(
    this.name,
    this.uuid,
  );
  factory Owner.fromJson(Map<String, dynamic> value) {
    return Owner(
      value['name'],
      value['myuuid'],
    );
  }
  final String name;
  final String uuid;
}
