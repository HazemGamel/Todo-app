import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  
  final GetStorage _box= GetStorage();
  final _key="isDarkMode";
  
  savemode(bool isDarkMode){
    _box.write(_key, isDarkMode);
  }
 bool _loadmode(){
  return _box.read<bool>(_key)?? false;
  }
  ThemeMode get theme => _loadmode() ?ThemeMode.dark :ThemeMode.light;
  void switchmode(){
    Get.changeThemeMode(_loadmode()? ThemeMode.light :ThemeMode.dark);
    savemode(!_loadmode());
  }
}
