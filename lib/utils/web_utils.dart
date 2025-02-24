import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WebUtils {
  /// Converts a PDF byte array to a Blob URL and opens it in a new tab.
  static void openPdfInNewTab(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Open the PDF in a new tab
    html.window.open(url, '_blank');

    // Optional: Clean up the object URL after some time
    Future.delayed(Duration(seconds: 5), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}
