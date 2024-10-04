// Create an admin screen
import 'package:building_material_retail/app/pages/admin_add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product.dart';
import '../../widgets/product_item.dart';
import '../providers.dart';
import 'admin_cart.dart';
import 'admin_product_detail.dart';

class AdminHome extends ConsumerWidget {
  final searchControllerProvider = Provider<TextEditingController>((ref) {
    return TextEditingController();
  });

  AdminHome({super.key});

  @override
  Widget build(BuildContext context, ref) {
    double screenWidth = MediaQuery.of(context).size.width; // get screen width
    double screenHeight =
        MediaQuery.of(context).size.height; // get screen height
    double padding = 18.0; // set padding

    // ref.watch(cartProvider.notifier).itemCount.toString(),
    final cartCount = ref.watch(cartProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu giá VLXD'),
        actions: [
          IconButton(
              onPressed: () => ref.read(firebaseAuthProvider).signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
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
              // Thực hiện hành động khi nút được nhấn
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // freature of lodging management
            Container(
              //list feature
              child: Column(
                children: [
                  //Search bar
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SearchBar(
                        onSubmitted: (value) {
                          //set search controller
                          ref.read(searchControllerProvider).text = value;
                        },
                        leading: const Icon(Icons.search),
                        controller: ref.read(searchControllerProvider),
                        hintText: "Tìm kiếm sản phẩm",
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              ref.read(searchControllerProvider).clear();
                            },
                          ),
                        ]),
                  ),

                  const SizedBox(height: 10),

                  // 1st row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Add Lodging
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminAddProductPage(),
                              ));
                        },
                        child: Card(
                          // Size of card
                          color: Colors.blue,
                          elevation: 5, // shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.5 - padding * 2,
                            height: screenHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add),
                                Text(
                                  'Thêm vật tư',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Edit Lodging
                      GestureDetector(
                        onTap: () {
                          ref.watch(cartProvider.notifier).clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã xóa tất cả sản phẩm'),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.orange,
                          elevation: 5, // shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.5 - padding * 2,
                            height: screenHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.info),
                                Text('Tạo đơn báo giá mới',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //List of products
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 350,
              child: StreamBuilder<List<Product>>(
                stream: ref.read(databaseProvider)!.searchProduct(
                    searchTerm: ref.read(searchControllerProvider).text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            debugPrint('Tapped');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                          child: ProductItem(product: product, ref: ref),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text("Loading..."),
                  );
                },
              ),
            ),

            //add more space to scroll bottom
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
