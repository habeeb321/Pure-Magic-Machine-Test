import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_magic/controller/home_controller.dart';
import 'package:pure_magic/view/product_detail_screen.dart';
import 'package:pure_magic/view/widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Obx(
        () => controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const CustomTextField(
                    placeholder: 'Search',
                    prefixIcon: CupertinoIcons.search,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.products.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        var products = controller.products[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(index),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '${products.image}',
                              fit: BoxFit.fill,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(
                            '${products.title}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text('₹${products.price}'),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: const Text(
        'Products',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
