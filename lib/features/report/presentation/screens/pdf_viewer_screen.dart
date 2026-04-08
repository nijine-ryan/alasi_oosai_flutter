import 'dart:io';
import 'dart:typed_data';

import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isDownloading = true;
  String? _error;
  String? _localPath;

  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  bool _isValidPdf(Uint8List bytes) =>
      bytes.length >= 5 &&
      bytes[0] == 0x25 && // %
      bytes[1] == 0x50 && // P
      bytes[2] == 0x44 && // D
      bytes[3] == 0x46 && // F
      bytes[4] == 0x2D; // -

  Future<void> _downloadPdf() async {
    if (!mounted) return;
    setState(() {
      _isDownloading = true;
      _error = null;
      _localPath = null;
      _totalPages = 0;
      _currentPage = 0;
    });

    try {
      final response = await http.get(
        Uri.parse(widget.url),
        headers: {'Authorization': 'Bearer ${AuthService.authToken}'},
      );

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      final bytes = response.bodyBytes;

      if (bytes.isEmpty) {
        throw Exception('The server returned an empty response');
      }

      if (!_isValidPdf(bytes)) {
        throw Exception(
          'Invalid PDF — the server may have returned an error page instead of the file',
        );
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(bytes);

      if (!mounted) return;
      setState(() {
        _localPath = file.path;
        _isDownloading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate900,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.slate800,
      foregroundColor: AppColors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (_totalPages > 0)
            Text(
              'Page ${_currentPage + 1} of $_totalPages',
              style: const TextStyle(fontSize: 11, color: AppColors.slate400),
            ),
        ],
      ),
      actions: [
        if (_totalPages > 1) ...[
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous page',
            onPressed: _currentPage > 0
                ? () => _pdfController?.setPage(_currentPage - 1)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next page',
            onPressed: _currentPage < _totalPages - 1
                ? () => _pdfController?.setPage(_currentPage + 1)
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    if (_isDownloading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Downloading PDF…',
              style: TextStyle(color: AppColors.slate400, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf_outlined,
                size: 56,
                color: AppColors.slate500,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.slate400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PDFView(
      key: ValueKey(_localPath),
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      defaultPage: 0,
      fitPolicy: FitPolicy.BOTH,
      nightMode: false,
      onRender: (pages) {
        if (mounted && pages != null && pages > 0) {
          setState(() => _totalPages = pages);
        }
      },
      onViewCreated: (controller) => _pdfController = controller,
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = page ?? 0;
            if (total != null && total > 0) _totalPages = total;
          });
        }
      },
      onError: (error) {
        if (mounted) setState(() => _error = 'Failed to render PDF: $error');
      },
      onPageError: (page, error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error on page ${(page ?? 0) + 1}: $error'),
            ),
          );
        }
      },
    );
  }
}
