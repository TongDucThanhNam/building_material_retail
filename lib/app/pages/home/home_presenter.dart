import '../../../domain/entities/product.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart'
    as clean;

import '../../../domain/usecases/get_all_products_usecase.dart';

class HomePresenter extends clean.Presenter {
  Function? getAllProductsOnNext;
  Function? getAllProductsOnComplete;
  Function? getAllProductsOnError;

  final GetAllProductsUseCase getAllProductsUseCase;
  HomePresenter(productsRepository)
      : getAllProductsUseCase = GetAllProductsUseCase(productsRepository),
        super();

  void getAllProducts() {
    getAllProductsUseCase.execute(
        _GetAllProductsUseCaseObserver(this), GetAllProductsUseCaseParams());
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

class _GetAllProductsUseCaseObserver
    extends clean.Observer<GetAllProductsUseCaseResponse> {
  final HomePresenter homePresenter;
  _GetAllProductsUseCaseObserver(this.homePresenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
    homePresenter.getAllProductsOnComplete!();
  }

  @override
  void onError(e) {
    // TODO: implement onError
    homePresenter.getAllProductsOnError!(e);
  }

  @override
  void onNext(GetAllProductsUseCaseResponse? response) {
    // TODO: implement onNext
    homePresenter.getAllProductsOnNext!(response!.products);
  }
}
