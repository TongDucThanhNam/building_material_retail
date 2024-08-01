class Variant {
  //length, width, height, weight, color, price
  double? length;
  double? width;
  double? height;
  double? weight;
  String? color;
  double? price; // required

  Variant({
    this.length,
    this.width,
    this.height,
    this.weight,
    this.color,
    required this.price,
  });
}
