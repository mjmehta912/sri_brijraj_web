import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/features/reports/controllers/reports_controller.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/utils/alert_message_utils.dart';
import 'package:sri_brijraj_web/utils/text_input_formatters.dart';
import 'package:sri_brijraj_web/widgets/app_button.dart';
import 'package:sri_brijraj_web/widgets/app_date_picker_text_form_field.dart';
import 'package:sri_brijraj_web/widgets/app_loading_overlay.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_size_extensions.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';
import 'package:sri_brijraj_web/widgets/app_text_form_field.dart';

class ReportFilterScreen extends StatefulWidget {
  const ReportFilterScreen({
    super.key,
  });

  @override
  State<ReportFilterScreen> createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  final ReportsController _controller = Get.put(
    ReportsController(),
  );

  @override
  void initState() {
    super.initState();

    _controller.fromDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    _controller.toDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    _controller.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kColorwhite,
            body: Center(
              child: Padding(
                padding: AppPaddings.p20,
                child: Column(
                  children: [
                    SizedBox(
                      width: 0.4.screenWidth,
                      child: AppDatePickerTextFormField(
                        dateController: _controller.fromDateController,
                        hintText: 'From Date',
                      ),
                    ),
                    AppSpaces.v20,
                    SizedBox(
                      width: 0.4.screenWidth,
                      child: AppDatePickerTextFormField(
                        dateController: _controller.toDateController,
                        hintText: 'To Date',
                      ),
                    ),
                    AppSpaces.v20,
                    SizedBox(
                      width: 0.4.screenWidth,
                      child: AppTextFormField(
                        controller: _controller.transporterNameController,
                        hintText: 'Transporter',
                        onChanged: (value) {
                          _controller.fetchTransporters(
                            tname: value,
                          );
                        },
                        inputFormatters: [
                          TitleCaseTextInputFormatter(),
                        ],
                      ),
                    ),
                    Obx(
                      () {
                        if (_controller.filteredTransporters.isEmpty ||
                            _controller
                                .transporterNameController.text.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Container(
                            height: 0.3.screenHeight,
                            width: 0.4.screenWidth,
                            decoration: BoxDecoration(
                              color: kColorwhite,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: AppPaddings.p12,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  _controller.filteredTransporters.length,
                              itemBuilder: (context, index) {
                                final transporter =
                                    _controller.filteredTransporters[index];
                                return GestureDetector(
                                  onTap: () {
                                    _controller
                                        .setSelectedTransporter(transporter);
                                    _controller.filteredTransporters.clear();
                                  },
                                  child: Text(
                                    transporter.transporterName,
                                    style: TextStyles.kSemiBoldInstrumentSans(
                                      color: kColorPrimary,
                                    ).copyWith(
                                      height: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    AppSpaces.v20,
                    SizedBox(
                      width: 0.4.screenWidth,
                      child: AppTextFormField(
                        controller: _controller.customerNameController,
                        hintText: 'Owner',
                        onChanged: (value) {
                          _controller.fetchCustomers(
                            pname: value,
                          );
                        },
                        inputFormatters: [
                          TitleCaseTextInputFormatter(),
                        ],
                      ),
                    ),
                    Obx(
                      () {
                        if (_controller.filteredCustomers.isEmpty ||
                            _controller.customerNameController.text.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Container(
                            height: 0.3.screenHeight,
                            width: 0.4.screenWidth,
                            decoration: BoxDecoration(
                              color: kColorwhite,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: AppPaddings.p12,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _controller.filteredCustomers.length,
                              itemBuilder: (context, index) {
                                final customer =
                                    _controller.filteredCustomers[index];
                                return GestureDetector(
                                  onTap: () {
                                    _controller.setSelectedCustomer(customer);
                                    _controller.filteredCustomers.clear();
                                  },
                                  child: Text(
                                    customer.pname,
                                    style: TextStyles.kSemiBoldInstrumentSans(
                                      color: kColorPrimary,
                                    ).copyWith(
                                      height: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    AppSpaces.v20,
                    AppButton(
                      onPressed: () async {
                        final fromDate = _controller.fromDateController.text;
                        final toDate = _controller.toDateController.text;

                        final DateFormat format = DateFormat('dd-MM-yyyy');
                        final DateTime fromDateParsed = format.parse(fromDate);
                        final DateTime toDateParsed = format.parse(toDate);

                        if (toDateParsed.isBefore(fromDateParsed)) {
                          showErrorDialog(
                            'Error',
                            'To Date must be greater than or equal to From Date.',
                          );
                          return;
                        }
                        await _controller.downloadReport();
                      },
                      buttonHeight: 60,
                      buttonWidth: 0.4.screenWidth,
                      title: 'Download Report',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => CustomLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
