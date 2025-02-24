import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.validator,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.suffixIcon,
    this.isObscure = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final String hintText;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool? isObscure;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: kColorSecondary,
      cursorHeight: 20,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyles.kMediumInstrumentSans(
        fontSize: FontSize.k18FontSize,
        color: kColorBlack,
      ),
      obscureText: isObscure!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.kRegularInstrumentSans(
          fontSize: FontSize.k16FontSize,
          color: kColorBlack,
        ),
        errorStyle: TextStyles.kMediumInstrumentSans(
          fontSize: FontSize.k16FontSize,
          color: kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: kColorPrimary,
          borderWidth: 1.5,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        errorBorder: outlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1.5,
        ),
        contentPadding: AppPaddings.combined(
          horizontal: 20,
          vertical: 15,
        ),
        filled: true,
        fillColor: fillColor ?? kColorwhite,
        suffixIcon: suffixIcon,
        suffixIconColor: kColorPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
