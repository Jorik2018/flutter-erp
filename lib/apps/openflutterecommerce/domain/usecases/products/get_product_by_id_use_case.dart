import 'package:flutter_erp/apps/openflutterecommerce/data/model/product.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/repositories/abstract/product_repository.dart';
import 'package:flutter_erp/apps/openflutterecommerce/domain/usecases/base_use_case.dart';
import 'package:flutter_erp/apps/openflutterecommerce/locator.dart';

abstract class GetProductByIdUseCase
    implements BaseUseCase<ProductDetailsResults, ProductDetailsParams> {}

class GetProductByIdUseCaseImpl implements GetProductByIdUseCase {
  @override
  Future<ProductDetailsResults> execute(ProductDetailsParams params) async {
    //TODO: replace fetch from API
    //TEMP solution
    ProductRepository productRepository = sl();
    //TODO:
    List<Product> products = await productRepository.getProducts(
      categoryId: params.categoryId,
    );
    Product product;
    products.forEach(
      (Product f) => {if (f.id == params.productId) product = f},
    );
    return ProductDetailsResults(
      productDetails: product,
      similarProducts: products,
    );
  }
}

class ProductDetailsResults {
  final Product productDetails;
  final List<Product> similarProducts;

  ProductDetailsResults({this.productDetails, this.similarProducts});
}

class ProductDetailsParams {
  final int productId;
  final int categoryId;

  ProductDetailsParams({this.productId, this.categoryId});
}
