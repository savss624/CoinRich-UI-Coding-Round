import 'package:coinrich_ui_coding_round/service.dart';
import 'package:coinrich_ui_coding_round/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        textTheme: TextTheme(
            titleLarge: const TextStyle(
              color: Colors.amberAccent,
            ),
            titleMedium: TextStyle(color: Colors.grey[350]),
            titleSmall: TextStyle(color: Colors.grey[350])),
      ),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

final FirebaseAuth auth = FirebaseAuth.instance;

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButton(
            Buttons.GoogleDark,
            onPressed: () {
              ref.read(authServiceProvider).signInWithGoogle();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
      )),
    );
  }
}

class SearchPage extends ConsumerWidget {
  SearchPage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  void signOut(context, ref) {
    ref.read(authServiceProvider).signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
          title: const Text(
            "CoinRich",
            style: TextStyle(fontSize: 32),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            AnimSearchBar(
              color: Colors.black,
              searchIconColor: Colors.white,
              textFieldColor: Colors.black,
              textFieldIconColor: Colors.white,
              width: MediaQuery.of(context).size.width,
              style: const TextStyle(color: Colors.white),
              textController: textEditingController,
              onSubmitted: (value) {
                ref.read(searchedTextProvider.notifier).update((_) => value);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              onSuffixTap: () {
                textEditingController.clear();
              },
            )
          ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => {signOut(context, ref)},
          child: const Icon(Icons.logout_rounded)),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinProvider = FutureProvider<Map<String, dynamic>>((ref) async => ref
        .read(coinServiceProvider)
        .fetchCoinsData(ref.read(searchedTextProvider)));

    return Scaffold(
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
                loading: () =>
                    const CircularProgressIndicator(color: Colors.amberAccent));
          },
        ),
      ),
    );
  }
}
