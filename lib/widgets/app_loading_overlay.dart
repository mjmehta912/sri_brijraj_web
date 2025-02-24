import 'package:flutter/material.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const CustomLoadingOverlay({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black38,
      child: const Center(
        child: CircularProgressIndicator(
          color: kColorDarkBlue,
        ),
      ),
    );
  }
}
