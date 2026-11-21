//(VIV [MoneroOcean API Client Tests — 2026-10-04])

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:vmimerinfov/data/datasources/moneroocean/moneroocean_api_client.dart';

class _MockHttpClient extends http.BaseClient {
  _MockHttpClient({required this.handler});

  final Future<http.Response> Function(http.BaseRequest request) handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request);

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
      reasonPhrase: response.reasonPhrase,
    );
  }
}

void main() {
  group('MoneroOceanApiClient', () {
    test('parses wallet stats', () async {
      final client = _MockHttpClient(
        handler: (request) async {
          expect(
            request.url.toString(),
            'https://api.moneroocean.stream/miner/test-wallet/stats',
          );

          return http.Response('''
            {
              "hash": 1234,
              "hash2": 567,
              "identifier": "test-wallet",
              "lastHash": 1200,
              "totalHashes": 987654,
              "validShares": 321,
              "invalidShares": 4,
              "amtPaid": 0.25,
              "amtDue": 0.015,
              "txnCount": 3
            }
            ''', 200);
        },
      );

      final api = MoneroOceanApiClient(client: client);

      final result = await api.getWalletStats('test-wallet');

      expect(result.hash, 1234);
      expect(result.hash2, 567);
      expect(result.identifier, 'test-wallet');
      expect(result.totalHashes, 987654);
      expect(result.validShares, 321);
      expect(result.invalidShares, 4);
      expect(result.amtPaid, 0.25);
      expect(result.amtDue, 0.015);
      expect(result.txnCount, 3);

      api.dispose();
    });

    test('parses worker stats', () async {
      final client = _MockHttpClient(
        handler: (request) async {
          expect(
            request.url.toString(),
            'https://api.moneroocean.stream/miner/test-wallet/stats/worker-01',
          );

          return http.Response('''
            {
              "lts": 1791020000,
              "identifier": "worker-01",
              "hash": 500,
              "hash2": 450,
              "totalHash": 100000,
              "validShares": 100,
              "invalidShares": 2
            }
            ''', 200);
        },
      );

      final api = MoneroOceanApiClient(client: client);

      final result = await api.getWorkerStats('test-wallet', 'worker-01');

      expect(result.identifier, 'worker-01');
      expect(result.hash, 500);
      expect(result.hash2, 450);
      expect(result.totalHash, 100000);
      expect(result.validShares, 100);
      expect(result.invalidShares, 2);
      expect(result.lastSeen, 1791020000);

      api.dispose();
    });

    //(VIV [Hashrate History API Shape Test — 2026-10-04])

    test('parses hashrate history', () async {
      final client = _MockHttpClient(
        handler: (request) async {
          expect(
            request.url.toString(),
            'https://api.moneroocean.stream/miner/test-wallet/chart/hashrate/allWorkers',
          );

          return http.Response('''
            {
              "global": [
                {
                  "ts": 1791102264000,
                  "hs": 1000,
                  "hs2": 900
                },
                {
                  "ts": 1791102157000,
                  "hs": 1200,
                  "hs2": 1100
                }
              ]
            }
            ''', 200);
        },
      );

      final api = MoneroOceanApiClient(client: client);

      final result = await api.getHashrateHistory('test-wallet');

      expect(result, hasLength(2));
      expect(result[0].hashRate, 1000);
      expect(result[0].hashRate2, 900);
      expect(result[1].hashRate, 1200);
      expect(result[1].hashRate2, 1100);

      api.dispose();
    });

    test('throws MoneroOceanApiException for HTTP error', () async {
      final client = _MockHttpClient(
        handler: (request) async {
          return http.Response('{"error":"wallet not found"}', 404);
        },
      );

      final api = MoneroOceanApiClient(client: client);

      expect(
        () => api.getWalletStats('test-wallet'),
        throwsA(
          isA<MoneroOceanApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            404,
          ),
        ),
      );

      api.dispose();
    });

    //(VIV [Hashrate History Invalid Shape Test — 2026-10-04])

    test('throws FormatException for invalid history JSON shape', () async {
      final client = _MockHttpClient(
        handler: (request) async {
          return http.Response('{"unexpected":"object"}', 200);
        },
      );

      final api = MoneroOceanApiClient(client: client);

      expect(
        () => api.getHashrateHistory('test-wallet'),
        throwsA(isA<FormatException>()),
      );

      api.dispose();
    });
  });
}
