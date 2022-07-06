class ApiRoot {
  static const domain = '10.0.2.2';
  static const apiURL = 'http://$domain:8000';
  static Uri getTodoList(index, uuid) => index == 0
      ? Uri.parse('$apiURL/todos/todolist/$uuid?complete=false')
      : Uri.parse('$apiURL/todos/todolist/$uuid?complete=true');
  static Uri getopacitylength(uuid) =>
      Uri.parse('$apiURL/todos/todolist/len/$uuid');
  static Uri retrieveTodo(index) => Uri.parse('$apiURL/todos/$index');
  static Uri createTodo() => Uri.parse('$apiURL/todos/create');
  static Uri updateTodo(index) => Uri.parse('$apiURL/todos/$index');
  static Uri boolChange(pk) => Uri.parse('$apiURL/todos/donebool/$pk');
  static Uri deleteTodo(pk) => Uri.parse('$apiURL/todos/$pk');
  static Uri userRetreive(uuid) => Uri.parse('$apiURL/accounts/user/$uuid');
  static Uri userCreate() => Uri.parse('$apiURL/accounts/user');
  static Uri userUpdate(pk) => Uri.parse('$apiURL/accounts/user/$pk');
  static Uri userList() => Uri.parse('$apiURL/accounts/user');
  static Uri userDisplayUpdate(pk) =>
      Uri.parse('$apiURL/todos/accounts/update/$pk');
  static Uri getNotificationTarget(uuid) =>
      Uri.parse('$apiURL/todos/notification/overdue/$uuid');
  static Uri gettargetLength(uuid) =>
      Uri.parse('$apiURL/todos/notification/overdue/$uuid');
  static Uri staticPath() => Uri.parse('$apiURL/media/images');
}
