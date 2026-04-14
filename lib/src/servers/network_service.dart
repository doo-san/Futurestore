import 'dart:convert';
import 'dart:io';
import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart' as http;
import 'package:yoori_ecommerce/src/utils/constants.dart';
import '../../config.dart';
import 'api_exception.dart';

class NetworkService {

  static String apiUrl = "${Config.apiServerUrl}/v100";

  static String walletRechargeUrl =
  Config.apiServerUrl.substring(0, Config.apiServerUrl.length - 4);

  // Utilise Cronet sur Android (même TLS fingerprint que Chrome)
  // Utilise le client HTTP standard sur les autres plateformes
  static final http.Client client = Platform.isAndroid
      ? CronetClient.fromCronetEngine(
          CronetEngine.build(cacheMode: CacheMode.disabled),
          closeEngine: true,
        )
      : http.Client();

  static String _fixImageUrls(String body) {
    final apiBase = walletRechargeUrl;
    final uri = Uri.parse(apiBase);
    final rootHost = uri.host.startsWith('api.') ? uri.host.substring(4) : uri.host;
    final rootBase = '${uri.scheme}://$rootHost';
    if (apiBase == rootBase) return body;

    final escapedApi  = apiBase.replaceAll('/', r'\/');
    final escapedRoot = rootBase.replaceAll('/', r'\/');

    return body
        .replaceAll(apiBase, rootBase)
        .replaceAll(escapedApi, escapedRoot);
  }

  Future fetchJsonData(String url) {
    return _getData(url);
  }

  Future<http.Response> getRequest(String url) async {
    printLog("📡 API CALL => $url");

    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'apiKey': Config.apiKey,
      },
    );

    return response;
  }

  dynamic _returnResponse(http.Response response) {
    printLog("================================");
    printLog("STATUS CODE => ${response.statusCode}");
    printLog("CONTENT TYPE => ${response.headers['content-type']}");
    printLog("RESPONSE BODY => ${response.body.substring(0, response.body.length.clamp(0, 300))}");
    printLog("================================");

    final contentType = response.headers['content-type'] ?? '';
    final trimmedBody = response.body.trimLeft();
    final looksLikeJson = trimmedBody.startsWith('{') || trimmedBody.startsWith('[');
    if (contentType.contains('text/html') && !looksLikeJson) {
      printLog("🚫 HTML detected. Body preview: ${response.body.substring(0, response.body.length.clamp(0, 200))}");
      throw Exception('Server returned HTML instead of JSON');
    }

    switch (response.statusCode) {
      case 200:
        if (response.body.isEmpty) {
          throw FetchDataException("Empty response from server");
        }
        return json.decode(_fixImageUrls(response.body));

      case 401:
        throw UnauthorisedException("Unauthorized request");

      case 403:
        throw FetchDataException("Access forbidden by server");

      case 404:
        throw FetchDataException("API endpoint not found (404)");

      case 500:
        throw FetchDataException("Internal server error");

      default:
        throw FetchDataException(
          "Error communicating with server: ${response.statusCode}",
        );
    }
  }

  Future<dynamic> _getData(String url) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final response = await getRequest(url);
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
  }
}
