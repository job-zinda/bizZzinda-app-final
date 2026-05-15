import 'package:biz_zinda/services/Shop_service.dart';
import 'package:biz_zinda/view/Shop/shop_model.dart';
import 'package:flutter/cupertino.dart';

class ShopViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<ShopModel> shopList = [];
  ShopModel? shopModel;

  Future<void> fetchShops() async {
    isLoading = true;
    notifyListeners();

    try {
      final list = await ShopService.getShops();

      print("👉 SHOP LIST: $list");

      shopModel = list.isNotEmpty ? list.first : null;
    } catch (e) {
      print("VM ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}