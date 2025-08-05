import 'package:shared_preferences/shared_preferences.dart';

class CarelistStorageService {
  final String key;

  CarelistStorageService(this.key);

  // 取得目前的 List<String>
  Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  // 新增一個元素
  Future<void> add(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    if (!list.contains(value)) {
      list.add(value);
      await prefs.setStringList(key, list);
    }
  }

  // 刪除一個元素
  Future<void> remove(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    list.remove(value);
    await prefs.setStringList(key, list);
  }

  // 清除所有資料
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  
}
