
class Recording {
  final int? id;
  final String title;
  final String voicePath;
  final Duration backgroundPosition;
  final Duration duration;
  final DateTime createdAt;

  Recording({
    this.id,
    required this.title,
    required this.voicePath,
    required this.backgroundPosition,
    required this.duration,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'voicePath': voicePath,
      'backgroundPosition': backgroundPosition.inMilliseconds,
      'duration': duration.inMilliseconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
      id: map['id'],
      title: map['title'],
      voicePath: map['voicePath'],
      backgroundPosition: Duration(milliseconds: map['backgroundPosition']),
      duration: Duration(milliseconds: map['duration']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}