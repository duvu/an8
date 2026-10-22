import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the app opens on the splash screen. Tests turn it off so they
/// start on the screen they exercise.
final splashEnabledProvider = Provider<bool>((ref) => true);
