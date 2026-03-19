class HandstandSession {
  HandstandSession({
    required this.id,
    required this.startedAt,
    required this.durationMs,
    this.notes,
  });

  final String id;
  final DateTime startedAt;
  final int durationMs;
  final String? notes;

  Duration get duration => Duration(milliseconds: durationMs);

  Map<String, dynamic> toMap() => {
        'id': id,
        'startedAt': startedAt.toIso8601String(),
        'durationMs': durationMs,
        'notes': notes,
      };

  factory HandstandSession.fromMap(Map<String, dynamic> map) {
    return HandstandSession(
      id: map['id'] as String,
      startedAt: DateTime.parse(map['startedAt'] as String),
      durationMs: map['durationMs'] as int,
      notes: map['notes'] as String?,
    );
  }
}
