import './home_presenter.dart';
import '../../../domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;
  HomeController(productRepo)
      : _presenter = HomePresenter(productRepo),
        super();

  List<Product> products = [];

  @override
  void initListeners() {
    _presenter.getAllProductsOnNext = (List<Product> products) {
      this.products = products;
      refreshUI();
    };

    _presenter.getAllProductsOnComplete = () {
      print('Get Products Complete');
    };

    _presenter.getAllProductsOnError = (e) {
      print('Get Products Error: $e');
    };
  }

  void getProducts() {
    _presenter.getAllProducts();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
}
