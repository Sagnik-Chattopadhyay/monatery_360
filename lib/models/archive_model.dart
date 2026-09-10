class ArchiveModel {
  final String id;
  final String title;
  final String monasteryId;
  final String monasteryName;
  final String category; // 'manuscript', 'mural', 'relic', 'historical_record'
  final String era; // '17th Century', '18th Century', etc.
  final String imageUrl;
  final String? documentPdfUrl;
  final String description;
  final String language; // 'Tibetan', 'Sanskrit', 'Bhotia'

  ArchiveModel({
    required this.id,
    required this.title,
    required this.monasteryId,
    required this.monasteryName,
    required this.category,
    required this.era,
    required this.imageUrl,
    this.documentPdfUrl,
    required this.description,
    this.language = 'Tibetan',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'monasteryId': monasteryId,
      'monasteryName': monasteryName,
      'category': category,
      'era': era,
      'imageUrl': imageUrl,
      'documentPdfUrl': documentPdfUrl,
      'description': description,
      'language': language,
    };
  }

  factory ArchiveModel.fromMap(Map<String, dynamic> map, String id) {
    return ArchiveModel(
      id: id,
      title: map['title'] ?? '',
      monasteryId: map['monasteryId'] ?? '',
      monasteryName: map['monasteryName'] ?? '',
      category: map['category'] ?? 'manuscript',
      era: map['era'] ?? 'Historic',
      imageUrl: map['imageUrl'] ?? '',
      documentPdfUrl: map['documentPdfUrl'],
      description: map['description'] ?? '',
      language: map['language'] ?? 'Tibetan',
    );
  }
}
