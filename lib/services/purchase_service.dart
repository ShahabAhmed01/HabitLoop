import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static const String _removeAdsId = 'habitloop_remove_ads';
  static bool _adsRemoved = false;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  static bool get adsRemoved => _adsRemoved;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _adsRemoved = prefs.getBool('ads_removed') ?? false;

    // Listen for purchase updates
    final purchaseStream = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    // Check if store is available
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      debugPrint('Store not available');
    }
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static Future<bool> isStoreAvailable() async {
    return await InAppPurchase.instance.isAvailable();
  }

  static Future<ProductDetails?> getProduct() async {
    final response = await InAppPurchase.instance.queryProductDetails({_removeAdsId});
    if (response.error != null) {
      debugPrint('Query error: ${response.error}');
      return null;
    }
    if (response.productDetails.isEmpty) {
      debugPrint('Product not found');
      return null;
    }
    return response.productDetails.first;
  }

  static Future<bool> buyRemoveAds(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    return await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  static void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID == _removeAdsId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _adsRemoved = true;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('ads_removed', true);
        }
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      }
    }
  }

  static Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }
}
