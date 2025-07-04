// Create an admin screen
import 'package:building_material_retail/app/pages/cart/admin_cart.dart';
import 'package:building_material_retail/app/pages/product_manage/product_management.dart';
import 'package:building_material_retail/app/pages/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/product.dart';
import '../../widgets/product-item.dart';
import '../../providers/providers.dart';

class AdminHome extends ConsumerStatefulWidget {
  AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  final searchControllerProvider = Provider<TextEditingController>((ref) {
    return TextEditingController();
  });

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = 18.0;
    final cartCount = ref.watch(cartProvider).length;

    final List<Widget> _pages = [
      // Home page (product management + product list)
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProductManagement(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              padding: padding,
              searchControllerProvider: searchControllerProvider,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 500,
              child: ref.read(databaseProvider) == null
                  ? const Center(
                      child: Text("Bạn chưa đăng nhập hoặc session chưa sẵn sàng."),
                    )
                  : StreamBuilder<List<Product>>(
                      stream: ref.read(databaseProvider)!.getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Lỗi: ${snapshot.error}"));
                        }
                        if ((snapshot.connectionState == ConnectionState.active ||
                                snapshot.connectionState == ConnectionState.done) &&
                            snapshot.data != null) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(child: Text("Không có sản phẩm nào."));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final product = snapshot.data![index];
                                return ProductItem(product: product, ref: ref);
                              });
                        }
                        return const Center(
                          child: Text("Loading..."),
                        );
                      }),
            ),
          ],
        ),
      ),
      // Dashboard page
      const DashboardPage(),
      // Settings page (placeholder)
      const Center(child: Text('Cài đặt', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu giá VLXD'),
        actions: [
          IconButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: const Icon(Icons.shopping_cart),
          ),
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                cartCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
