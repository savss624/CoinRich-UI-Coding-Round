import 'package:coinrich_ui_coding_round/service.dart';
import 'package:coinrich_ui_coding_round/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: HomePage()));
}

final coinProvider = FutureProvider<Map<String, dynamic>>(
    (ref) async => ref.read(coinServiceProvider).fetchCoinsData());

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        textTheme: TextTheme(
            titleLarge: const TextStyle(
              color: Colors.amberAccent,
            ),
            titleMedium: TextStyle(color: Colors.grey[350]),
            titleSmall: TextStyle(color: Colors.grey[350])),
      ),
      home: Scaffold(
        key: key,
        backgroundColor: Colors.white12,
        appBar: AppBar(
          title: const Text(
            "CoinRich",
            style: TextStyle(fontSize: 32),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              return ref.watch(coinProvider).when(
                  data: (res) => CoinListView(context, res),
                  error: (Object error, StackTrace stackTrace) =>
                      const Text("Some Error Occured!"),
                  loading: () => const CircularProgressIndicator(
                      color: Colors.amberAccent));
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
