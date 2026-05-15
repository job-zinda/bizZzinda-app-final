import 'dart:convert';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view/Shop/shop_model.dart';
import 'package:http/http.dart' as http;




class ShopService {
  static Future<List<ShopModel>> getShops() async {
    try {
      final url =
          "${Api.getAllShops}?pageNumber=1&pageSize=10&searchTag=";

      print("👉 URL: $url");

      final response = await http.get(Uri.parse(url));

      print("👉 STATUS: ${response.statusCode}");
      print("👉 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print("👉 PARSED DATA: $data");

        final List list = data['data'] ?? [];

        return list.map((e) => ShopModel.fromJson(e)).toList();
      } else {
        print("❌ API FAILED");
        return [];
      }
    } catch (e) {
      print("❌ ERROR: $e");
      return [];
    }
  }
}