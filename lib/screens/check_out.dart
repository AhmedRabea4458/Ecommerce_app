import 'package:flutter/material.dart';
import 'package:project/widgets/custom_appbar.dart';
import 'package:project/widgets/custom_header_text.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:("إتمام الدفع")),
      body: Center(
        child: CustomHeaderText(text:
          "هنا تفاصيل الدفع والشحن",
        ),
      ),
    );
  }
}
