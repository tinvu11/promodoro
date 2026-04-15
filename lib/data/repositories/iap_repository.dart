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

  @override
  Future<Either<Failure, List<ProductDetails>>> getProducts() async {
    try {
      final bool isAvailable = await _iap.isAvailable();
      if (isAvailable) {
        final primaryId = const String.fromEnvironment("PRIMARY_PRODUCT_ID");
        final yearlyId = const String.fromEnvironment("YEARLY_PRODUCT_ID");
        final productIds = {primaryId, yearlyId};
        debugPrint('productIds: $productIds');
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

  /// Restores purchases for the current store account on this device.
  @override
  Future<Either<Failure, void>> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  /// Initiates purchase flow for supported non-consumable products.
  @override
  Future<Either<Failure, void>> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      const String lifetimeId = String.fromEnvironment("PRIMARY_PRODUCT_ID");
      const String yearlyId = String.fromEnvironment("YEARLY_PRODUCT_ID");

      if (product.id == lifetimeId || product.id == yearlyId) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  /// Acknowledges completed purchase with the store.
  @override
  void completePurchase(PurchaseDetails purchase) {
    _iap.completePurchase(purchase);
  }

  /// Consumes Android purchases that are expected to be repurchasable.
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
