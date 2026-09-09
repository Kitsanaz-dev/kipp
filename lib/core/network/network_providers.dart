// core/network/network_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_client.dart';
import 'token_storage.dart';

part 'network_providers.g.dart';

@riverpod
TokenStorage tokenStorage(TokenStorageRef ref) => TokenStorage();

@riverpod
ApiClient apiClient(ApiClientRef ref) =>
    ApiClient(ref.watch(tokenStorageProvider));
