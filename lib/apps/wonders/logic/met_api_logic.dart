import 'dart:collection';

import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/common/string_utils.dart';
import 'package:flutter_erp/apps/wonders/logic/data/artifact_data.dart';
import 'package:flutter_erp/apps/wonders/logic/met_api_service.dart';

import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

class MetAPILogic {
  final HashMap<String, ArtifactData?> _artifactCache = HashMap();

  MetAPIService get service => GetIt.I.get<MetAPIService>();

  /// Returns artifact data by ID. Returns null if artifact cannot be found. */
  Future<ArtifactData?> getArtifactByID(String id) async {
    if (_artifactCache.containsKey(id)) return _artifactCache[id];
    ServiceResult<ArtifactData?> result = (await service.getObjectByID(id));
    /**error:The argument type 'String Function(Object)' can't be assigned to the parameter type 'String'. */
    if (!result.success) throw StringUtils.supplant($strings.artifactDetailsErrorNotFound(id), {'{artifactId}': id});
    ArtifactData? artifact = result.content;
    return _artifactCache[id] = artifact;
  }
}
