// Create an admin screen
import 'package:building_material_retail/app/pages/admin_add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product.dart';
import '../../widgets/product_item.dart';
import '../providers.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu giá VLXD'),
        actions: [
          IconButton(
              onPressed: () => ref.read(firebaseAuthProvider).signOut(),
              icon: const Icon(Icons.logout))
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
                  SearchBar(
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

                  SizedBox(height: 10),

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
                          print('Sửa vật tư');

                          // //Choose boarding
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (context) {
                          //     return SizedBox();
                          //   },
                          // );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => EditBoardingPage(),
                          //     ));
                        },
                        child: Card(
                          color: Colors.green,
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
                                const Icon(Icons.edit),
                                Text('Cập nhật giá',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 2nd row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Add Lodging
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => DeleteBoardingPage(),
                          //     ));
                        },
                        child: Card(
                          color: Colors.red,
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
                                const Icon(Icons.edit),
                                Text('Thay đổi thông tin',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Sign Contract
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => SignContract(
                          //         boarding: boardings,
                          //         // landlordId: user['userId'] ?? '',
                          //       ),
                          //     ));
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
                                Text('Tinh đơn hàng',
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
                            print('Tapped');
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
