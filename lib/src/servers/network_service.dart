import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yoori_ecommerce/src/utils/constants.dart';
import '../../config.dart';
import 'api_exception.dart';

class NetworkService {

  static String apiUrl = "${Config.apiServerUrl}/v100";

  static String walletRechargeUrl =
  Config.apiServerUrl.substring(0, Config.apiServerUrl.length - 4);

  // L'API retourne des URLs comme https://api.futurestoresn.com/public/images/...
  // Les fichiers sont servis depuis https://futurestoresn.com/public/images/...
  // Cette fonction remplace le domaine api. par le domaine racine dans toutes les URLs d'images.
  static String _fixImageUrls(String body) {
    final apiBase = walletRechargeUrl; // https://api.futurestoresn.com
    final uri = Uri.parse(apiBase);
    final rootHost = uri.host.startsWith('api.') ? uri.host.substring(4) : uri.host;
    final rootBase = '${uri.scheme}://$rootHost'; // https://futurestoresn.com
    if (apiBase == rootBase) return body;

    // Le JSON encode les slashes en \/ — il faut traiter les deux formes.
    // En Dart : '/' dans le JSON brut devient '\/' (barre + slash).
    // replaceAll travaille sur la chaîne brute avant json.decode.
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

    final response = await http.get(
      Uri.parse(url),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'apiKey': Config.apiKey,
          'User-Agent': 'Mozilla/5.0 (Linux; Android 13; sdk_gphone64_x86_64 Build/TE1A.220922.021) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.6099.144 Mobile Safari/537.36',
          'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
        }
    );

    return response;
  }

  dynamic _returnResponse(http.Response response) {

    printLog("================================");
    printLog("STATUS CODE => ${response.statusCode}");
    printLog("CONTENT TYPE => ${response.headers['content-type']}");
    printLog("RESPONSE BODY => ${response.body}");
    printLog("================================");

    // Si le serveur renvoie du HTML
    if (response.headers['content-type']?.contains('text/html') == true) {
      throw Exception('Server returned HTML instead of JSON - bot protection triggered');
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