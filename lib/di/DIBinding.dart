import 'package:get/get.dart';
import 'package:http/http.dart';

class DIBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => HomeBloc());
    //
    // Get.lazyPut(() => FriendsBloc());
    // Get.lazyPut(() => ChatListBloc());
    // Get.lazyPut(() => FriendsRepository());
    // Get.lazyPut(() => ChatListRepository());
    // Get.lazyPut(() => ChatRepository());
    //
    // // Provider
    // Get.lazyPut(() => FriendsProvider());
    // Get.lazyPut(() => ChatListProvider());
    // Get.lazyPut(() => ChatProvider());

    // Network
    Get.lazyPut(() => Client());
  }
}
