import '../../config.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CONFIGURATION
// ──────────────────────────────────────────────────────────────────────────────

/// Mettre à `true` si les images restent en 404 après le premier déploiement.
///
/// Contexte : Laravel génère des URLs comme
///   https://futurestoresn.com/public/images/product/xyz.jpg
/// Si Nginx pointe sur le dossier `/public/` comme web root (configuration
/// standard Laravel), le `/public/` est déjà la racine et doit être supprimé :
///   https://futurestoresn.com/images/product/xyz.jpg
///
/// Laisser à `false` si les images fonctionnent déjà correctement.
const bool _stripPublicPrefix = true;

// ──────────────────────────────────────────────────────────────────────────────
// URL DE BASE
// ──────────────────────────────────────────────────────────────────────────────

/// Calcule l'URL de base pour les images à partir de [Config.apiServerUrl].
///
/// Exemple :
///   "https://api.futurestoresn.com/api"
///   → strip "/api"  → "https://api.futurestoresn.com"
///   → strip "api."  → "https://futurestoresn.com"
String get imageBaseUrl {
  // Retirer le suffixe "/api"
  var base = Config.apiServerUrl;
  if (base.endsWith('/api')) {
    base = base.substring(0, base.length - 4);
  }
  final uri = Uri.parse(base);
  // Retirer le sous-domaine "api." si présent
  final host =
      uri.host.startsWith('api.') ? uri.host.substring(4) : uri.host;
  return '${uri.scheme}://$host';
}

// ──────────────────────────────────────────────────────────────────────────────
// FONCTION PRINCIPALE
// ──────────────────────────────────────────────────────────────────────────────

/// Sanitise et retourne une URL d'image utilisable depuis [raw].
///
/// Règles appliquées dans l'ordre :
/// 1. `null` / vide → retourne `''` (le widget affichera le fallback)
/// 2. Déjà absolue (commence par "http") → retournée telle quelle
/// 3. Chemin relatif → préfixé par [imageBaseUrl]
/// 4. Si [_stripPublicPrefix] est `true`, supprime le segment `/public`
///    immédiatement après le host (ex: `/public/images/…` → `/images/…`)
String buildImageUrl(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';

  var url = raw.trim();

  // Cas 3 : chemin relatif → rendre absolu
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    final path = url.startsWith('/') ? url : '/$url';
    url = '$imageBaseUrl$path';
  }

  // Cas 4 (optionnel) : supprimer le préfixe /public/ après le host
  if (_stripPublicPrefix) {
    url = _removePublicSegment(url);
  }

  return url;
}

/// Supprime le segment `/public` qui suit immédiatement le host dans [url].
///
/// Exemple :
///   "https://futurestoresn.com/public/images/product/xyz.jpg"
///   → "https://futurestoresn.com/images/product/xyz.jpg"
String _removePublicSegment(String url) {
  try {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.toList();
    if (segments.isNotEmpty && segments.first == 'public') {
      final newPath = '/${segments.sublist(1).join('/')}';
      return uri.replace(path: newPath).toString();
    }
  } catch (_) {
    // URL malformée — retourner telle quelle
  }
  return url;
}
