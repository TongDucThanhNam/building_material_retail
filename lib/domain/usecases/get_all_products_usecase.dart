import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetAllProductsUseCase extends UseCase<GetAllProductsUseCaseResponse,
    GetAllProductsUseCaseParams> {
  final ProductsRepository productsRepository;

  GetAllProductsUseCase(this.productsRepository);

  @override
  Future<Stream<GetAllProductsUseCaseResponse?>> buildUseCaseStream(
      GetAllProductsUseCaseParams? params) async {
    final controller = StreamController<GetAllProductsUseCaseResponse?>();
    try {
      final products = await productsRepository.getProducts();
      controller.add(GetAllProductsUseCaseResponse(products));
      logger.finest('GetAllProductsUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetAllProductsUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetAllProductsUseCaseParams {
  GetAllProductsUseCaseParams();
}

class GetAllProductsUseCaseResponse {
  final List<Product> products;

  GetAllProductsUseCaseResponse(this.products);
}
