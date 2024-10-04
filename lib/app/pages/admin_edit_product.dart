import 'package:building_material_retail/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../models/product.dart';
import '../../models/variant.dart';
import '../../utils/type.dart';
import '../../widgets/image_holder.dart';
import '../../widgets/variant_field.dart';

class AdminEditProduct extends ConsumerStatefulWidget {
  final Product product;

  const AdminEditProduct({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminEditProductState();
}

class _AdminEditProductState extends ConsumerState<AdminEditProduct> {
  final titleTextEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final brandTextEditingController = TextEditingController();
  List<Map<String, TextEditingController>> variantFields = [];
  String typeDropdownValue = types[0];
  String unitDropdownValue = units[0];

  bool isVariantLength = false;
  bool isVariantWidth = false;
  bool isVariantThickness = false;
  bool isVariantWeight = false;
  bool isVariantColor = false;

  @override
  void initState() {
    titleTextEditingController.text = widget.product.name;
    priceEditingController.text = widget.product.price.toString();
    descriptionEditingController.text = widget.product.description;
    brandTextEditingController.text = widget.product.brand ?? "";

    //set variants
    var variants = widget.product.variants;
    for (Variant variant in variants) {
      debugPrint("Variant ${variant.toString()}");
      variantFields.add({
        'lengthController':
            TextEditingController(text: variant.length.toString()),
        'widthController':
            TextEditingController(text: variant.width.toString()),
        'thicknessController':
            TextEditingController(text: variant.thickness.toString()),
        'weightController':
            TextEditingController(text: variant.weight.toString()),
        'colorController':
            TextEditingController(text: variant.color.toString()),
        'priceController':
            TextEditingController(text: variant.price.toString()),
      });
    }

    super.initState();
  } //Fetch Current value
  //init state

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: editProduct,
          backgroundColor: Colors.blue,
          label: const Text("Sửa sản phẩm"),
          icon: const Icon(Icons.edit),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Sửa sản phẩm'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageHolder(imageProvider: addImageProvider),

                  const SizedBox(height: 25),

                  Card(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: titleTextEditingController,
                          hintText: 'VD: Ván ép phủ phim 18 ly',
                          label: 'Tên sản phẩm',
                        ),
                        const Divider(),
                        _buildTextField(
                          controller: descriptionEditingController,
                          hintText: 'VD: Ván ép phủ phim 18 ly chống ẩm',
                          label: 'Mô tả sản phẩm',
                        ),
                        // const Divider(),
                        // _buildTextField(
                        //   controller: priceEditingController,
                        //   hintText: 'Nhập giá sản phẩm',
                        //   label: 'Giá sản phẩm',
                        //   keyboardType: TextInputType.number,
                        // ),
                        const Divider(),
                        _buildDropdown(
                          label: 'Đơn vị tính:',
                          value: unitDropdownValue,
                          items: units,
                          onChanged: (String? newValue) {
                            setState(() {
                              unitDropdownValue = newValue!;
                            });
                          },
                        ),
                        const Divider(),
                        _buildTextField(
                          controller: brandTextEditingController,
                          hintText: 'VD: Hoa Sen',
                          label: 'Thương hiệu',
                        ),
                        const Divider(),
                        _buildDropdown(
                          label: 'Loại vật liệu:',
                          value: typeDropdownValue,
                          items: types,
                          onChanged: (String? newValue) {
                            setState(() {
                              typeDropdownValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //Checkbox Variant available
                  Card(
                    child: Column(
                      children: [
                        _buildCheckboxRow('Dài', isVariantLength, (value) {
                          setState(() {
                            isVariantLength = value!;
                          });
                        }),
                        _buildCheckboxRow('Rộng', isVariantWidth, (value) {
                          setState(() {
                            isVariantWidth = value!;
                          });
                        }),
                        _buildCheckboxRow('Dày', isVariantThickness, (value) {
                          setState(() {
                            isVariantThickness = value!;
                          });
                        }),
                        _buildCheckboxRow('Nặng', isVariantWeight, (value) {
                          setState(() {
                            isVariantWeight = value!;
                          });
                        }),
                        _buildCheckboxRow('Màu', isVariantColor, (value) {
                          setState(() {
                            isVariantColor = value!;
                          });
                        }),
                      ],
                    ),
                  ),

                  //Add Variant
                  Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Danh sách biến thể',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: editVariantField,
                            ),
                          ],
                        ),

                        //Add Variant Fields
                        ...variantFields.asMap().entries.map((entry) {
                          final index = entry.key;
                          final controller = entry.value;
                          return VariantField(
                            index: index,
                            priceController: controller['priceController']!,
                            colorController: isVariantColor
                                ? controller['colorController']!
                                : null,
                            lengthController: isVariantLength
                                ? controller['lengthController']!
                                : null,
                            thicknessController: isVariantThickness
                                ? controller['thicknessController']!
                                : null,
                            weightController: isVariantWeight
                                ? controller['weightController']!
                                : null,
                            widthController: isVariantWidth
                                ? controller['widthController']!
                                : null,
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  //End, but add some Space for the FAB
                  const SizedBox(height: 100),
                ]),
          )),
    );
  }

  //function
  editProduct() {
    final storage = ref.read(databaseProvider); // reference database
    final fileStorage = ref.read(storageProvider); // reference file storage
    final imageFile =
        ref.read(addImageProvider.notifier).state; // referece the image File

    List<Variant> variants = [];

    for (var variantField in variantFields) {
      variants.add(Variant(
        length: variantField['lengthController']!.text.isEmpty
            ? null
            : double.parse(variantField['lengthController']!.text),
        width: variantField['widthController']!.text.isEmpty
            ? null
            : double.parse(variantField['widthController']!.text),
        thickness: variantField['thicknessController']!.text.isEmpty
            ? null
            : double.parse(variantField['thicknessController']!.text),
        weight: variantField['weightController']!.text.isEmpty
            ? null
            : double.parse(variantField['weightController']!.text),
        color: variantField['colorController']!.text.isEmpty
            ? null
            : variantField['colorController']!.text,
        price: double.parse(variantField['priceController']!.text),
      ));
    }

    if (storage == null || fileStorage == null) {
      // make sure none of them are null
      print("Error: storage, fileStorage or imageFile is null");
      // show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: storage, fileStorage or imageFile is null"),
        ),
      );
      return;
    }

    final nameWithoutAccent =
        removeDiacritics(titleTextEditingController.text).toLowerCase();

    //Search index
    List<String> searchIndex = [];

    //Split the name into words
    final words = nameWithoutAccent.split(" ");
    searchIndex.addAll(words);
    if (imageFile == null) {
      // Update without image
      storage.updateProduct(
        widget.product.id ?? "",
        Product(
          id: widget.product.id,
          name: titleTextEditingController.text,
          description: descriptionEditingController.text,
          brand: brandTextEditingController.text,
          type: typeDropdownValue,
          nameWithoutAccent: nameWithoutAccent,
          price: 0,
          variants: variants,
          imageUrl: widget.product.imageUrl,
          searchIndex: searchIndex,
        ),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sửa sản phẩm thành công"),
        ),
      );

      return;
    }

    fileStorage.uploadFile(imageFile.path).then((imageUrl) {
      // print("Image URL: $imageUrl");
      storage.updateProduct(
        widget.product.id ?? "",
        Product(
          id: widget.product.id,
          name: titleTextEditingController.text,
          description: descriptionEditingController.text,
          brand: brandTextEditingController.text,
          type: typeDropdownValue,
          nameWithoutAccent: nameWithoutAccent,
          price: 0,
          variants: variants,
          imageUrl: imageUrl,
          searchIndex: searchIndex,
        ),
      );
    });

    // Immediately pop the context.
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sửa sản phẩm thành công"),
      ),
    );
    return;
  }

  void editVariantField() {
    setState(() {
      variantFields.add({
        'lengthController': TextEditingController(),
        'widthController': TextEditingController(),
        'thicknessController': TextEditingController(),
        'weightController': TextEditingController(),
        'colorController': TextEditingController(),
        'priceController': TextEditingController(),
      });
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ListTile(
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          label: RichText(
            text: TextSpan(
              text: '$label ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16.0,
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    void Function(String?)? onChanged,
  }) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField(
              value: value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(
      String label, bool value, void Function(bool?) onChanged) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
