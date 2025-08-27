import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:pure_magic/home_screen/model/get_all_products_model.dart';
import 'package:pure_magic/home_screen/service/home_service.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<GetAllProductsModel> products = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;
  final loading = false.obs;
  RxSet<int> favoriteIndices = <int>{}.obs;
  RxList<GetAllProductsModel> cartItems = <GetAllProductsModel>[].obs;

  void addToCart(GetAllProductsModel product) {
    cartItems.add(product);
  }

  void removeFromCart(GetAllProductsModel product) {
    cartItems.remove(product);
  }

  void clearCart() {
    cartItems.clear();
  }

  void updateSearchField(String searchQuery) {
    if (searchQuery.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) {
        final title = product.title?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        return title.contains(query);
      }).toList();
    }
  }

  double get totalCartPrice =>
      cartItems.fold(0.0, (sum, item) => sum + (item.price ?? 0.0));

  Future<void> fetchAllProducts() async {
    loading.value = true;
    try {
      List<GetAllProductsModel>? result = await HomeService().getAllProducts();
      if (result != null) {
        products.value = result;
        filteredProducts.value = result;
      }
    } catch (e) {
      debugPrint('fetchAllProducts Error: $e');
    }
    loading.value = false;
  }

  bool isFavorite(int index) => favoriteIndices.contains(index);

  void toggleFavorite(int index) {
    if (favoriteIndices.contains(index)) {
      favoriteIndices.remove(index);
    } else {
      favoriteIndices.add(index);
    }
  }
}
