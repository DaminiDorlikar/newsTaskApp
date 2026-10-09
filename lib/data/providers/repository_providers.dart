import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/dio_provider.dart';
import '../datasources/local_storage_datasource.dart';
import '../datasources/news_remote_datasource.dart';
import '../repositories/auth_repository_impl.dart';
import '../repositories/favorites_repository_impl.dart';
import '../repositories/news_repository_impl.dart';

final localStorageProvider = Provider<LocalStorageDataSource>((ref) => LocalStorageDataSource(sessionBox: Hive.box(AppConstants.sessionBox), favoritesBox: Hive.box(AppConstants.favoritesBox)));
final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) => NewsRemoteDataSource(dio: ref.watch(dioProvider)));
final newsRepositoryProvider = Provider<NewsRepositoryImpl>((ref) => NewsRepositoryImpl(ref.watch(newsRemoteDataSourceProvider)));
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) => AuthRepositoryImpl(ref.watch(localStorageProvider)));
final favoritesRepositoryProvider = Provider<FavoritesRepositoryImpl>((ref) => FavoritesRepositoryImpl(ref.watch(localStorageProvider)));
