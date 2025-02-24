import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb; // Import for web check
import 'package:flutter/material.dart';
import 'package:sri_brijraj_web/features/add_entry/models/customer_dm.dart';
import 'package:sri_brijraj_web/features/add_entry/models/transporter_dm.dart';
import 'package:sri_brijraj_web/features/add_entry/services/add_entry_service.dart';
import 'package:sri_brijraj_web/features/reports/services/reports_service.dart';
import 'package:sri_brijraj_web/utils/alert_message_utils.dart';
import 'package:universal_html/html.dart' as html; // Web-specific import
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  var isLoading = false.obs;

  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();

  final customerNameController = TextEditingController();
  var selectedCustomerCode = ''.obs;
  var selectedCustomerName = ''.obs;
  var customers = <CustomerDm>[].obs;
  var filteredCustomers = <CustomerDm>[].obs;

  final transporterNameController = TextEditingController();
  var transporters = <TransporterDm>[].obs;
  var filteredTransporters = <TransporterDm>[].obs;
  var selectedTransporter = ''.obs;

  Future<void> fetchCustomers({String? pname}) async {
    try {
      isLoading.value = true;

      final fetchedCustomers =
          await AddEntryService.fetchCustomersByName(pname);
      customers.assignAll(fetchedCustomers);

      if (pname == null || pname.isEmpty) {
        filteredCustomers.assignAll(customers);
      } else {
        filterCustomers(pname);
      }
    } catch (e) {
      showErrorDialog(
        'Failed to load customers',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.value = customers
          .where(
            (customer) => customer.pname.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void setSelectedCustomer(CustomerDm customer) {
    selectedCustomerName.value = customer.pname;
    selectedCustomerCode.value = customer.pcode;
    customerNameController.text = customer.pname;
    filteredCustomers.clear();
  }

  Future<void> fetchTransporters({String? tname}) async {
    try {
      isLoading.value = true;

      final fetchedTransporters = await AddEntryService.fetchTransporter(tname);
      transporters.assignAll(fetchedTransporters);

      if (tname == null || tname.isEmpty) {
        filteredTransporters.assignAll(transporters);
      } else {
        filterTransporters(tname);
      }
    } catch (e) {
      showErrorDialog(
        'Failed to load transporters',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransporters(String query) {
    if (query.isEmpty) {
      filteredTransporters.assignAll(transporters);
    } else {
      filteredTransporters.value = transporters
          .where(
            (transporter) => transporter.transporterName.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void setSelectedTransporter(TransporterDm transporter) {
    selectedTransporter.value = transporter.transporterName;
    transporterNameController.text = transporter.transporterName;

    filteredTransporters.clear();
  }

  Future<void> downloadReport() async {
    try {
      isLoading.value = true;

      // Fetch Report Data
      Uint8List fileBytes = await ReportService.downloadExcelReport(
        fromDate: fromDateController.text,
        toDate: toDateController.text,
        transporter: selectedTransporter.value,
        pCode: selectedCustomerCode.value,
      );

      // Check if running on Web
      if (kIsWeb) {
        _downloadFileWeb(fileBytes);
      } else {
        await _downloadFileMobile(fileBytes);
      }
    } catch (e) {
      showErrorDialog('Download Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle File Download on Web
  void _downloadFileWeb(Uint8List fileBytes) {
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "report_${DateTime.now().millisecondsSinceEpoch}.xlsx")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  /// Handle File Download on Mobile
  Future<void> _downloadFileMobile(Uint8List fileBytes) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    final directory = await getApplicationSupportDirectory();
    final filePath =
        '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final io.File file = io.File(filePath);
    await file.writeAsBytes(fileBytes);

    await OpenFile.open(filePath);
  }

  /// Check and Request Storage Permissions (Mobile only)
  Future<bool> _checkStoragePermission() async {
    if (io.Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      return await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted;
    }
    return true; // iOS doesn't require explicit storage permission
  }
}
