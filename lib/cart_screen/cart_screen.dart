import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_magic/home_screen/controller/home_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return SafeArea(
      child: Obx(
        () => controller.cartItems.isEmpty
            ? _buildEmptyCart(context, isTablet)
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? size.width * 0.05 : 16,
                        vertical: 16,
                      ),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.cartItems.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: isTablet ? 16 : 12),
                        itemBuilder: (context, index) {
                          final item = controller.cartItems[index];
                          return _buildCartItemCard(
                              context, item, index, isTablet);
                        },
                      ),
                    ),
                  ),
                  _buildTotalSection(context, isTablet),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, bool isTablet) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.1 : 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: isTablet ? 120 : 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(size, isTablet, 20, 24, 18),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              'Add some products to get started!',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(size, isTablet, 16, 18, 14),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
      BuildContext context, dynamic item, int index, bool isTablet) {
    final size = MediaQuery.of(context).size;
    final imageSize = isTablet ? 80.0 : 60.0;

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.image ?? '',
                fit: BoxFit.cover,
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
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize:
                          _getResponsiveFontSize(size, isTablet, 16, 18, 14),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '₹${item.price?.toStringAsFixed(2) ?? 'N/A'}',
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
            Container(
              margin: EdgeInsets.only(left: isTablet ? 12 : 8),
              child: Material(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => controller.removeFromCart(item),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 12 : 10),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[600],
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, bool isTablet) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? size.width * 0.05 : 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(size, isTablet, 18, 22, 16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₹${controller.totalCartPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize:
                        _getResponsiveFontSize(size, isTablet, 20, 24, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ],
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
        'Shopping Cart',
        style: TextStyle(
          fontSize: _getResponsiveFontSize(size, isTablet, 22, 26, 20),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        Obx(
          () => controller.cartItems.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  icon: const Icon(
                    Icons.clear_all,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (isTablet) const SizedBox(width: 8),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear Cart',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(size, isTablet, 18, 20, 16),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(size, isTablet, 14, 16, 12),
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: _getResponsiveFontSize(size, isTablet, 14, 16, 12),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Navigator.pop(context);
              Get.snackbar(
                'Cart Cleared',
                'All items have been removed from your cart',
                backgroundColor: Colors.red[50],
                colorText: Colors.red[700],
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(size, isTablet, 14, 16, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getResponsiveFontSize(
      Size size, bool isTablet, double base, double tablet, double small) {
    if (isTablet) return tablet;
    if (size.width < 360) return small;
    return base;
  }
}
