import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../core/failure.dart';

abstract interface class IapRepository {
  Stream<List<PurchaseDetails>> get subscription;

  Future<Either<Failure, List<ProductDetails>>> getProducts();

  Future<Either<Failure, void>> restorePurchases();

  Future<Either<Failure, void>> purchaseProduct(ProductDetails product);

  void completePurchase(PurchaseDetails purchase);

  void consumePurchase(PurchaseDetails purchase);
}

class IapRepositoryImpl implements IapRepository {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get subscription => _iap.purchaseStream;

  //
  @override
  Future<Either<Failure, List<ProductDetails>>> getProducts() async {
    try {
      final bool isAvailable = await _iap.isAvailable();
      if (isAvailable) {
        // 2 id là 2 gói premium hoặc monthly và yearly, được định nghĩa trong file .env và trên App Store Connect hoặc Google Play Console
        final primaryId = const String.fromEnvironment("PRIMARY_PRODUCT_ID");
        final secondaryId = const String.fromEnvironment(
          "SECONDARY_PRODUCT_ID",
        );
        final productIds = {primaryId, secondaryId};
        debugPrint('productIds: $productIds');
        // Gọi API để lấy thông tin chi tiết về sản phẩm dựa trên productIds
        final response = await _iap.queryProductDetails(productIds);
        if (response.notFoundIDs.isNotEmpty) {
          return Left(Failure(message: 'Product not found'));
        }
        return Right(response.productDetails);
      } else {
        return Left(Failure(message: 'In-app purchases are not available'));
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  // hoàn tác giao dịch đã mua thông qua tài khoảng store đang đăng nhập trên thiết bị
  @override
  Future<Either<Failure, void>> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  // ProductDetails là đối tượng trả về từ phương thức getProducts, chứa thông tin chi tiết về sản phẩm như id, title, description, price, v.v.
  @override
  Future<Either<Failure, void>> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Xác định ID của các gói không phải hàng tiêu dùng
      const String lifetimeId = String.fromEnvironment("PRIMARY_PRODUCT_ID");
      const String yearlyId = String.fromEnvironment("YEARLY_PRODUCT_ID");

      if (product.id == lifetimeId || product.id == yearlyId) {
        // Cả Lifetime và Yearly đều dùng buyNonConsumable
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  // Xác nhận giao dịch đã thành công với store
  @override
  void completePurchase(PurchaseDetails purchase) {
    _iap.completePurchase(purchase);
  }

  /// mua theo thời hạn 1 ngày hoặc theo lượt(tải) chỉ dành cho android
  @override
  void consumePurchase(PurchaseDetails purchase) async {
    if (purchase is GooglePlayPurchaseDetails && Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition = InAppPurchase
          .instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      await androidAddition.consumePurchase(purchase);
    }
  }
}
