String vietnameseCurrencyFormat(String price) {
  return "${price.replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}." // Add a dot
      )} đ"; // Add currency symbol
}