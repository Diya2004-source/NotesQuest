import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../users/home_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      handleExternalWallet,
    );
  }

  // ================= PAYMENT SUCCESS =================
  Future<void> handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('payments')
        .add({
      "userId": uid,
      "paymentId": response.paymentId,
      "status": "success",
      "createdAt": FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      "isPremium": true,
      "paymentStatus": "paid",
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ================= PAYMENT ERROR =================
  void handlePaymentError(
    PaymentFailureResponse response,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment Failed: ${response.message}",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ================= EXTERNAL WALLET =================
  void handleExternalWallet(
    ExternalWalletResponse response,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "External Wallet: ${response.walletName}",
        ),
      ),
    );
  }

  // ================= OPEN PAYMENT =================
  void openPayment({
    required int amount,
    required String title,
  }) {
    var options = {
      'key': 'rzp_test_Sv4PIK7VnYYTKJ',
      'amount': amount * 100,
      'name': 'Quest',
      'description': title,
      'prefill': {
        'contact': '9876543210',
        'email':
            FirebaseAuth.instance.currentUser?.email ?? '',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Choose Plan"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('subscription_plans')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final plans = snapshot.data!.docs;

          if (plans.isEmpty) {
            return const Center(
              child: Text(
                "No Plans Available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,

            itemBuilder: (context, index) {

              final data =
                  plans[index].data()
                      as Map<String, dynamic>;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // TITLE
                    Text(
                      data['title'] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // PRICE
                    Text(
                      "₹${data['price']}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DURATION
                    Text(
                      data['duration'] ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DESCRIPTION
                    Text(
                      data['description'] ?? "",
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BUY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {
                          openPayment(
                            amount: data['price'],
                            title: data['title'],
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // DUMMY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: OutlinedButton(
                        onPressed: () {

                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomePage(),
                            ),
                          );
                        },

                        style:
                            OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.white24,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Dummy User Side Button",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}