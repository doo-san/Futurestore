import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoori_ecommerce/src/utils/image_url_helper.dart';

/// Widget universel pour l'affichage des images réseau.
///
/// Fonctionnalités :
/// - Accepte une URL nullable (affiche le fallback si vide / null)
/// - Corrige automatiquement les URLs relatives ou malformées via [buildImageUrl]
/// - Détecte les SVG et utilise [SvgPicture.network] le cas échéant
/// - Utilise [CachedNetworkImage] pour les images raster (cache + placeholder)
/// - Affiche un indicateur de chargement pendant le téléchargement
/// - Affiche un fallback (logo app) en cas d'erreur 404 ou réseau
class NetworkImageCheckerWidget extends StatelessWidget {
  final String? image;
  final BoxFit fit;
  final double? width;
  final double? height;

  const NetworkImageCheckerWidget({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final url = buildImageUrl(image);

    if (url.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const _ImageFallback(),
      );
    }

    if (url.toLowerCase().contains('.svg')) {
      return SvgPicture.network(
        url,
        fit: fit,
        width: width,
        height: height,
        placeholderBuilder: (_) => SizedBox(
          width: width,
          height: height,
          child: const _ImagePlaceholder(),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => SizedBox(
        width: width,
        height: height,
        child: const _ImagePlaceholder(),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: const _ImageFallback(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Image.asset(
        'assets/logos/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Enum conservé pour compatibilité avec l'ancien code éventuel
// ──────────────────────────────────────────────────────────────────────────────
enum ImageType { svg, nonSvg }
