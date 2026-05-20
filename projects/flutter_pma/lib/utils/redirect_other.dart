import 'package:flutter_pma/utils/redirect.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectorImpl extends Redirector {

  @override
  void go(url) {
    launchUrl(Uri.parse(url), mode : LaunchMode.externalApplication);
  }

  @override
  String? param(name){
    return '';
  }
  
}

Redirector getManager() =>RedirectorImpl();