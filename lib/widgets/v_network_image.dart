import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VNetworkImage extends CachedNetworkImage {
  static Map<String, String> createHttpHeaders(
      Map<String, String>? httpHeaders) {
    Map<String, String> headers = httpHeaders ?? {};
    headers.putIfAbsent(
        HttpHeaders.userAgentHeader,
        () =>
            "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1");
    return headers;
  }

  static String fixImageUrl(String url) {
    if (url.startsWith('http://')) {
      url = url.replaceFirst(new RegExp(r'^http:\/\/'), 'https://');
    } else if (url.startsWith('//')) {
      url = url.replaceFirst(new RegExp(r'^\/\/'), 'https://');
    }
    return url;
  }

  VNetworkImage(
      {required String imageUrl,
      double? width,
      double? height,
      BoxFit? fit,
      PlaceholderWidgetBuilder? placeholder,
      Map<String, String>? httpHeaders})
      : super(
            imageUrl: fixImageUrl(imageUrl),
            width: width,
            height: height,
            fit: fit,
            placeholder: placeholder,
            httpHeaders: createHttpHeaders(httpHeaders));
}
