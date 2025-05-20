import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vedalaya_app/core/themes/app_constants.dart';

class ShareOption extends StatelessWidget {
  final String chapterName;
  final String? serverThumbnailUrl;

  const ShareOption({
    required this.chapterName,
    this.serverThumbnailUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () => _shareContent(context),
          icon: Icon(Icons.share, size: 24, color: AppConstants.purpleColor),
        ),
        Text(
          "Share",
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppConstants.purpleColor,
          ),
        ),
      ],
    );
  }

  Future<void> _shareContent(BuildContext context) async {
    try {
      final message = '''
Check out this chapter "$chapterName" on Vedalaya App!

Download Vedalaya App now to learn more:
https://vedalaya.com/download
''';

      String? imagePath;

      // Try server image first
      if (serverThumbnailUrl != null) {
        imagePath = await _downloadAndSaveImage(serverThumbnailUrl!);
      }

      // Fallback to asset image
      imagePath ??= await _loadAssetImage();

      // Single share dialog
      if (imagePath != null) {
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: message,
          subject: 'Vedalaya: $chapterName',
        );
      } else {
        await Share.share(message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sharing failed: ${e.toString()}")),
      );
    }
  }

  Future<String?> _downloadAndSaveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File(
            '${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('Server image download failed: $e');
    }
    return null;
  }

  Future<String?> _loadAssetImage() async {
    try {
      final bytes = await rootBundle.load('assets/icons/vedalaya.png');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vedalaya_share.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      return file.path;
    } catch (e) {
      debugPrint('Asset image load failed: $e');
      return null;
    }
  }
}
