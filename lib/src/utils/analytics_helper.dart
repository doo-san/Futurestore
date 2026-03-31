// import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  // static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
 // static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setAnalyticsData({required String screenName,
      String eventTitle = "",
      Map<String, dynamic>? additionalData}) async {
    // await _analytics.setAnalyticsCollectionEnabled(true);//! remove firebase analytics package(needed)
    // _analytics.logScreenView(screenName: screenName);  //! remove firebase analytics package(needed)
    if (additionalData != null) {
      // _analytics.logEvent(name: eventTitle, parameters: additionalData);//!Previous
      //!Change
//       _analytics.logEvent(//! remove firebase analytics package(needed)
//   name: eventTitle,
//   parameters: additionalData.map((key, value) => MapEntry(key, value as Object)),
// );
    }
  }
}
