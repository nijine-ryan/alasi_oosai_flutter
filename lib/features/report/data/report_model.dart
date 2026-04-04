class ReportModel {
  final String id;
  final String title;
  final String description;
  final String pdfUrl;
  /// Formatted file size label — not returned by API, shown as 'PDF' fallback.
  final String fileSize;
  final DateTime? createdAt;

  const ReportModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.pdfUrl,
    this.fileSize = 'PDF',
    this.createdAt,
  });

  factory ReportModel.fromApi(Map<String, dynamic> json) {
    DateTime? createdAt;
    final rawDate = json['createdAt'] as String?;
    if (rawDate != null && rawDate.isNotEmpty) {
      try {
        createdAt = DateTime.parse(rawDate).toLocal();
      } catch (_) {}
    }

    return ReportModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pdfUrl: json['pdfUrl'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}
