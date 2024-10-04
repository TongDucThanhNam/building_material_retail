class Variant {
  //length, width, height, weight, color, price
  double? length;
  double? width;
  double? thickness;
  double? weight;
  String? color;
  double? price; // required

  Variant({
    this.length,
    this.width,
    this.thickness,
    this.weight,
    this.color,
    required this.price,
  });

  Variant.fromMap(Map<String, dynamic> map)
      : length = map['length'] ?? 0.0,
        width = map['width'] ?? 0.0,
        thickness = map['thickness'] ?? 0.0,
        weight = map['weight'] ?? 0.0,
        color = map['color'] ?? "",
        price = map['price'] ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'thickness': thickness,
      'weight': weight,
      'color': color,
      'price': price,
    };
  }

  @override
  String toString() {
    return '${length != null && length != 0 ? 'd: $length, ' : ''}'
        '${width != null && width != 0 ? 'r: $width, ' : ''}'
        '${thickness != null && thickness != 0 ? 'D: $thickness, ' : ''}'
        '${weight != null && weight != 0 ? 'n: $weight, ' : ''}'
        '${color != null && color!.isNotEmpty ? 'm: $color, ' : ''}';
  }
}
