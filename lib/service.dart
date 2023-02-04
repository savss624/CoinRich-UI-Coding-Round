import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinServiceProvider = Provider<CoinService>((ref) => CoinService());

class CoinService {
  Dio dio = Dio();
  Future<Map<String, dynamic>> fetchCoinsData() async {
    try {
      dio.options.headers = {
        "X-CMC_PRO_API_KEY": "27ab17d1-215f-49e5-9ca4-afd48810c149"
      };
      final response = await dio.get(
          "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,LTC");
      return response.data;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      return {"message": "Error Occured"};
    }
  }
}
