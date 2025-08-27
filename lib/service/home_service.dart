import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pure_magic/model/get_all_products_model.dart';

class HomeService {
  final Dio dio = Dio();

  Future<List<GetAllProductsModel>?> getAllProducts() async {
    try {
      Response response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200 && response.data != null) {
        debugPrint('Success: ${response.data}');
        if (response.data is String) {
          List<dynamic> data = jsonDecode(response.data);
          return data.map((x) => GetAllProductsModel.fromJson(x)).toList();
        } else if (response.data is List) {
          List<dynamic> data = response.data;
          return data.map((x) => GetAllProductsModel.fromJson(x)).toList();
        } else {
          debugPrint('Unexpected response format');
          return null;
        }
      } else {
        debugPrint('HTTP Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('getAllProducts Error : $e');
    }
    return null;
  }
}
