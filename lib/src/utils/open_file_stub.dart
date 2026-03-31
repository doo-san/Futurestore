// Stub for web platform — open_file_safe_plus is not supported on web.
class OpenResult {
  final String type;
  final String message;
  const OpenResult({this.type = '', this.message = ''});
  @override
  String toString() => message;
}

class OpenFileSafePlus {
  static Future<OpenResult> open(String? filePath) async {
    return const OpenResult(message: 'Not supported on web');
  }
}
