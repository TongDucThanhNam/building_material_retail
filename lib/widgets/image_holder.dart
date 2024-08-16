import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHolder extends ConsumerWidget {
  final StateProvider<CroppedFile?> imageProvider;

  const ImageHolder({Key? key, required this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(imageProvider);
    return GestureDetector(
      onTap: () async {
        final source = await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Choose image source'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text('Camera'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('Gallery'),
              ),
            ],
          ),
        );

        if (source != null) {
          var pickedFile = await ImagePicker().pickImage(source: source);
          if (pickedFile != null) {
            final croppedFile = await ImageCropper().cropImage(
              sourcePath: pickedFile.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              compressFormat: ImageCompressFormat.jpg,
              compressQuality: 50,
            );

            if (croppedFile != null) {
              ref.watch(imageProvider.notifier).state = croppedFile;
            }
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Màu nền của Image Holder
              borderRadius: BorderRadius.circular(8), // Bo góc Image Holder
            ),
            child: image == null
                ? Icon(Icons.image,
                    size: 80, color: Colors.grey[500]) // Icon khi chưa có ảnh
                : Image.file(
                    File(image.path),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover, // Căn chỉnh ảnh
                  ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4), // Nền button trong suốt
              shape: BoxShape.circle, // Hình tròn
            ),
            child: const Icon(Icons.camera_alt, size: 30),
          ),
        ],
      ),
    );
  }
}
