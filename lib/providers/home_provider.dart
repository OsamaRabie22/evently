import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  int selectedIndex=0;
  changSelectedIndex(int index){
    selectedIndex=index;
    notifyListeners();
  }
}