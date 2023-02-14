import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signOut() {
    googleSignIn.signOut();
  }
}

final searchedTextProvider = StateProvider<String>((ref) => '');

final coinServiceProvider = Provider<CoinService>((ref) => CoinService());

class CoinService {
  Dio dio = Dio();
  Future<Map<String, dynamic>> fetchCoinsData(String symbols) async {
    try {
      dio.options.headers = {
        "X-CMC_PRO_API_KEY": "27ab17d1-215f-49e5-9ca4-afd48810c149"
      };
      // eg of symbols: BTC,ETH,LTC
      final response = await dio.get(
          "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$symbols");
      return response.data;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      return {"message": "Error Occured"};
    }
  }
}
