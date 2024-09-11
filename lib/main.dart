import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:uzpay/uzpay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
    ],
    // Enable deep linking
    debugLogDiagnostics: true,
    initialLocation: '/',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ///Avvaliga parametrlarni belgilab olamiz
  var paymentParams = Params(
    paymeParams: PaymeParams(
      transactionParam: "1",
      merchantId: "6443d473096a61fb42c216af",

      // Quyidagilar ixtiyoriy parametrlar
      accountObject: 'key', // Agar o'zgargan bo'lsa
      headerColor: Colors.indigo, // Header rangi
      headerTitle: "Payme tizimi orqali to'lash",
    ),
  );

  void pay() async {
    try {
      final response = await UzPay.doPayment(
        context,
        amount: 1, // To'ov summasi
        paymentSystem: PaymentSystem.Payme,
        paymentParams: paymentParams,
        browserType: BrowserType.External,
        externalBrowserMenuItem: ChromeSafariBrowserMenuItem(
          id: 1,
          label: 'Dasturchi haqida',
          onClick: (url, title) {
            print("URL: $url");
            print("TITLE: $title");
          },
        ),
      );

      print("RESPONSE: $response");
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: pay,
          child: const Text("PAY"),
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Success')),
      body: const Center(
        child: Text('Payment completed successfully!'),
      ),
    );
  }
}
