import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';

void showErrorDialog(String title, String message) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: AppPaddings.p20,
        decoration: BoxDecoration(
          color: kColorwhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 50,
            ),
            AppSpaces.v10,
            Text(
              title,
              style: TextStyles.kSemiBoldInstrumentSans(
                fontSize: FontSize.k20FontSize,
                color: kColorRed,
              ),
            ),
            AppSpaces.v10,
            Text(
              message,
              style: TextStyles.kRegularInstrumentSans(
                fontSize: FontSize.k16FontSize,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpaces.v20,
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "OK",
                style: TextStyles.kBoldInstrumentSans(
                  fontSize: FontSize.k20FontSize,
                  color: kColorRed,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showSuccessDialog(String title, String message) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: AppPaddings.p20,
        decoration: BoxDecoration(
          color: kColorwhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyles.kBoldInstrumentSans(
                fontSize: FontSize.k22FontSize,
                color: kColorGreen,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyles.kRegularInstrumentSans(
                fontSize: FontSize.k16FontSize,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "OK",
                style: TextStyles.kBoldInstrumentSans(
                  fontSize: FontSize.k20FontSize,
                  color: kColorGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
