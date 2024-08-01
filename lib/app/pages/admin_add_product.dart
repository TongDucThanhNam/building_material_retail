import 'dart:io';

import 'package:building_material_retail/widgets/variant_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../models/product.dart';
import '../../utils/type.dart';
import '../providers.dart';

class AdminAddProductPage extends ConsumerStatefulWidget {
  const AdminAddProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminAddProductPageState();
}

class _AdminAddProductPageState extends ConsumerState<AdminAddProductPage> {
  final titleTextEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final brandTextEditingController = TextEditingController();
  List<Map<String, TextEditingController>> variantFields = [];
  String dropdownValue = types[0];
  bool isVariantLength = false;
  bool isVariantWidth = false;
  bool isVariantThickness = false;
  bool isVariantWeight = false;
  bool isVariantColor = false;

  @override
  Widget build(BuildContext context) {
    addProduct() {
      final storage = ref.read(databaseProvider);
      final fileStorage = ref.read(storageProvider); // reference file storage
      final imageFile =
          ref.read(addImageProvider.notifier).state; // referece the image File

      List<Map<String, String>> variantsData = [];

      for (var variantField in variantFields) {
        variantsData.add({
          'lengthController': variantField['lengthController']!.text,
          'widthController': variantField['widthController']!.text,
          'thicknessController': variantField['thicknessController']!.text,
          'weightController': variantField['weightController']!.text,
          'colorController': variantField['colorController']!.text,
          'priceController': variantField['priceController']!.text,
        });
      }

      // In dữ liệu ra console để kiểm tra
      print("@@@ Variants Data @@@: ");
      print(variantsData);

      // ... Tiếp tục xử lý dữ liệu (ví dụ: lưu vào database)

      if (storage == null || fileStorage == null || imageFile == null) {
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
      fileStorage.uploadFile(imageFile.path).then((imageUrl) {
        print("Image URL: $imageUrl");
        storage.addProduct(Product(
          name: titleTextEditingController.text,
          description: descriptionEditingController.text,
          price: int.parse(priceEditingController.text),
          imageUrl: imageUrl,
          nameWithoutAccent: nameWithoutAccent,
          searchIndex: searchIndex,
          type: '',
          brand: '',
          variants: variantsData,
        ));
      });

      // Immediately pop the context.
      Navigator.pop(context);
    }

    void _addVariantField() {
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

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: addProduct(),
          backgroundColor: Colors.blue,
          label: const Text('Thêm sản phẩm'),
          icon: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image Holder
                      Consumer(
                        builder: (context, watch, child) {
                          final image = ref.watch(addImageProvider);
                          return Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color:
                                  Colors.grey[300], // Màu nền của Image Holder
                              borderRadius: BorderRadius.circular(
                                  8), // Bo góc Image Holder
                            ),
                            child: image == null
                                ? Icon(Icons.image,
                                    size: 80,
                                    color: Colors
                                        .grey[500]) // Icon khi chưa có ảnh
                                : Image.file(
                                    File(image.path),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover, // Căn chỉnh ảnh
                                  ),
                          );
                        },
                      ),

                      // Button overlay lên Image Holder (vẫn là Image Holder)
                      GestureDetector(
                        onTap: () async {
                          var pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            final croppedFile = await ImageCropper().cropImage(
                              sourcePath: pickedFile.path,
                              aspectRatio:
                                  const CropAspectRatio(ratioX: 1, ratioY: 1),
                              compressFormat: ImageCompressFormat.jpg,
                              compressQuality: 50,
                            );

                            if (croppedFile != null) {
                              // Sử dụng file đã cắt (croppedFile) ở đây
                              ref.watch(addImageProvider.notifier).state =
                                  croppedFile;
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.4), // Nền button trong suốt
                            shape: BoxShape.circle, // Hình tròn
                          ),
                          child: const Icon(Icons.camera_alt, size: 30),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: TextField(
                            controller: titleTextEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                alignLabelWithHint: false,
                                // labelText: 'Tên sản phẩm',
                                hintText: 'VD: Ván ép phủ phim 18 ly',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    titleTextEditingController.clear();
                                  },
                                ),
                                label: RichText(
                                  text: const TextSpan(
                                    text: 'Tên sản phẩm ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      color: Colors.black, // Màu chữ của label
                                      fontSize:
                                          16.0, // Kích thước chữ của label
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: TextField(
                            controller: descriptionEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'VD: Ván ép phủ phim 18 ly chống ẩm',
                              label: RichText(
                                text: const TextSpan(
                                  text: 'Mô tả sản phẩm ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,

                                    color: Colors.black, // Màu chữ của label
                                    fontSize: 16.0, // Kích thước chữ của label
                                  ),
                                  children: [
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
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: TextField(
                            controller: priceEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nhập giá sản phẩm',
                              label: RichText(
                                text: const TextSpan(
                                  text: 'Giá sản phẩm ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Màu chữ của label
                                    fontSize: 16.0, // Kích thước chữ của label
                                  ),
                                  children: [
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
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        const Divider(),
                        //Unit
                        ListTile(
                          title: Row(
                            children: [
                              // Label ở bên trái
                              const Expanded(
                                flex: 3,
                                child: Text('Đơn vị tính:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              // Khoảng cách giữa Label và DropdownButton
                              // DropdownButtonFormField ở bên phải
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField(
                                  value: 'Cái',
                                  decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Ẩn đường divider mặc định
                                    contentPadding: EdgeInsets
                                        .zero, // Loại bỏ padding mặc định
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Cái',
                                      child: Text('Cái'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Mét',
                                      child: Text('Mét'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Bao',
                                      child: Text('Mét vuông'),
                                    ),
                                  ],
                                  onChanged: (dynamic value) {
                                    // setState(() {
                                    //   unit = value;
                                    // });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        const Divider(),
                        ListTile(
                          title: TextField(
                            controller: brandTextEditingController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Thương hiệu',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Màu chữ của label
                                fontSize: 16.0, // Kích thước chữ của label
                              ),
                              hintText: 'VD: Hoa Sen',
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: Row(
                            children: [
                              // Label ở bên trái
                              const Expanded(
                                flex: 3,
                                child: Text('Loại vật liệu:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              // Khoảng cách giữa Label và DropdownButton
                              // DropdownButtonFormField ở bên phải
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: dropdownValue,
                                  decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Ẩn đường divider mặc định
                                    contentPadding: EdgeInsets
                                        .zero, // Loại bỏ padding mặc định
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: types.map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //Checkbox Variant available
                  Card(
                    child: Column(
                      children: [
                        //Length
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Dài',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isVariantLength,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVariantLength = value!;
                                });
                              },
                            ),
                          ],
                        ),

                        //Width
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Rộng',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isVariantWidth,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVariantWidth = value!;
                                });
                              },
                            ),
                          ],
                        ),

                        //Thickness
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Dày',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isVariantThickness,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVariantThickness = value!;
                                });
                              },
                            ),
                          ],
                        ),

                        //Weight
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Nặng',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isVariantWeight,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVariantWeight = value!;
                                });
                              },
                            ),
                          ],
                        ),

                        //Color
                        Row(
                          children: [
                            const Expanded(
                              child: ListTile(
                                title: Text(
                                  'Màu',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isVariantColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVariantColor = value!;
                                });
                              },
                            ),
                          ],
                        ),
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
                              onPressed: _addVariantField,
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
}
