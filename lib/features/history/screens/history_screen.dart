import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/features/history/controllers/history_controller.dart';
import 'package:sri_brijraj_web/features/history/models/history_model_dm.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';
import 'package:sri_brijraj_web/widgets/app_text_form_field.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController _controller = Get.put(HistoryController());

  @override
  void initState() {
    super.initState();
    _controller.fetchSlipHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorwhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double paddingHorizontal = screenWidth > 1200 ? 40 : 20;
          double paddingVertical = screenWidth > 1200 ? 20 : 10;

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: paddingVertical),
            child: Column(
              children: [
                // Search Bar
                SizedBox(
                  width: screenWidth * 0.4,
                  child: AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search Slip',
                    onChanged: (query) {
                      _controller.searchQuery.value = query;
                    },
                  ),
                ),
                AppSpaces.v12,

                // History List
                Expanded(
                  child: Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return Center(
                          child:
                              CircularProgressIndicator(color: kColorDarkBlue),
                        );
                      }
                      if (_controller.historyList.isEmpty) {
                        return Center(
                          child: Text(
                            'No history found.',
                            style: TextStyles.kBoldInstrumentSans(
                                color: kColorSecondary),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _controller.scrollController,
                        itemCount: _controller.historyList.length,
                        itemBuilder: (context, index) {
                          final history = _controller.historyList[index];
                          return HistoryCard(
                            history: history,
                            isWideScreen: screenWidth > 600,
                            controller: _controller,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.history,
    required this.isWideScreen,
    required HistoryController controller,
  }) : _controller = controller;

  final HistoryModelDm history;
  final HistoryController _controller;
  final bool isWideScreen;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kColorwhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: kColorBlack, width: 1),
      ),
      child: Padding(
        padding: AppPaddings.p16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slip Number and Print Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  history.slipNo,
                  style: TextStyles.kBoldInstrumentSans(
                    fontSize: isWideScreen ? 22 : 18,
                    color: kColorPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => _controller.viewPdf(slipNo: history.slipNo),
                  icon: Icon(Icons.print, color: kColorPrimary, size: 24),
                ),
              ],
            ),
            AppSpaces.v8,

            // User, Date, and Vehicle Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (history.user != null && history.user!.isNotEmpty)
                  Expanded(
                    child: Text(
                      history.user ?? '',
                      style: TextStyles.kMediumInstrumentSans(
                        fontSize: 14,
                        color: kColorSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Expanded(
                  child: Text(
                    history.vehicleNo,
                    style: TextStyles.kMediumInstrumentSans(
                      fontSize: 16,
                      color: kColorBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            AppSpaces.v8,

            // Items List
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: history.items.map((item) {
                return Chip(
                  backgroundColor: kColorPrimary.withOpacity(0.1),
                  label: Text(
                    '${item.iname} - ${item.qty} ${item.iname == "Petrol" || item.iname == "Diesel" ? "L" : ""}',
                    style: TextStyles.kMediumInstrumentSans(
                      fontSize: 14,
                      color: kColorPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
            AppSpaces.v8,

            // Transporter
            if (history.transporter.isNotEmpty)
              Text(
                'Transporter: ${history.transporter}',
                style: TextStyles.kMediumInstrumentSans(
                  fontSize: 14,
                  color: kColorSecondary,
                ),
              ),

            // Entry Date and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    history.date,
                    style: TextStyles.kMediumInstrumentSans(
                      fontSize: 14,
                      color: kColorBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    history.entryDateTime,
                    style: TextStyles.kMediumInstrumentSans(
                      fontSize: 14,
                      color: kColorSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            // Remarks
            if (history.remark.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '"${history.remark}"',
                  style: TextStyles.kMediumInstrumentSans(
                    fontSize: 14,
                    color: kColorPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
