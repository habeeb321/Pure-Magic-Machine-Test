import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_magic/home_screen/controller/home_controller.dart';
import 'package:pure_magic/home_screen/view/product_detail_screen.dart';
import 'package:pure_magic/home_screen/view/widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllProducts();
    });
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final crossAxisCount = _getCrossAxisCount(size.width);
    final isGridView = crossAxisCount > 1;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.05 : 16,
          vertical: 16,
        ),
        child: Obx(
          () => controller.loading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Column(
                  children: [
                    _buildSearchSection(context, isTablet),
                    SizedBox(height: isTablet ? 24 : 16),
                    Expanded(
                      child: isGridView
                          ? _buildGridView(context, crossAxisCount, isTablet)
                          : _buildListView(context, isTablet),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isTablet ? 600 : double.infinity,
      ),
      child: CustomTextField(
        onChanged: controller.updateSearchField,
        placeholder: 'Search filteredProducts...',
        prefixIcon: CupertinoIcons.search,
      ),
    );
  }

  Widget _buildGridView(
      BuildContext context, int crossAxisCount, bool isTablet) {
    final size = MediaQuery.of(context).size;
    final childAspectRatio = _getChildAspectRatio(size.width, crossAxisCount);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isTablet ? 20 : 12,
        mainAxisSpacing: isTablet ? 20 : 12,
      ),
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        var product = controller.filteredProducts[index];
        return _buildProductCard(context, product, index, isTablet, true);
      },
    );
  }

  Widget _buildListView(BuildContext context, bool isTablet) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.filteredProducts.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: isTablet ? 16 : 12),
      itemBuilder: (context, index) {
        var product = controller.filteredProducts[index];
        return _buildProductCard(context, product, index, isTablet, false);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product, int index,
      bool isTablet, bool isGridItem) {
    final size = MediaQuery.of(context).size;
    final imageSize =
        isGridItem ? (isTablet ? 120.0 : 80.0) : (isTablet ? 80.0 : 60.0);

    if (isGridItem) {
      return Hero(
        tag: 'product_hero_$index',
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _navigateToDetail(context, index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.image ?? '',
                          fit: BoxFit.fill,
                          width: imageSize,
                          height: imageSize,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                size: imageSize * 0.4,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title ?? '',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(
                                size, isTablet, 14, 16, 12),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '₹${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(
                                  size, isTablet, 13, 15, 11),
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Hero(
        tag: 'product_hero_$index',
        child: Card(
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.1),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            onTap: () => _navigateToDetail(context, index),
            contentPadding: EdgeInsets.all(isTablet ? 16 : 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.fill,
                width: imageSize,
                height: imageSize,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: imageSize * 0.5,
                      color: Colors.grey[400],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            title: Text(
              product.title ?? '',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(size, isTablet, 16, 18, 14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '₹${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(
                        fontSize:
                            _getResponsiveFontSize(size, isTablet, 14, 16, 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isTablet ? 20 : 16,
              color: Colors.grey[400],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }
  }

  void _navigateToDetail(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(index),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Products',
        style: TextStyle(
          fontSize: _getResponsiveFontSize(size, isTablet, 22, 26, 20),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: isTablet
          ? [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
            ]
          : null,
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double _getChildAspectRatio(double width, int crossAxisCount) {
    if (crossAxisCount == 1) return 3.5;
    if (width > 800) return 0.8;
    return 0.75;
  }

  double _getResponsiveFontSize(
      Size size, bool isTablet, double base, double tablet, double small) {
    if (isTablet) return tablet;
    if (size.width < 360) return small;
    return base;
  }
}
