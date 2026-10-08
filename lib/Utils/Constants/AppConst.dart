import 'package:get/get.dart';
import 'package:new_music_app/Utils/Constants/AppExtension.dart';

class AppConst {
  static int menuId = 30;
  static String menuType = 'VideosCategory';
  static RxBool liveVideoUrl = false.obs;
  static BottomDisplay bottomDisplay = BottomDisplay.none;
  // START_TAB is only passed for App Store screenshot builds; defaults to Home.
  static int currentTabIndex = const int.fromEnvironment("START_TAB");
  static String LiveUrl = '';
  static String poweredBy = 'DURISIMO APP STORE';
}
