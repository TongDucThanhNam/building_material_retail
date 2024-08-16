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
}
