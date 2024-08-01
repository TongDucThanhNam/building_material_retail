import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductUseCase
    extends UseCase<GetProductUseCaseResponse, GetProductUseCaseParams> {
  final ProductsRepository productsRepository;

  GetProductUseCase(this.productsRepository);

  @override
  Future<Stream<GetProductUseCaseResponse?>> buildUseCaseStream(
      GetProductUseCaseParams? params) async {
    // TODO: implement buildUseCaseStream
    final controller = StreamController<GetProductUseCaseResponse?>();
    try {
      // Get the product from the repository
      final product = await productsRepository.getAllProduct(params!.id);
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetProductUseCaseResponse(product));
      logger.finest('GetProductUseCase successful.'); // Log success
      controller.close();
    } catch (e) {
      logger.severe('GetProductUseCase unsuccessful.'); // Log error
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class GetProductUseCaseParams {
  final String id;

  GetProductUseCaseParams(this.id);
}

/// Wrapping response inside an object makes it easier to change later
class GetProductUseCaseResponse {
  final Product product;

  GetProductUseCaseResponse(this.product);
}
