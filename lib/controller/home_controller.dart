import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:pure_magic/model/get_all_products_model.dart';
import 'package:pure_magic/service/home_service.dart';

class HomeController extends GetxController {
  RxList<GetAllProductsModel> products = <GetAllProductsModel>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    fetchAllProducts();
    super.onInit();
  }

  Future<void> fetchAllProducts() async {
    loading.value = true;
    try {
      List<GetAllProductsModel>? result = await HomeService().getAllProducts();
      if (result != null) {
        products.value = result;
      }
    } catch (e) {
      debugPrint('fetchAllProducts Error: $e');
    }
    loading.value = false;
  }
}
