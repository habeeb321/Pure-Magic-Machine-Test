import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_magic/bottom_navigation/controller/bottom_nav_controller.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                size: size.width * 0.065,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_checkout,
                size: size.width * 0.065,
              ),
              label: 'Cart',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: size.width * 0.035,
          ),
          elevation: 50,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        ),
      ),
    );
  }
}
