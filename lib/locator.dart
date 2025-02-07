
import 'package:flutter_fundraising_goal_chart/services/firebase_auth_service.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;
void SetupLocator(){
  locator.registerLazySingleton(()=>FirebaseAuthService());
  locator.registerLazySingleton(()=>UserRepository());
}