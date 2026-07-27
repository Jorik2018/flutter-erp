// Singleton to manage Users
import 'package:flutter_erp/apps/trovami/core/Group.dart';
import 'package:flutter_erp/apps/trovami/core/OldUser.dart';

class GroupsManager {
  //  Map _items = LinkedHashMap<String, FileImage>();

  static final GroupsManager _instance = GroupsManager._internal();

  factory GroupsManager() {
    return _instance;
  }

  Group _currentGroup = Group();

  GroupsManager._internal();

  List<OldUser> users = [];

  Group currentGroup() {
    return _currentGroup;
  }
}
