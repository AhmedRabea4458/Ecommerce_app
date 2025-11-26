import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/model/product.dart';
import 'package:project/services/product_service.dart';
import 'package:project/widgets/category_selector.dart';
import 'package:project/widgets/product_card.dart';

import '../cubits/profile/theme_cubit.dart';


class HomePage extends StatefulWidget {
  final String searchQuery;
  final void Function(String)? onSearchChanged;

  const HomePage({super.key, required this.searchQuery, this.onSearchChanged});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

 ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }




  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context
        .watch<ThemeCubit>()
        .state;

    return Column(
      children: [


        CategorySelector(
          categories: const [
            "All",
            "Cables & Chargers",
            "Cases & Protection",
            "Headphones",
            "Screen Protectors",
            "Power Banks",
            "Car Accessories",
          ],
          onCategorySelected: (selected) {
            setState(() {
              selectedCategory = selected;
            });
          },
        ),

        Expanded(
          child: StreamBuilder<List<Product>>(
            stream: _productService.streamProductsByCategory(selectedCategory),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No products available",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTextColor(isDarkMode),
                    ),
                  ),
                );
              }

              final products = snapshot.data!
                  .where((p) => p.name.toLowerCase().contains(widget.searchQuery))
                  .toList();

              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    imageUrl: product.imageUrl,
                    name: product.name,
                    rating: product.rating,
                    reviews: product.reviews,
                    price: product.price,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {'product': product},
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


