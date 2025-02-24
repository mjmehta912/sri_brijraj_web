import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';

class AppDatePickerTextFormField extends StatefulWidget {
  const AppDatePickerTextFormField({
    super.key,
    required this.dateController,
    required this.hintText,
    this.fillColor = kColorwhite,
    this.enabled = true,
  });

  final TextEditingController dateController;
  final String hintText;
  final Color fillColor;
  final bool enabled;

  @override
  State<AppDatePickerTextFormField> createState() =>
      _AppDatePickerTextFormFieldState();
}

class _AppDatePickerTextFormFieldState
    extends State<AppDatePickerTextFormField> {
  static const String dateFormat = 'dd-MM-yyyy';

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = _parseDate(
          widget.dateController.text,
        ) ??
        DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: _buildDatePickerTheme(context),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _focusNode.unfocus();
      setState(
        () {
          widget.dateController.text = DateFormat(
            dateFormat,
          ).format(
            pickedDate,
          );
        },
      );
    }
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateFormat(
        dateFormat,
      ).parseStrict(
        dateString,
      );
    } catch (e) {
      return null;
    }
  }

  ThemeData _buildDatePickerTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      primaryColor: kColorPrimary,
      colorScheme: const ColorScheme.light(
        primary: kColorPrimary,
        onPrimary: kColorwhite,
        surface: kColorwhite,
      ),
      dialogBackgroundColor: kColorwhite,
      textTheme: TextTheme(
        headlineLarge: TextStyles.kBoldInstrumentSans(
          fontSize: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        enabled: widget.enabled,
        hintText: widget.hintText,
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
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: kColorPrimary,
          ),
          onPressed: () => _selectDate(context),
        ),
      ),
      style: TextStyles.kMediumInstrumentSans(
        fontSize: FontSize.k18FontSize,
        color: kColorBlack,
      ),
      readOnly: true,
      cursorColor: kColorSecondary,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please  select a date';
        }
        return null;
      },
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
