
import 'package:biz_zinda/view/Shop/shop_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopVM = context.watch<ShopViewModel>();
    final shop = shopVM.shopModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Dashboard"),
        backgroundColor: const Color(0xFFFB8C00),
      ),
      body: shop == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🏪 SHOP HEADER CARD
              _shopHeader(shop),

              const SizedBox(height: 15),

              /// 📊 STATS CARDS
              _statsRow(),

              const SizedBox(height: 15),

              /// 🛍 PRODUCTS
              _sectionCard(
                title: "Products",
                icon: Icons.shopping_bag,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              /// 🛠 SERVICES
              _sectionCard(
                title: "Services",
                icon: Icons.build,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              /// 📦 ORDERS (future)
              _sectionCard(
                title: "Orders",
                icon: Icons.receipt_long,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏪 SHOP HEADER
  Widget _shopHeader(shop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFB8C00), Color(0xFFFFB74D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shop.shopName ?? "Shop Name",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Owner: ${shop.ownerName ?? ''}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            shop.address ?? '',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// 📊 STATS
  Widget _statsRow() {
    return Row(
      children: [
        _statCard("Products", "10"),
        _statCard("Services", "5"),
        _statCard("Orders", "2"),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  /// 📦 SECTION CARD
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFB8C00)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}