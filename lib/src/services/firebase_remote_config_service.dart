// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:softi_common/services.dart';

// // const String _ShowMainBanner = 'show_main_banner';

// const Map<String, dynamic> defaultValueMaster = {
//   'app_config': {
//     'accent_color': '#8c98a8',
//     'accent_dark_color': '#9999aa',
//     'app_name': 'Food Delivery',
//     'app_version': '2.3.2',
//     'currency_right': '0',
//     'default_currency': '\$',
//     'default_currency_decimal_digits': '2',
//     'default_tax': '10',
//     'enable_paypal': '1',
//     'enable_razorpay': '1',
//     'enable_stripe': '1',
//     'enable_version': '1',
//     'fcm_key': '',
//     'google_maps_key': '',
//     'main_color': '#ea5c44',
//     'main_dark_color': '#ea5c44',
//     'mobile_language': 'en',
//     'scaffold_color': '#fafafa',
//     'scaffold_dark_color': '#2c2c2c',
//     'second_color': '#344968',
//     'second_dark_color': '#ccccdd',
//   }
// };

// class RemoteConfigService extends IRemoteConfigService {
//   final RemoteConfig remoteConfig;
//   final Map<String, dynamic> defaults;

//   RemoteConfigService({this.remoteConfig, this.defaults = defaultValueMaster}); //: remoteConfig = remoteConfig;

//   // Map<String, dynamic> get getConfig => remoteConfig.getValue('app_config');

//   @override
//   Future initialise([Map<String, dynamic> defaultConfig = defaultValueMaster]) async {
//     try {
//       if (defaultConfig != null) await remoteConfig.setDefaults(defaultConfig ?? defaults);
//       await remoteConfig.fetch(expiration: Duration(seconds: 2));
//       await remoteConfig.activateFetched();
//       var t = remoteConfig.getAll();
//       print(t);
//     } on FetchThrottledException catch (e) {
//       print('Remote config fetch throttled: $e');
//     } catch (e) {
//       print('Unable to fetch remote config. Cached or default values will be used');
//     }
//   }
// }
