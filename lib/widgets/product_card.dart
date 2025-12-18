import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/widgets/gap.dart';
import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double rating;
  final int reviews;
  final double price;
  final VoidCallback? onTap;
  final bool isVendor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddFav;
   final bool?isFavorite;
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.onTap,
    this.isVendor = false,
    this.onEdit,
    this.onDelete,
    this.onAddFav,  this.isFavorite
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor(isDarkMode),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: imageUrl != null
                          ? Hero(
                        tag: name,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.broken_image,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      )
                          : Image.asset(
                        "assets/images/vertical-banners-sales-promo.jpg",
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          color: AppColors.primaryTextColor(isDarkMode),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Gap(h: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                           Gap(w: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style:  TextStyle(
                                color: AppColors.primaryTextColor(isDarkMode), fontSize: 13),
                          ),
                           Gap(w: 6),
                          Text(
                            '($reviews)',
                            style:  TextStyle(
                                color: AppColors.secondaryTextColor(isDarkMode), fontSize: 12),
                          ),
                        ],
                      ),
                      Gap(h: 6),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(w: 12),

          if (isVendor)
            Positioned(
              right: 0,
              bottom: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,size: 16,),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red,size: 16),
                    onPressed: onDelete,
                  ),
                ],
              ),
            )
          else
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                icon: isFavorite!?Icon(
                  Icons.favorite,
                  color:  Colors.red
                ):Icon(
                    Icons.favorite_border,
                    color: isDarkMode ? Colors.white : Colors.black,

                ),
                iconSize: 24,
                onPressed: onAddFav,
              ),
            ),


        ],
      ),
    );
  }
}
