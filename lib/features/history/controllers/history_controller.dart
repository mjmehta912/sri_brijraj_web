import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/features/history/models/history_model_dm.dart';
import 'package:sri_brijraj_web/features/history/screens/pdf_screen.dart';
import 'package:sri_brijraj_web/features/history/services/history_api_service.dart';
import 'package:sri_brijraj_web/utils/alert_message_utils.dart';
import 'package:sri_brijraj_web/utils/web_utils.dart'; // Helper for Web PDF

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var currentPage = 1;
  var pageSize = 10;

  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  var historyList = <HistoryModelDm>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchSlipHistory();
    debounceSearchQuery();
    scrollController.addListener(_scrollListener);
  }

  void debounceSearchQuery() {
    debounce(
      searchQuery,
      (_) => fetchSlipHistory(),
      time: const Duration(milliseconds: 300),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchSlipHistory(loadMore: true);
    }
  }

  var isFetchingData = false;

  Future<void> fetchSlipHistory({bool loadMore = false}) async {
    if (isFetchingData) return;
    if (loadMore && !hasMoreData.value) return;

    try {
      isFetchingData = true;

      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
        historyList.clear();
        hasMoreData.value = true;
      } else {
        isLoadingMore.value = true;
      }

      var fetchedHistory = await HistoryService.fetchHistory(
        pageNumber: currentPage,
        pageSize: pageSize,
        slipNo: searchQuery.value,
      );

      if (fetchedHistory.isNotEmpty) {
        historyList.addAll(fetchedHistory);
        currentPage++;
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      showErrorDialog('Error', e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFetchingData = false;
    }
  }

  Future<void> viewPdf({required String slipNo}) async {
    try {
      isLoading.value = true;
      final pdfBytes = await HistoryService.downloadSlip(slipNo: slipNo);

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        if (kIsWeb) {
          // **Web: Convert to Blob URL and Open**
          WebUtils.openPdfInNewTab(pdfBytes);
        } else {
          // **Mobile: Navigate to PdfScreen**
          Get.to(() => PdfScreen(pdfBytes: pdfBytes, title: slipNo));
        }
      }
    } catch (e) {
      showErrorDialog('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
