import 'package:building_material_retail/app/pages/widgets/variant_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          VariantInputField(
            controller: widthController,
            labelText: 'Rộng',
            hintText: '2(m)',
          ),

          // Length
          VariantInputField(
            controller: lengthController,
            labelText: 'Dài',
            hintText: '6(m)',
          ),

          // Thickness
          VariantInputField(
            controller: thicknessController,
            labelText: 'Dày',
            hintText: '3(mm)',
          ),

          //Weight
          VariantInputField(
            controller: weightController,
            labelText: 'Nặng',
            hintText: '0.2(Kg)',
          ),

          //Color
          VariantInputField(
            controller: colorController,
            labelText: 'Màu',
            hintText: 'Đỏ',
          ),

          // Price
          VariantInputField(
            controller: priceController,
            labelText: 'Giá',
            hintText: 'VD:100000',
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