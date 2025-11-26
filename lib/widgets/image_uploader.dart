import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../../constants/app_colors.dart';
import '../../../cubits/profile/theme_cubit.dart';
import '../../../widgets/custom_header_text.dart';
import '../../../widgets/gap.dart';

class ImageUploader extends StatelessWidget {
  final Function(File file) onImageSelected;
  final File? selectedImage;
  final String? imageUrl;

  const ImageUploader({
    super.key,
    required this.onImageSelected,
    required this.selectedImage,
    this.imageUrl,
  });

  Future<void> pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (result != null && result.files.single.path != null) {
      onImageSelected(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    Widget imageWidget;

    if (selectedImage != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          selectedImage!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = const Text("No Image Yet");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Images",
          style: TextStyle(
            color: AppColors.primaryTextColor(isDarkMode),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Gap(h: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            border: DashedBorder.all(
              dashLength: 8,
              color: Colors.grey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
               Icon(Icons.cloud_upload_outlined, size: 32),
              Gap(h: 8),
               CustomHeaderText(text: "Tap to upload"),
              Gap(h: 4),
              Text(
                "Upload product images",
                style: TextStyle(
                  color: AppColors.secondaryTextColor(isDarkMode),
                  fontSize: 12,
                ),
              ),
              Gap(h: 12),
              ElevatedButton(
                onPressed: () => pickImage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor(isDarkMode),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor(isDarkMode),
                  ),
                ),
              ),
              Gap(h: 12),
              imageWidget,
            ],
          ),
        ),
      ],
    );
  }
}
