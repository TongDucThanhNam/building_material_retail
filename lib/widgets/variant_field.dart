import 'package:flutter/material.dart';

class VariantField extends StatelessWidget {
  TextEditingController? widthController = TextEditingController();
  TextEditingController? lengthController = TextEditingController();
  TextEditingController? thicknessController = TextEditingController();
  TextEditingController? weightController = TextEditingController();
  TextEditingController? colorController = TextEditingController();
  TextEditingController? priceController = TextEditingController();

  VariantField(
      {this.widthController,
      this.lengthController,
      this.thicknessController,
      this.weightController,
      this.colorController,
      required this.priceController,
      required int index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          // Width
          widthController == null
              ? const SizedBox()
              : Expanded(
                  child: TextField(
                    controller: widthController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Rộng',
                      hintText: 'VD: 1220 mm',
                    ),
                  ),
                ),

          // Length
          lengthController == null
              ? const SizedBox()
              : Expanded(
                  child: TextField(
                    controller: lengthController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Dài',
                      hintText: 'VD: 2440 mm',
                    ),
                  ),
                ),

          // Thickness
          thicknessController == null
              ? const SizedBox()
              : Expanded(
                  child: TextField(
                    controller: thicknessController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Dày',
                      hintText: 'VD: 18 mm',
                    ),
                  ),
                ),

          //Weight
          weightController == null
              ? const SizedBox()
              : Expanded(
                  child: TextField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Nặng',
                      hintText: 'VD: 30 kg',
                    ),
                  ),
                ),

          //Color
          colorController == null
              ? const SizedBox()
              : Expanded(
                  child: TextField(
                    controller: colorController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Màu',
                      hintText: 'VD: Trắng',
                    ),
                  ),
                ),
          // Price
          Expanded(
            child: TextField(
              controller: priceController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Giá',
                hintText: 'VD: 300,000',
              ),
            ),
          ),

          //Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Delete variant
            },
          ),
        ],
      ),
    );
  }
}
