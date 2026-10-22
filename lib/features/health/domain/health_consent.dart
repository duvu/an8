/// Whether the user agreed to keep health readings on this device (D18).
abstract interface class HealthConsent {
  Future<void> setGiven({required bool given});
}
