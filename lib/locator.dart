import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mylibrary/storage/istorage_repository.dart';
import 'package:mylibrary/storage/storage_repository.dart';

final getIt = GetIt.instance;

void setup() {
  // getIt.registerLazySingleton<IBaseAuth>(
  //   () => BaseAuth(auth: FirebaseAuth.instance, googleSignIn: GoogleSignIn.instance),
  // );

  // getIt.registerLazySingleton<IBaseRepository>(
  //   () => BaseRepository(client: Supabase.instance.client, dio: Dio()),
  // );

  getIt.registerLazySingleton<IStorageRepository>(
    () => StorageRepository(storage: FirebaseStorage.instance),
  );
}
