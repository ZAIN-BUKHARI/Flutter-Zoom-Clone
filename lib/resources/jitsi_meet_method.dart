import 'package:jitsi_meet_fix/feature_flag/feature_flag.dart';
import 'package:jitsi_meet_fix/jitsi_meet.dart';

import 'auth_methods.dart';
import 'firebase_methods.dart';

class JitsiMeeting {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  void createNewMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p
      String? name;

      if (username.isEmpty) {
        name = _authMethods.user.displayName;
      } else {
        name = username;
      }
      var options = JitsiMeetingOptions(room: roomName)
        // Required, spaces will be trimmed
        // ..serverURL = "https://someHost.com"
        // ..subject = "Meeting with Gunschu"
        ..userDisplayName = name
        ..userEmail = _authMethods.user.email
        ..userAvatarURL = _authMethods.user.photoURL
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
      _firestoreMethods.addToMeetingHistory(roomName);
      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      print("error: $error");
    }
  }
}
