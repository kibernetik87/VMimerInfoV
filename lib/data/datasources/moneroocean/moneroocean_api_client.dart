//(VIV [MoneroOcean API Client — 2026-10-04])

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/moneroocean_hashrate_point_model.dart';
import '../../models/moneroocean_payment_model.dart';
import '../../models/moneroocean_wallet_stats_model.dart';
import '../../models/moneroocean_worker_hashrate_point_model.dart';
import '../../models/moneroocean_worker_model.dart';

class MoneroOceanApiClient {
  MoneroOceanApiClient({http.Client? client})
    : _client = client ?? http.Client();

  static const String baseUrl = 'https://api.moneroocean.stream';

  final http.Client _client;

  Future<MoneroOceanWalletStatsModel> getWalletStats(
    String walletAddress,
  ) async {
    final uri = Uri.parse('$baseUrl/miner/$walletAddress/stats');

    final response = await _client.get(uri);

    _checkResponse(response);

    final json = _decodeObject(response.body);

    return MoneroOceanWalletStatsModel.fromJson(json);
  }

  //(VIV [Get Workers — 2026-10-03])

  Future<List<MoneroOceanWorkerModel>> getWorkers(String walletAddress) async {
    final uri = Uri.parse('$baseUrl/miner/$walletAddress/stats/allWorkers');

    final response = await _client.get(uri);

    _checkResponse(response);

    final json = _decodeObject(response.body);

    final workers = <MoneroOceanWorkerModel>[];

    for (final entry in json.entries) {
      // MoneroOcean повертає global як агреговану
      // статистику всього гаманця, а не окремий Worker.
      if (entry.key == 'global') {
        continue;
      }

      final value = entry.value;

      if (value is! Map<String, dynamic>) {
        continue;
      }

      workers.add(MoneroOceanWorkerModel.fromJson(value));
    }

    return workers;
  }

  Future<MoneroOceanWorkerModel> getWorkerStats(
    String walletAddress,
    String workerIdentifier,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/miner/$walletAddress/stats/$workerIdentifier',
    );

    final response = await _client.get(uri);

    _checkResponse(response);

    final json = _decodeObject(response.body);

    return MoneroOceanWorkerModel.fromJson(json);
  }

  //(VIV [Get Hashrate History — 2026-10-04])

  Future<List<MoneroOceanHashratePointModel>> getHashrateHistory(
    String walletAddress,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/miner/$walletAddress/chart/hashrate/allWorkers',
    );

    final response = await _client.get(uri);

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'MoneroOcean hashrate history must be a JSON object. '
        'Type: ${decoded.runtimeType}.',
      );
    }

    final global = decoded['global'];

    if (global is! List) {
      throw FormatException(
        'MoneroOcean hashrate history does not contain '
        'a valid global list. '
        'Type: ${global.runtimeType}.',
      );
    }

    return global
        .whereType<Map<String, dynamic>>()
        .map(MoneroOceanHashratePointModel.fromJson)
        .toList();
  }

  //(VIV [Get Worker Hashrate History — 2026-10-04])

  Future<List<MoneroOceanWorkerHashratePointModel>> getWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) async {
    final uri = Uri.parse(baseUrl).replace(
      pathSegments: [
        'miner',
        walletAddress,
        'chart',
        'hashrate',
        workerIdentifier,
      ],
    );

    final response = await _client.get(uri);

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw FormatException(
        'MoneroOcean worker hashrate history must be a JSON list. '
        'Type: ${decoded.runtimeType}.',
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(MoneroOceanWorkerHashratePointModel.fromJson)
        .toList();
  }

  //(VIV [Get Payments — 2026-10-04])

  Future<List<MoneroOceanPaymentModel>> getPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) async {
    final uri = Uri.parse('$baseUrl/miner/$walletAddress/payments').replace(
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );

    final response = await _client.get(uri);

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException('MoneroOcean payments must be a list.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(MoneroOceanPaymentModel.fromJson)
        .toList();
  }

  Map<String, dynamic> _decodeObject(String body) {
    final decoded = jsonDecode(body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'MoneroOcean API response must be a JSON object.',
      );
    }

    return decoded;
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MoneroOceanApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

//(VIV [MoneroOcean API Exception — 2026-10-03])

class MoneroOceanApiException implements Exception {
  const MoneroOceanApiException({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  String toString() {
    return 'MoneroOceanApiException('
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}
