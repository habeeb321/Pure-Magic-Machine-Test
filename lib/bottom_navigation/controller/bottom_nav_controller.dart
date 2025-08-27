import 'package:get/get.dart';
import 'package:pure_magic/cart_screen/cart_screen.dart';
import 'package:pure_magic/home_screen/view/home_screen.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List screens = [
    HomeScreen(),
    CartScreen(),
  ];

  int onItemTapped(int index) {
    return selectedIndex.value = index;
  }
}
