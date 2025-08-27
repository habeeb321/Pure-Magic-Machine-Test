import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_magic/controller/home_controller.dart';
import 'package:pure_magic/model/get_all_products_model.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen(this.index, {super.key});

  final int index;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final product = controller.products[index];
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLandscape && !isTablet
          ? _buildLandscapeLayout(context, product, size)
          : _buildPortraitLayout(context, product, size, isTablet),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, GetAllProductsModel product,
      Size size, bool isTablet) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, product, size, isTablet),
        SliverToBoxAdapter(
          child: _buildBody(product, context, size, isTablet),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
      BuildContext context, GetAllProductsModel product, Size size) {
    final imageWidth = size.width * 0.45;
    final contentWidth = size.width * 0.55;

    return SafeArea(
      child: Row(
        children: [
          // Image Section
          Container(
            width: imageWidth,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[100]!,
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'product_image_$index',
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 25,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            product.image ?? '',
                            fit: BoxFit.cover,
                            width: imageWidth * 0.7,
                            height: imageWidth * 0.7,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: imageWidth * 0.7,
                                height: imageWidth * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: imageWidth * 0.7,
                                height: imageWidth * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(24),
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
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Container(
            width: contentWidth,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: _buildContentSection(product, context, size, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, GetAllProductsModel product,
      Size size, bool isTablet) {
    final expandedHeight = isTablet ? 450.0 : 350.0;
    final imageSize = isTablet ? size.width * 0.5 : size.width * 0.7;
    final maxImageSize = isTablet ? 400.0 : 280.0;
    final finalImageSize = imageSize > maxImageSize ? maxImageSize : imageSize;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[100]!,
                Colors.white,
              ],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'product_image_$index',
              child: Container(
                margin: EdgeInsets.all(isTablet ? 40 : 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.fill,
                    width: finalImageSize,
                    height: finalImageSize,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: finalImageSize,
                        height: finalImageSize,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: isTablet ? 100 : 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: finalImageSize,
                        height: finalImageSize,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(GetAllProductsModel product, BuildContext context,
      Size size, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.1 : 24,
          vertical: isTablet ? 48 : 32,
        ).copyWith(
          top: isTablet ? 48 : 32,
          bottom: isTablet ? 60 : 40,
        ),
        child: _buildContentSection(product, context, size, isTablet),
      ),
    );
  }

  Widget _buildContentSection(GetAllProductsModel product, BuildContext context,
      Size size, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag indicator (only for portrait mode)
        if (!isTablet && size.width <= size.height)
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        if (!isTablet && size.width <= size.height)
          SizedBox(height: isTablet ? 40 : 32),

        // Product Title
        Text(
          product.title ?? '',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(size, isTablet, 28, 32, 24),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),

        // Price Section
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
          ),
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[50]!,
                Colors.blue[100]!.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(size, isTablet, 16, 18, 14),
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                '₹${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(size, isTablet, 36, 42, 32),
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 40 : 32),

        // Description Section
        Text(
          'Description',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(size, isTablet, 22, 26, 20),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isTablet ? 20 : 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Text(
            product.description ?? 'No description available.',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(size, isTablet, 17, 19, 15),
              color: Colors.black87,
              height: 1.7,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  double _getResponsiveFontSize(
      Size size, bool isTablet, double base, double tablet, double small) {
    if (isTablet) return tablet;
    if (size.width < 360) return small;
    return base;
  }
}
