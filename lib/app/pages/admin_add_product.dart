import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../models/product.dart';
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

  @override
  Widget build(BuildContext context) {
    addProduct() {
      final storage = ref.read(databaseProvider);
      final fileStorage = ref.read(storageProvider); // reference file storage
      final imageFile =
          ref.read(addImageProvider.notifier).state; // referece the image File

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
          specifications: {},
          tags: [],
        ));
      });

      // Immediately pop the context.
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(children: [
              CustomInputFieldFb1(
                inputController: titleTextEditingController,
                labelText: 'Tên sản phẩm',
                hintText: 'Nhập tên sản phẩm',
                isNumber: false,
              ),
              const SizedBox(height: 15),
              CustomInputFieldFb1(
                inputController: descriptionEditingController,
                labelText: 'Mô tả sản phẩm',
                hintText: 'Nhập mô tả sản phẩm',
                isNumber: false,
              ),
              const SizedBox(height: 15),
              CustomInputFieldFb1(
                inputController: priceEditingController,
                labelText: 'Giá sản phẩm',
                hintText: 'Nhập giá sản phẩm',
                isNumber: true,
              ),
              // const Spacer(),
              Consumer(
                builder: (context, watch, child) {
                  final image = ref.watch(addImageProvider);
                  return image == null
                      ? const Text('Chưa có hình ảnh nào được chọn')
                      : Image.file(
                          File(image.path),
                          height: 200,
                          width: 200,
                        );
                },
              ),

              ElevatedButton(
                child: const Text('Tải hình ảnh lên'),
                onPressed: () async {
                  var pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null) {
                    final croppedFile = await ImageCropper().cropImage(
                      sourcePath: pickedFile.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                      compressFormat: ImageCompressFormat.jpg,
                      compressQuality: 50,

                      // uiSettings: AndroidUiSettings(
                      //     toolbarTitle: 'Cắt ảnh',
                      //     toolbarColor: Colors.blue,
                      //     toolbarWidgetColor: Colors.white,
                      //     initAspectRatio: CropAspectRatioPreset.original,
                      //     lockAspectRatio: false),
                    );

                    if (croppedFile != null) {
                      // Sử dụng file đã cắt (croppedFile) ở đây
                      ref.watch(addImageProvider.notifier).state = croppedFile;
                    }
                  }

                  // if (pickedFile != null) {
                  //   ref.watch(addImageProvider.state).state = pickedFile;
                  // }
                },
              ),

              ElevatedButton(
                  onPressed: addProduct, child: const Text("Thêm sản phẩm")),
            ]),
          )),
    );
  }
}

class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final Color primaryColor;
  final String labelText;
  final bool isNumber;

  const CustomInputFieldFb1(
      {Key? key,
      required this.inputController,
      required this.hintText,
      required this.labelText,
      this.primaryColor = Colors.indigo,
      required this.isNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: inputController,
        onChanged: (value) {
          //Do something
        },
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
        ),
      ),
    );
  }
}
