import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'An'**
  String get appTitle;

  /// No description provided for @splashSlogan.
  ///
  /// In vi, this message translates to:
  /// **'Cho người hữu duyên'**
  String get splashSlogan;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get navLibrary;

  /// No description provided for @navProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get navProgress;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @homeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay mình tập nhẹ nhé.'**
  String get homeGreeting;

  /// No description provided for @homeOtherRoutines.
  ///
  /// In vi, this message translates to:
  /// **'Bài khác'**
  String get homeOtherRoutines;

  /// No description provided for @homeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài tập nào được phát hành.'**
  String get homeEmpty;

  /// No description provided for @startAction.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get startAction;

  /// No description provided for @demoBanner.
  ///
  /// In vi, this message translates to:
  /// **'Bản xem trước — chưa phải hướng dẫn tập chính thức.'**
  String get demoBanner;

  /// No description provided for @demoBadge.
  ///
  /// In vi, this message translates to:
  /// **'DEMO CONTENT'**
  String get demoBadge;

  /// No description provided for @minutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String minutes(int minutes);

  /// No description provided for @minutesSeconds.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút {seconds} giây'**
  String minutesSeconds(int minutes, int seconds);

  /// No description provided for @routineMetaLine.
  ///
  /// In vi, this message translates to:
  /// **'{duration} · {intensity} · {position}'**
  String routineMetaLine(String duration, String intensity, String position);

  /// No description provided for @positionSeated.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi'**
  String get positionSeated;

  /// No description provided for @positionStanding.
  ///
  /// In vi, this message translates to:
  /// **'Đứng'**
  String get positionStanding;

  /// No description provided for @positionMixed.
  ///
  /// In vi, this message translates to:
  /// **'Đứng + ngồi'**
  String get positionMixed;

  /// No description provided for @intensityGentle.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ nhàng'**
  String get intensityGentle;

  /// No description provided for @intensityEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get intensityEasy;

  /// No description provided for @intensityModerate.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get intensityModerate;

  /// No description provided for @detailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết bài'**
  String get detailTitle;

  /// No description provided for @detailStepsHeader.
  ///
  /// In vi, this message translates to:
  /// **'{count} động tác'**
  String detailStepsHeader(int count);

  /// No description provided for @detailStepItem.
  ///
  /// In vi, this message translates to:
  /// **'{order}. {title} · {duration}'**
  String detailStepItem(String order, String title, String duration);

  /// No description provided for @detailSafetyHeader.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý an toàn'**
  String get detailSafetyHeader;

  /// No description provided for @stopWarning.
  ///
  /// In vi, this message translates to:
  /// **'Dừng nếu chóng mặt, đau ngực, khó thở hoặc tê/yếu mới xuất hiện hay tăng lên.'**
  String get stopWarning;

  /// No description provided for @detailStartAction.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu bài tập'**
  String get detailStartAction;

  /// No description provided for @needsDownload.
  ///
  /// In vi, this message translates to:
  /// **'Cần tải'**
  String get needsDownload;

  /// No description provided for @needsDownloadExplanation.
  ///
  /// In vi, this message translates to:
  /// **'Bài này chưa tải về máy. Tải trước khi tập khi không có mạng.'**
  String get needsDownloadExplanation;

  /// No description provided for @preflightTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trước khi tập'**
  String get preflightTitle;

  /// No description provided for @preflightSpace.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vị trí đủ rộng, nền không trơn.'**
  String get preflightSpace;

  /// No description provided for @preflightChair.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị ghế chắc chắn hoặc chỗ vịn nếu cần.'**
  String get preflightChair;

  /// No description provided for @preflightComfort.
  ///
  /// In vi, this message translates to:
  /// **'Tập trong phạm vi thoải mái, không cố quá sức.'**
  String get preflightComfort;

  /// No description provided for @preflightConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã đọc, bắt đầu'**
  String get preflightConfirm;

  /// No description provided for @safetyLink.
  ///
  /// In vi, this message translates to:
  /// **'Xem nguyên tắc an toàn'**
  String get safetyLink;

  /// No description provided for @playerStepCounter.
  ///
  /// In vi, this message translates to:
  /// **'Bước {current} / {total}'**
  String playerStepCounter(int current, int total);

  /// No description provided for @playerTotalRemaining.
  ///
  /// In vi, this message translates to:
  /// **'{time} toàn bài'**
  String playerTotalRemaining(String time);

  /// No description provided for @playerPause.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get playerPause;

  /// No description provided for @playerResume.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get playerResume;

  /// No description provided for @playerPrevious.
  ///
  /// In vi, this message translates to:
  /// **'Bước trước'**
  String get playerPrevious;

  /// No description provided for @playerNext.
  ///
  /// In vi, this message translates to:
  /// **'Bước tiếp'**
  String get playerNext;

  /// No description provided for @playerPreparing.
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị…'**
  String get playerPreparing;

  /// No description provided for @playerPaused.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạm dừng.'**
  String get playerPaused;

  /// No description provided for @playerInterrupted.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng vì ứng dụng bị gián đoạn. Bấm Tiếp tục khi sẵn sàng.'**
  String get playerInterrupted;

  /// No description provided for @playerBuffering.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nội dung…'**
  String get playerBuffering;

  /// No description provided for @playerError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được hình hướng dẫn.'**
  String get playerError;

  /// No description provided for @playerSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua bước'**
  String get playerSkip;

  /// No description provided for @playerBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get playerBack;

  /// No description provided for @playerProgressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ bài tập {percent}%'**
  String playerProgressLabel(int percent);

  /// No description provided for @playerDemoMediaNotice.
  ///
  /// In vi, this message translates to:
  /// **'Hình minh họa AI chưa kiểm duyệt'**
  String get playerDemoMediaNotice;

  /// No description provided for @summaryCompletedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài tập'**
  String get summaryCompletedTitle;

  /// No description provided for @summaryEndedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết thúc sớm'**
  String get summaryEndedTitle;

  /// No description provided for @summaryActive.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian tập thực tế: {time}'**
  String summaryActive(String time);

  /// No description provided for @summaryCompletedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn đã dành thời gian vận động nhẹ và thư giãn.'**
  String get summaryCompletedMessage;

  /// No description provided for @summaryEndedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Buổi tập được lưu là chưa hoàn thành. Bạn có thể tập lại khi thấy thoải mái.'**
  String get summaryEndedMessage;

  /// No description provided for @summaryHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get summaryHome;

  /// No description provided for @summaryProgress.
  ///
  /// In vi, this message translates to:
  /// **'Xem tiến độ'**
  String get summaryProgress;

  /// No description provided for @loadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được dữ liệu.'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @notFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy nội dung.'**
  String get notFound;

  /// No description provided for @progressTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get progressTitle;

  /// No description provided for @progressEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có buổi tập nào. Khi bạn tập, lịch sử sẽ hiện ở đây.'**
  String get progressEmpty;

  /// No description provided for @progressTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thời gian tập: {time}'**
  String progressTotal(String time);

  /// No description provided for @progressCounts.
  ///
  /// In vi, this message translates to:
  /// **'{count} buổi · {completed} hoàn thành'**
  String progressCounts(int count, int completed);

  /// No description provided for @statusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get statusCompleted;

  /// No description provided for @statusAbandoned.
  ///
  /// In vi, this message translates to:
  /// **'Dừng sớm'**
  String get statusAbandoned;

  /// No description provided for @statusInterrupted.
  ///
  /// In vi, this message translates to:
  /// **'Bị gián đoạn'**
  String get statusInterrupted;

  /// No description provided for @statusInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang tập'**
  String get statusInProgress;

  /// No description provided for @historyItemSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{date} · {status} · {time}'**
  String historyItemSubtitle(String date, String status, String time);

  /// No description provided for @safetyTitle.
  ///
  /// In vi, this message translates to:
  /// **'An toàn khi tập'**
  String get safetyTitle;

  /// No description provided for @safetyIntro.
  ///
  /// In vi, this message translates to:
  /// **'An là nội dung vận động nhẹ để thư giãn, không thay thế tư vấn, chẩn đoán hay điều trị y tế.'**
  String get safetyIntro;

  /// No description provided for @safetyRuleSpace.
  ///
  /// In vi, this message translates to:
  /// **'Tập trong không gian an toàn, nền không trơn; dùng ghế chắc hoặc chỗ vịn khi cần.'**
  String get safetyRuleSpace;

  /// No description provided for @safetyRuleGentle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển động chậm, trong phạm vi thoải mái; không nín thở, không cố quá sức.'**
  String get safetyRuleGentle;

  /// No description provided for @safetyRuleNeck.
  ///
  /// In vi, this message translates to:
  /// **'Không ấn sâu hay xoa bóp mạnh vùng cổ trước hoặc dưới góc hàm.'**
  String get safetyRuleNeck;

  /// No description provided for @safetyEmergency.
  ///
  /// In vi, this message translates to:
  /// **'Nếu triệu chứng nặng hoặc kéo dài, hãy gọi cấp cứu 115 hoặc đến cơ sở y tế gần nhất.'**
  String get safetyEmergency;

  /// No description provided for @safetyBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get safetyBack;

  /// No description provided for @libraryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get libraryTitle;

  /// No description provided for @librarySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bài hoặc động tác'**
  String get librarySearchHint;

  /// No description provided for @libraryFilterGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get libraryFilterGoal;

  /// No description provided for @libraryFilterPosition.
  ///
  /// In vi, this message translates to:
  /// **'Tư thế'**
  String get libraryFilterPosition;

  /// No description provided for @libraryFilterDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng'**
  String get libraryFilterDuration;

  /// No description provided for @libraryFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get libraryFilterAll;

  /// No description provided for @libraryOfflineOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ bài có sẵn trên máy'**
  String get libraryOfflineOnly;

  /// No description provided for @libraryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài phù hợp với bộ lọc.'**
  String get libraryEmpty;

  /// No description provided for @libraryClearFilters.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get libraryClearFilters;

  /// No description provided for @libraryResultCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài'**
  String libraryResultCount(int count);

  /// No description provided for @durationShort.
  ///
  /// In vi, this message translates to:
  /// **'Đến 6 phút'**
  String get durationShort;

  /// No description provided for @durationMedium.
  ///
  /// In vi, this message translates to:
  /// **'7–10 phút'**
  String get durationMedium;

  /// No description provided for @durationLong.
  ///
  /// In vi, this message translates to:
  /// **'Trên 10 phút'**
  String get durationLong;

  /// No description provided for @availableOffline.
  ///
  /// In vi, this message translates to:
  /// **'Có sẵn trên máy'**
  String get availableOffline;

  /// No description provided for @tagStarter.
  ///
  /// In vi, this message translates to:
  /// **'Mới bắt đầu'**
  String get tagStarter;

  /// No description provided for @tagMorning.
  ///
  /// In vi, this message translates to:
  /// **'Buổi sáng'**
  String get tagMorning;

  /// No description provided for @tagEvening.
  ///
  /// In vi, this message translates to:
  /// **'Buổi tối'**
  String get tagEvening;

  /// No description provided for @tagNeckShoulder.
  ///
  /// In vi, this message translates to:
  /// **'Cổ vai'**
  String get tagNeckShoulder;

  /// No description provided for @tagSeated.
  ///
  /// In vi, this message translates to:
  /// **'Trên ghế'**
  String get tagSeated;

  /// No description provided for @tagGentle.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ nhàng'**
  String get tagGentle;

  /// No description provided for @onboardingValueTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dưỡng sinh nhẹ nhàng mỗi ngày'**
  String get onboardingValueTitle;

  /// No description provided for @onboardingValueBody.
  ///
  /// In vi, this message translates to:
  /// **'Các bài vận động ngắn, chậm, có thể tập trên ghế. Không cần tài khoản, không hỏi thông tin sức khỏe.'**
  String get onboardingValueBody;

  /// No description provided for @onboardingSafetyNotice.
  ///
  /// In vi, this message translates to:
  /// **'An là nội dung thư giãn, không thay thế tư vấn hay điều trị y tế. Hãy dừng khi thấy khó chịu.'**
  String get onboardingSafetyNotice;

  /// No description provided for @onboardingContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get onboardingContinue;

  /// No description provided for @onboardingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkip;

  /// No description provided for @onboardingPrefsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn tập thế nào? (không bắt buộc)'**
  String get onboardingPrefsTitle;

  /// No description provided for @onboardingGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get onboardingGoal;

  /// No description provided for @onboardingPosition.
  ///
  /// In vi, this message translates to:
  /// **'Tư thế'**
  String get onboardingPosition;

  /// No description provided for @onboardingPositionAny.
  ///
  /// In vi, this message translates to:
  /// **'Cả hai'**
  String get onboardingPositionAny;

  /// No description provided for @onboardingDone.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá bài tập'**
  String get onboardingDone;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @settingsPracticeSection.
  ///
  /// In vi, this message translates to:
  /// **'Khi tập'**
  String get settingsPracticeSection;

  /// No description provided for @settingsCaptions.
  ///
  /// In vi, this message translates to:
  /// **'Hiện lời hướng dẫn'**
  String get settingsCaptions;

  /// No description provided for @settingsCaptionsHint.
  ///
  /// In vi, this message translates to:
  /// **'Câu hướng dẫn hiển thị dưới hình.'**
  String get settingsCaptionsHint;

  /// No description provided for @settingsReducedMotion.
  ///
  /// In vi, this message translates to:
  /// **'Giảm chuyển động'**
  String get settingsReducedMotion;

  /// No description provided for @settingsReducedMotionHint.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển hình không hiệu ứng. Nội dung hướng dẫn vẫn giữ nguyên.'**
  String get settingsReducedMotionHint;

  /// No description provided for @settingsReminderSection.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get settingsReminderSection;

  /// No description provided for @settingsReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc tập mỗi ngày'**
  String get settingsReminder;

  /// No description provided for @settingsReminderTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc: {time}'**
  String settingsReminderTime(String time);

  /// No description provided for @settingsReminderChangeTime.
  ///
  /// In vi, this message translates to:
  /// **'Đổi giờ'**
  String get settingsReminderChangeTime;

  /// No description provided for @settingsReminderDenied.
  ///
  /// In vi, this message translates to:
  /// **'Chưa được cấp quyền thông báo. Bạn có thể bật trong Cài đặt của điện thoại.'**
  String get settingsReminderDenied;

  /// No description provided for @settingsReminderError.
  ///
  /// In vi, this message translates to:
  /// **'Không đặt được nhắc nhở. Vui lòng thử lại.'**
  String get settingsReminderError;

  /// No description provided for @reminderTitle.
  ///
  /// In vi, this message translates to:
  /// **'An'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ vận động nhẹ rồi. Tập khi bạn thấy thoải mái nhé.'**
  String get reminderBody;

  /// No description provided for @settingsBreakSection.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đứng dậy'**
  String get settingsBreakSection;

  /// No description provided for @settingsBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đứng dậy vận động'**
  String get settingsBreak;

  /// No description provided for @settingsBreakHint.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi lâu cả ngày không tốt cho sức khỏe. An nhắc bạn đứng lên, đi lại và uống nước.'**
  String get settingsBreakHint;

  /// No description provided for @settingsBreakInterval.
  ///
  /// In vi, this message translates to:
  /// **'Cách nhau'**
  String get settingsBreakInterval;

  /// No description provided for @settingsBreakIntervalOption.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String settingsBreakIntervalOption(int minutes);

  /// No description provided for @settingsBreakFrom.
  ///
  /// In vi, this message translates to:
  /// **'Từ: {time}'**
  String settingsBreakFrom(String time);

  /// No description provided for @settingsBreakTo.
  ///
  /// In vi, this message translates to:
  /// **'Đến: {time}'**
  String settingsBreakTo(String time);

  /// No description provided for @settingsBreakAlertLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kiểu nhắc'**
  String get settingsBreakAlertLabel;

  /// No description provided for @settingsBreakAlertSilent.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ thông báo'**
  String get settingsBreakAlertSilent;

  /// No description provided for @settingsBreakAlertVibrate.
  ///
  /// In vi, this message translates to:
  /// **'Rung'**
  String get settingsBreakAlertVibrate;

  /// No description provided for @settingsBreakAlertSound.
  ///
  /// In vi, this message translates to:
  /// **'Chuông'**
  String get settingsBreakAlertSound;

  /// No description provided for @settingsBreakAlertIosNote.
  ///
  /// In vi, this message translates to:
  /// **'Trên iPhone, kiểu \"Rung\" hoạt động như \"Chỉ thông báo\"; hãy dùng \"Chuông\" nếu cần nghe thấy.'**
  String get settingsBreakAlertIosNote;

  /// No description provided for @settingsBreakInvalidWindow.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng giờ quá ngắn so với khoảng cách giữa hai lần nhắc. Hãy kéo dài giờ kết thúc hoặc chọn khoảng cách ngắn hơn.'**
  String get settingsBreakInvalidWindow;

  /// No description provided for @breakReminderBody1.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã ngồi một lúc rồi. Đứng dậy, đi lại vài phút nhé.'**
  String get breakReminderBody1;

  /// No description provided for @breakReminderBody2.
  ///
  /// In vi, this message translates to:
  /// **'Đứng lên vươn vai, xoay cổ nhẹ nhàng và uống một ngụm nước.'**
  String get breakReminderBody2;

  /// No description provided for @breakReminderBody3.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ mắt một chút: nhìn xa 20 giây, rồi đứng dậy vận động nhẹ.'**
  String get breakReminderBody3;

  /// No description provided for @settingsMoreSection.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get settingsMoreSection;

  /// No description provided for @settingsSafety.
  ///
  /// In vi, this message translates to:
  /// **'An toàn khi tập'**
  String get settingsSafety;

  /// No description provided for @settingsDownloads.
  ///
  /// In vi, this message translates to:
  /// **'Bài đã tải'**
  String get settingsDownloads;

  /// No description provided for @settingsPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu tập, số đo sức khỏe và cài đặt chỉ lưu trên máy này: không gửi đi đâu, không sao lưu lên đám mây, không cần tài khoản.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsTextSizeHint.
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ theo cài đặt của điện thoại.'**
  String get settingsTextSizeHint;

  /// No description provided for @downloadsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài đã tải'**
  String get downloadsTitle;

  /// No description provided for @downloadsReady.
  ///
  /// In vi, this message translates to:
  /// **'Có sẵn trên máy'**
  String get downloadsReady;

  /// No description provided for @downloadsMissing.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có trên máy'**
  String get downloadsMissing;

  /// No description provided for @downloadsSize.
  ///
  /// In vi, this message translates to:
  /// **'{megabytes} MB'**
  String downloadsSize(String megabytes);

  /// No description provided for @downloadsNote.
  ///
  /// In vi, this message translates to:
  /// **'Các bài xem trước hiện đi kèm ứng dụng nên tập được khi không có mạng. Tải bài mới qua mạng sẽ có khi nội dung chính thức được phát hành.'**
  String get downloadsNote;

  /// No description provided for @distanceNextUp.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo: {title}'**
  String distanceNextUp(String title);

  /// No description provided for @distanceEndingLast.
  ///
  /// In vi, this message translates to:
  /// **'Sắp kết thúc bài'**
  String get distanceEndingLast;

  /// No description provided for @distanceRemaining.
  ///
  /// In vi, this message translates to:
  /// **'còn lại'**
  String get distanceRemaining;

  /// No description provided for @distanceTimerLabel.
  ///
  /// In vi, this message translates to:
  /// **'{title}, còn lại {time}'**
  String distanceTimerLabel(String title, String time);

  /// No description provided for @distanceEndingNext.
  ///
  /// In vi, this message translates to:
  /// **'Sắp đổi sang: {title}'**
  String distanceEndingNext(String title);

  /// No description provided for @easternTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dưỡng sinh phương Đông'**
  String get easternTitle;

  /// No description provided for @easternEntrySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{count} hệ truyền thống · {playable} hệ đã có bài tập'**
  String easternEntrySubtitle(int count, int playable);

  /// No description provided for @easternIntro.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu các hệ dưỡng sinh truyền thống. Hệ nào đủ ảnh từng bước thì tập được ngay; các hệ khác sẽ được bổ sung dần sau khi kiểm duyệt kỹ thuật và hình ảnh.'**
  String get easternIntro;

  /// No description provided for @easternPreparing.
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị – chưa có bài tập'**
  String get easternPreparing;

  /// No description provided for @easternResearch.
  ///
  /// In vi, this message translates to:
  /// **'Đang nghiên cứu nguồn'**
  String get easternResearch;

  /// No description provided for @easternFormCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} thức'**
  String easternFormCount(int count);

  /// No description provided for @easternCoverLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bìa minh họa {title}, không thể hiện tư thế tập'**
  String easternCoverLabel(String title);

  /// No description provided for @easternCoverNotice.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bìa minh họa, không phải hướng dẫn tư thế.'**
  String get easternCoverNotice;

  /// No description provided for @easternFormsHeader.
  ///
  /// In vi, this message translates to:
  /// **'Các thức'**
  String get easternFormsHeader;

  /// No description provided for @easternFormItem.
  ///
  /// In vi, this message translates to:
  /// **'{number}. {title}'**
  String easternFormItem(int number, String title);

  /// No description provided for @easternNotesHeader.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get easternNotesHeader;

  /// No description provided for @easternRequiredHeader.
  ///
  /// In vi, this message translates to:
  /// **'Cần làm trước khi biên soạn'**
  String get easternRequiredHeader;

  /// No description provided for @easternSourcesHeader.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn tham khảo'**
  String get easternSourcesHeader;

  /// No description provided for @easternLevelGentleToModerate.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ đến vừa'**
  String get easternLevelGentleToModerate;

  /// No description provided for @easternLevelModerate.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get easternLevelModerate;

  /// No description provided for @settingsSoundCues.
  ///
  /// In vi, this message translates to:
  /// **'Âm báo khi tập'**
  String get settingsSoundCues;

  /// No description provided for @settingsSoundCuesHint.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng chuông nhẹ khi đếm ngược, khi đổi động tác, báo trước 10 giây và khi hoàn thành.'**
  String get settingsSoundCuesHint;

  /// No description provided for @easternFormIllustrationNotice.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh minh họa chưa được đối chiếu kỹ thuật. Không tập theo ảnh này; bài tập có hướng dẫn sẽ được bổ sung sau khi chuyên gia duyệt.'**
  String get easternFormIllustrationNotice;

  /// No description provided for @easternFormIllustrationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh minh họa thức {title}, chưa đối chiếu kỹ thuật'**
  String easternFormIllustrationLabel(String title);

  /// No description provided for @tagBaduanjin.
  ///
  /// In vi, this message translates to:
  /// **'Bát Đoạn Cẩm'**
  String get tagBaduanjin;

  /// No description provided for @tagEasternQigong.
  ///
  /// In vi, this message translates to:
  /// **'Khí công phương Đông'**
  String get tagEasternQigong;

  /// No description provided for @easternPlayable.
  ///
  /// In vi, this message translates to:
  /// **'Đã có bài tập'**
  String get easternPlayable;

  /// No description provided for @easternPracticeAction.
  ///
  /// In vi, this message translates to:
  /// **'Tập bài {title}'**
  String easternPracticeAction(String title);

  /// No description provided for @easternStepsHeader.
  ///
  /// In vi, this message translates to:
  /// **'Các bước'**
  String get easternStepsHeader;

  /// No description provided for @easternOverviewHeader.
  ///
  /// In vi, this message translates to:
  /// **'Bảng tổng quan các thức'**
  String get easternOverviewHeader;

  /// No description provided for @easternOverviewNotice.
  ///
  /// In vi, this message translates to:
  /// **'Tranh minh họa để làm quen tên và dáng các thức. Chưa được đối chiếu kỹ thuật, không tập theo tranh này.'**
  String get easternOverviewNotice;

  /// No description provided for @easternOverviewOpen.
  ///
  /// In vi, this message translates to:
  /// **'Chạm để xem lớn, có thể phóng to'**
  String get easternOverviewOpen;

  /// No description provided for @easternOverviewLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bảng tổng quan {system}, {title}'**
  String easternOverviewLabel(String system, String title);

  /// No description provided for @pauseTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạm dừng'**
  String get pauseTitle;

  /// No description provided for @pauseMessage.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ một chút nếu cần. Nếu dừng hẳn, thời gian đã tập được lưu là chưa hoàn thành.'**
  String get pauseMessage;

  /// No description provided for @pauseResume.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get pauseResume;

  /// No description provided for @pauseStop.
  ///
  /// In vi, this message translates to:
  /// **'Dừng hẳn'**
  String get pauseStop;

  /// No description provided for @settingsBackgroundMusic.
  ///
  /// In vi, this message translates to:
  /// **'Nhạc nền khi tập'**
  String get settingsBackgroundMusic;

  /// No description provided for @settingsBackgroundMusicHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhạc nhẹ không lời, tự dừng khi bạn tạm dừng.'**
  String get settingsBackgroundMusicHint;

  /// No description provided for @learnHeader.
  ///
  /// In vi, this message translates to:
  /// **'Tìm hiểu'**
  String get learnHeader;

  /// No description provided for @learnMeaning.
  ///
  /// In vi, this message translates to:
  /// **'Ý nghĩa'**
  String get learnMeaning;

  /// No description provided for @learnAwareness.
  ///
  /// In vi, this message translates to:
  /// **'Khi tập, hãy để ý'**
  String get learnAwareness;

  /// No description provided for @learnNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get learnNote;

  /// No description provided for @learnSystemHeader.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử và văn hóa'**
  String get learnSystemHeader;

  /// No description provided for @learnHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get learnHistory;

  /// No description provided for @learnContext.
  ///
  /// In vi, this message translates to:
  /// **'Bối cảnh văn hóa'**
  String get learnContext;

  /// No description provided for @learnSpirit.
  ///
  /// In vi, this message translates to:
  /// **'Tinh thần của bài'**
  String get learnSpirit;

  /// No description provided for @learnReadingCautions.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý khi đọc'**
  String get learnReadingCautions;

  /// No description provided for @learnSources.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn tham khảo'**
  String get learnSources;

  /// No description provided for @learnDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung tìm hiểu do An biên tập, chưa được chuyên gia thẩm định. Đây không phải hướng dẫn kỹ thuật hay lời khuyên y tế.'**
  String get learnDisclaimer;

  /// No description provided for @learnStoriesHeader.
  ///
  /// In vi, this message translates to:
  /// **'Chuyện kể'**
  String get learnStoriesHeader;

  /// No description provided for @learnOpenAction.
  ///
  /// In vi, this message translates to:
  /// **'Tìm hiểu {title}'**
  String learnOpenAction(String title);

  /// No description provided for @navHealth.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe'**
  String get navHealth;

  /// No description provided for @healthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe'**
  String get healthTitle;

  /// No description provided for @healthConsentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi chỉ số sức khỏe'**
  String get healthConsentTitle;

  /// No description provided for @healthConsentIntro.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại các số đo hằng ngày để bạn và bác sĩ dễ theo dõi theo thời gian.'**
  String get healthConsentIntro;

  /// No description provided for @healthConsentManual.
  ///
  /// In vi, this message translates to:
  /// **'Bạn tự nhập số đo: cân nặng, chiều cao, huyết áp, nhịp tim, đường huyết, SpO2, nhiệt độ, vòng eo.'**
  String get healthConsentManual;

  /// No description provided for @healthConsentLocal.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu chỉ lưu trên điện thoại này. App không gửi đi đâu và không sao lưu lên đám mây.'**
  String get healthConsentLocal;

  /// No description provided for @healthConsentDelete.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể xóa toàn bộ dữ liệu sức khỏe bất cứ lúc nào trong Cài đặt.'**
  String get healthConsentDelete;

  /// No description provided for @healthConsentNoDiagnosis.
  ///
  /// In vi, this message translates to:
  /// **'App không chẩn đoán bệnh. Khoảng tham khảo chỉ giúp bạn biết khi nào nên hỏi bác sĩ.'**
  String get healthConsentNoDiagnosis;

  /// No description provided for @healthConsentAccept.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý và bắt đầu'**
  String get healthConsentAccept;

  /// No description provided for @healthAddAction.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chỉ số'**
  String get healthAddAction;

  /// No description provided for @healthNoReading.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có số đo'**
  String get healthNoReading;

  /// No description provided for @healthDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Đây là sổ theo dõi cá nhân, không thay thế khám bệnh. Hãy mang số đo khi đi khám và làm theo hướng dẫn của bác sĩ.'**
  String get healthDisclaimer;

  /// No description provided for @metricWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng'**
  String get metricWeight;

  /// No description provided for @metricHeight.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao'**
  String get metricHeight;

  /// No description provided for @metricBloodPressure.
  ///
  /// In vi, this message translates to:
  /// **'Huyết áp'**
  String get metricBloodPressure;

  /// No description provided for @metricHeartRate.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp tim'**
  String get metricHeartRate;

  /// No description provided for @metricBloodGlucose.
  ///
  /// In vi, this message translates to:
  /// **'Đường huyết'**
  String get metricBloodGlucose;

  /// No description provided for @metricOxygenSaturation.
  ///
  /// In vi, this message translates to:
  /// **'SpO2 (ô-xy trong máu)'**
  String get metricOxygenSaturation;

  /// No description provided for @metricTemperature.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệt độ cơ thể'**
  String get metricTemperature;

  /// No description provided for @metricWaist.
  ///
  /// In vi, this message translates to:
  /// **'Vòng eo'**
  String get metricWaist;

  /// No description provided for @unitKg.
  ///
  /// In vi, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitCm.
  ///
  /// In vi, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitMmHg.
  ///
  /// In vi, this message translates to:
  /// **'mmHg'**
  String get unitMmHg;

  /// No description provided for @unitBpm.
  ///
  /// In vi, this message translates to:
  /// **'lần/phút'**
  String get unitBpm;

  /// No description provided for @unitMmolL.
  ///
  /// In vi, this message translates to:
  /// **'mmol/L'**
  String get unitMmolL;

  /// No description provided for @unitMgDl.
  ///
  /// In vi, this message translates to:
  /// **'mg/dL'**
  String get unitMgDl;

  /// No description provided for @unitPercent.
  ///
  /// In vi, this message translates to:
  /// **'%'**
  String get unitPercent;

  /// No description provided for @unitCelsius.
  ///
  /// In vi, this message translates to:
  /// **'°C'**
  String get unitCelsius;

  /// No description provided for @bmiTitle.
  ///
  /// In vi, this message translates to:
  /// **'BMI'**
  String get bmiTitle;

  /// No description provided for @bmiUnder.
  ///
  /// In vi, this message translates to:
  /// **'Thấp hơn mức tham khảo'**
  String get bmiUnder;

  /// No description provided for @bmiNormal.
  ///
  /// In vi, this message translates to:
  /// **'Trong mức tham khảo'**
  String get bmiNormal;

  /// No description provided for @bmiOver.
  ///
  /// In vi, this message translates to:
  /// **'Thừa cân (mức tham khảo người châu Á)'**
  String get bmiOver;

  /// No description provided for @bmiObese.
  ///
  /// In vi, this message translates to:
  /// **'Béo phì (mức tham khảo người châu Á)'**
  String get bmiObese;

  /// No description provided for @bmiNeedsBoth.
  ///
  /// In vi, this message translates to:
  /// **'Ghi cân nặng và chiều cao để tính BMI.'**
  String get bmiNeedsBoth;

  /// No description provided for @bmiNote.
  ///
  /// In vi, this message translates to:
  /// **'Tính từ cân nặng và chiều cao gần nhất. Ở người cao tuổi, BMI chỉ là số tham khảo.'**
  String get bmiNote;

  /// No description provided for @bmiNeedsWeight.
  ///
  /// In vi, this message translates to:
  /// **'Ghi cân nặng để tính BMI.'**
  String get bmiNeedsWeight;

  /// No description provided for @bmiWeightRange.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng tham khảo với chiều cao {height} cm: {min}–{max} kg'**
  String bmiWeightRange(String height, String min, String max);

  /// No description provided for @bmiWeightInRange.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng hiện tại nằm trong khoảng này.'**
  String get bmiWeightInRange;

  /// No description provided for @bmiWeightAbove.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng hiện tại nhiều hơn mức trên {kg} kg.'**
  String bmiWeightAbove(String kg);

  /// No description provided for @bmiWeightBelow.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng hiện tại ít hơn mức dưới {kg} kg.'**
  String bmiWeightBelow(String kg);

  /// No description provided for @bmiWeightAdvice.
  ///
  /// In vi, this message translates to:
  /// **'Ở người cao tuổi, đừng tự ăn kiêng hay ép tăng cân; hãy hỏi bác sĩ trước khi đặt mục tiêu cân nặng.'**
  String get bmiWeightAdvice;

  /// No description provided for @weightLossNotice.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng giảm từ 5% trở lên trong 6 tháng. Nếu bạn không chủ ý giảm cân, hãy trao đổi với bác sĩ.'**
  String get weightLossNotice;

  /// No description provided for @statusInRange.
  ///
  /// In vi, this message translates to:
  /// **'Trong khoảng tham khảo'**
  String get statusInRange;

  /// No description provided for @statusOutside.
  ///
  /// In vi, this message translates to:
  /// **'Ngoài khoảng tham khảo'**
  String get statusOutside;

  /// No description provided for @statusUrgent.
  ///
  /// In vi, this message translates to:
  /// **'Cần chú ý ngay'**
  String get statusUrgent;

  /// No description provided for @reasonPressureHigh.
  ///
  /// In vi, this message translates to:
  /// **'Huyết áp đo tại nhà từ 135/85 mmHg trở lên. Đo lại sau khi ngồi nghỉ 5 phút; nếu nhiều lần vẫn cao, hãy hỏi bác sĩ.'**
  String get reasonPressureHigh;

  /// No description provided for @reasonPressureLow.
  ///
  /// In vi, this message translates to:
  /// **'Huyết áp thấp hơn 90/60 mmHg. Nếu thấy chóng mặt, mệt, hãy ngồi hoặc nằm nghỉ và hỏi bác sĩ.'**
  String get reasonPressureLow;

  /// No description provided for @reasonPressureVeryHigh.
  ///
  /// In vi, this message translates to:
  /// **'Huyết áp rất cao (từ 180/120 mmHg). Nếu kèm đau ngực, khó thở, đau đầu dữ dội, yếu hoặc tê tay chân, nói khó: gọi 115 ngay. Nếu không có các dấu hiệu đó, ngồi nghỉ 5 phút rồi đo lại và liên hệ bác sĩ sớm.'**
  String get reasonPressureVeryHigh;

  /// No description provided for @reasonPulseHigh.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp tim lúc nghỉ trên 100 lần/phút. Ngồi nghỉ rồi đo lại; nếu vẫn cao hoặc thấy hồi hộp, khó thở, hãy hỏi bác sĩ.'**
  String get reasonPulseHigh;

  /// No description provided for @reasonPulseLow.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp tim lúc nghỉ dưới 60 lần/phút. Điều này có thể bình thường ở một số người; nếu kèm chóng mặt, mệt lả, hãy hỏi bác sĩ.'**
  String get reasonPulseLow;

  /// No description provided for @reasonGlucoseHigh.
  ///
  /// In vi, this message translates to:
  /// **'Đường huyết cao hơn khoảng tham khảo cho thời điểm đo. Hãy ghi lại và trao đổi với bác sĩ.'**
  String get reasonGlucoseHigh;

  /// No description provided for @reasonGlucoseLow.
  ///
  /// In vi, this message translates to:
  /// **'Đường huyết thấp (dưới 3,9 mmol/L). Nếu run, vã mồ hôi, lú lẫn: xử trí ngay theo hướng dẫn bác sĩ đã dặn hoặc gọi 115.'**
  String get reasonGlucoseLow;

  /// No description provided for @reasonGlucoseVeryHigh.
  ///
  /// In vi, this message translates to:
  /// **'Đường huyết rất cao (từ 16,7 mmol/L). Liên hệ bác sĩ ngay; nếu lơ mơ, khó thở, nôn nhiều: gọi 115.'**
  String get reasonGlucoseVeryHigh;

  /// No description provided for @reasonOxygenLow.
  ///
  /// In vi, this message translates to:
  /// **'SpO2 dưới 95%. Ngồi thẳng, nghỉ rồi đo lại; nếu vẫn thấp, hãy hỏi bác sĩ.'**
  String get reasonOxygenLow;

  /// No description provided for @reasonOxygenVeryLow.
  ///
  /// In vi, this message translates to:
  /// **'SpO2 từ 92% trở xuống. Nếu khó thở, môi tím, lú lẫn: gọi 115 ngay. Nếu không, đo lại và liên hệ bác sĩ ngay.'**
  String get reasonOxygenVeryLow;

  /// No description provided for @reasonFever.
  ///
  /// In vi, this message translates to:
  /// **'Sốt (từ 37,5 °C). Uống đủ nước, nghỉ ngơi và theo dõi; hỏi bác sĩ nếu sốt kéo dài hoặc kèm dấu hiệu khác.'**
  String get reasonFever;

  /// No description provided for @reasonHighFever.
  ///
  /// In vi, this message translates to:
  /// **'Sốt cao (từ 39,5 °C). Liên hệ bác sĩ ngay; nếu lú lẫn, co giật, khó thở: gọi 115.'**
  String get reasonHighFever;

  /// No description provided for @reasonTemperatureLow.
  ///
  /// In vi, this message translates to:
  /// **'Thân nhiệt thấp (dưới 35,5 °C). Đo lại, giữ ấm; nếu vẫn thấp hoặc lơ mơ, hãy liên hệ bác sĩ.'**
  String get reasonTemperatureLow;

  /// No description provided for @referencePressure.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tham khảo đo tại nhà: dưới 135/85 mmHg (ESC/ESH 2018, Hội Tim mạch Việt Nam 2018).'**
  String get referencePressure;

  /// No description provided for @referenceHeartRate.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tham khảo lúc nghỉ: 60–100 lần/phút.'**
  String get referenceHeartRate;

  /// No description provided for @referenceGlucose.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tham khảo: lúc đói dưới 7,0 mmol/L; sau ăn 2 giờ hoặc bất kỳ dưới 11,1 mmol/L (ADA). Người đang điều trị có thể có mục tiêu riêng do bác sĩ đặt.'**
  String get referenceGlucose;

  /// No description provided for @referenceOxygen.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tham khảo: từ 95% trở lên.'**
  String get referenceOxygen;

  /// No description provided for @referenceTemperature.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tham khảo: 35,5–37,4 °C.'**
  String get referenceTemperature;

  /// No description provided for @referenceWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân vào cùng giờ, cùng trang phục để dễ so sánh. Giảm cân ngoài ý muốn là dấu hiệu cần hỏi bác sĩ.'**
  String get referenceWeight;

  /// No description provided for @referenceHeight.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao dùng để tính BMI; ở người cao tuổi nên đo lại vài lần mỗi năm.'**
  String get referenceHeight;

  /// No description provided for @referenceWaist.
  ///
  /// In vi, this message translates to:
  /// **'Đo ngang rốn, cuối thì thở ra nhẹ.'**
  String get referenceWaist;

  /// No description provided for @referenceSource.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu điều trị của bạn có thể khác; hãy theo hướng dẫn của bác sĩ.'**
  String get referenceSource;

  /// No description provided for @timingFasting.
  ///
  /// In vi, this message translates to:
  /// **'Lúc đói'**
  String get timingFasting;

  /// No description provided for @timingAfterMeal.
  ///
  /// In vi, this message translates to:
  /// **'Sau ăn 2 giờ'**
  String get timingAfterMeal;

  /// No description provided for @timingRandom.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ'**
  String get timingRandom;

  /// No description provided for @healthMetricField.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số'**
  String get healthMetricField;

  /// No description provided for @healthValueField.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị ({unit})'**
  String healthValueField(String unit);

  /// No description provided for @healthTimingField.
  ///
  /// In vi, this message translates to:
  /// **'Thời điểm đo'**
  String get healthTimingField;

  /// No description provided for @healthUnitField.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị'**
  String get healthUnitField;

  /// No description provided for @healthMeasuredAt.
  ///
  /// In vi, this message translates to:
  /// **'Đo lúc {date} {time}'**
  String healthMeasuredAt(String date, String time);

  /// No description provided for @healthChangeDate.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ngày'**
  String get healthChangeDate;

  /// No description provided for @healthChangeTime.
  ///
  /// In vi, this message translates to:
  /// **'Đổi giờ'**
  String get healthChangeTime;

  /// No description provided for @healthNoteField.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú (không bắt buộc)'**
  String get healthNoteField;

  /// No description provided for @healthSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get healthSave;

  /// No description provided for @healthSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu số đo.'**
  String get healthSaved;

  /// No description provided for @healthErrorRange.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị có vẻ chưa đúng. Hãy nhập trong khoảng {min}–{max}.'**
  String healthErrorRange(String min, String max);

  /// No description provided for @healthErrorPressureOrder.
  ///
  /// In vi, this message translates to:
  /// **'Số trên (tâm thu) phải lớn hơn số dưới (tâm trương).'**
  String get healthErrorPressureOrder;

  /// No description provided for @healthErrorTiming.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thời điểm đo đường huyết.'**
  String get healthErrorTiming;

  /// No description provided for @healthUrgentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cần chú ý'**
  String get healthUrgentTitle;

  /// No description provided for @healthUrgentOk.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã hiểu'**
  String get healthUrgentOk;

  /// No description provided for @healthHistoryHeader.
  ///
  /// In vi, this message translates to:
  /// **'Các lần đo'**
  String get healthHistoryHeader;

  /// No description provided for @healthChartLabel.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ {metric}: {count} lần đo, gần nhất {latest}'**
  String healthChartLabel(String metric, int count, String latest);

  /// No description provided for @healthDeleteReading.
  ///
  /// In vi, this message translates to:
  /// **'Xóa số đo'**
  String get healthDeleteReading;

  /// No description provided for @healthDeleteReadingConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa số đo này?'**
  String get healthDeleteReadingConfirm;

  /// No description provided for @healthDeleteConfirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get healthDeleteConfirmAction;

  /// No description provided for @healthCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get healthCancel;

  /// No description provided for @settingsHealthSection.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu sức khỏe'**
  String get settingsHealthSection;

  /// No description provided for @settingsHealthDeleteAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ dữ liệu sức khỏe'**
  String get settingsHealthDeleteAll;

  /// No description provided for @settingsHealthDeleteAllHint.
  ///
  /// In vi, this message translates to:
  /// **'Xóa mọi số đo trên máy và tắt theo dõi. Không thể hoàn tác.'**
  String get settingsHealthDeleteAllHint;

  /// No description provided for @settingsHealthDeleteAllConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ số đo sức khỏe trên điện thoại này? Không thể hoàn tác.'**
  String get settingsHealthDeleteAllConfirm;

  /// No description provided for @settingsHealthDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa toàn bộ dữ liệu sức khỏe.'**
  String get settingsHealthDeleted;

  /// No description provided for @healthErrorFuture.
  ///
  /// In vi, this message translates to:
  /// **'Thời điểm đo không thể ở tương lai.'**
  String get healthErrorFuture;

  /// No description provided for @healthPressureField.
  ///
  /// In vi, this message translates to:
  /// **'Huyết áp (mmHg) và nhịp tim'**
  String get healthPressureField;

  /// No description provided for @healthSystolicField.
  ///
  /// In vi, this message translates to:
  /// **'Tâm thu'**
  String get healthSystolicField;

  /// No description provided for @healthDiastolicField.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trương'**
  String get healthDiastolicField;

  /// No description provided for @healthPulseField.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp tim'**
  String get healthPulseField;

  /// No description provided for @healthPressureHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ lần lượt 3 số trên máy đo, ô tự chuyển khi đủ số. Nhịp tim có thể bỏ trống.'**
  String get healthPressureHint;

  /// No description provided for @healthPressureFormat.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nhập cả số tâm thu và số tâm trương.'**
  String get healthPressureFormat;

  /// No description provided for @healthPulseRange.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp tim có vẻ chưa đúng. Hãy nhập trong khoảng {min}–{max}.'**
  String healthPulseRange(String min, String max);

  /// No description provided for @healthExportAction.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu (CSV, ảnh)'**
  String get healthExportAction;

  /// No description provided for @healthExportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu sức khỏe'**
  String get healthExportTitle;

  /// No description provided for @healthExportIntro.
  ///
  /// In vi, this message translates to:
  /// **'Tạo file để mang đi khám hoặc gửi cho người thân. Sau khi tạo, bạn tự chọn nơi gửi hoặc lưu (Zalo, Gmail, Drive, Tệp…). App không tự gửi đi đâu.'**
  String get healthExportIntro;

  /// No description provided for @healthExportPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'File chứa thông tin sức khỏe của bạn. Chỉ gửi cho người bạn tin tưởng.'**
  String get healthExportPrivacy;

  /// No description provided for @healthExportCsv.
  ///
  /// In vi, this message translates to:
  /// **'Xuất file CSV (mở bằng Excel)'**
  String get healthExportCsv;

  /// No description provided for @healthExportCsvHint.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ số đo, mỗi lần đo một dòng.'**
  String get healthExportCsvHint;

  /// No description provided for @healthExportImage.
  ///
  /// In vi, this message translates to:
  /// **'Xuất ảnh tóm tắt'**
  String get healthExportImage;

  /// No description provided for @healthExportImageHint.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bên dưới: số đo gần nhất và biểu đồ, tiện cho bác sĩ xem nhanh.'**
  String get healthExportImageHint;

  /// No description provided for @healthExportPreview.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước ảnh'**
  String get healthExportPreview;

  /// No description provided for @healthExportEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có số đo nào để xuất.'**
  String get healthExportEmpty;

  /// No description provided for @healthExportFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tạo được file. Hãy thử lại.'**
  String get healthExportFailed;

  /// No description provided for @healthExportSubject.
  ///
  /// In vi, this message translates to:
  /// **'An – số đo sức khỏe'**
  String get healthExportSubject;

  /// No description provided for @healthReportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sổ theo dõi sức khỏe'**
  String get healthReportTitle;

  /// No description provided for @healthReportCreated.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lúc {date} {time}'**
  String healthReportCreated(String date, String time);

  /// No description provided for @healthReportLatest.
  ///
  /// In vi, this message translates to:
  /// **'Số đo gần nhất'**
  String get healthReportLatest;

  /// No description provided for @healthReportTrends.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng'**
  String get healthReportTrends;

  /// No description provided for @csvMeasuredAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giờ đo'**
  String get csvMeasuredAt;

  /// No description provided for @csvMetric.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số'**
  String get csvMetric;

  /// No description provided for @csvValue.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị'**
  String get csvValue;

  /// No description provided for @csvSecondValue.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị 2 (tâm trương)'**
  String get csvSecondValue;

  /// No description provided for @csvUnit.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị'**
  String get csvUnit;

  /// No description provided for @csvGlucoseTiming.
  ///
  /// In vi, this message translates to:
  /// **'Thời điểm đo đường huyết'**
  String get csvGlucoseTiming;

  /// No description provided for @csvNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get csvNote;

  /// No description provided for @calendarTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch vạn niên'**
  String get calendarTitle;

  /// No description provided for @calendarOpen.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch'**
  String get calendarOpen;

  /// No description provided for @calendarToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get calendarToday;

  /// No description provided for @calendarPickDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get calendarPickDate;

  /// No description provided for @calendarPrevMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng trước'**
  String get calendarPrevMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng sau'**
  String get calendarNextMonth;

  /// No description provided for @calendarMonthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month} năm {year}'**
  String calendarMonthTitle(int month, int year);

  /// No description provided for @calendarMonthSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Năm {yearName}'**
  String calendarMonthSubtitle(String yearName);

  /// No description provided for @calendarWeekdayShort1.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get calendarWeekdayShort1;

  /// No description provided for @calendarWeekdayFull1.
  ///
  /// In vi, this message translates to:
  /// **'Thứ hai'**
  String get calendarWeekdayFull1;

  /// No description provided for @calendarWeekdayShort2.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get calendarWeekdayShort2;

  /// No description provided for @calendarWeekdayFull2.
  ///
  /// In vi, this message translates to:
  /// **'Thứ ba'**
  String get calendarWeekdayFull2;

  /// No description provided for @calendarWeekdayShort3.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get calendarWeekdayShort3;

  /// No description provided for @calendarWeekdayFull3.
  ///
  /// In vi, this message translates to:
  /// **'Thứ tư'**
  String get calendarWeekdayFull3;

  /// No description provided for @calendarWeekdayShort4.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get calendarWeekdayShort4;

  /// No description provided for @calendarWeekdayFull4.
  ///
  /// In vi, this message translates to:
  /// **'Thứ năm'**
  String get calendarWeekdayFull4;

  /// No description provided for @calendarWeekdayShort5.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get calendarWeekdayShort5;

  /// No description provided for @calendarWeekdayFull5.
  ///
  /// In vi, this message translates to:
  /// **'Thứ sáu'**
  String get calendarWeekdayFull5;

  /// No description provided for @calendarWeekdayShort6.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get calendarWeekdayShort6;

  /// No description provided for @calendarWeekdayFull6.
  ///
  /// In vi, this message translates to:
  /// **'Thứ bảy'**
  String get calendarWeekdayFull6;

  /// No description provided for @calendarWeekdayShort7.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get calendarWeekdayShort7;

  /// No description provided for @calendarWeekdayFull7.
  ///
  /// In vi, this message translates to:
  /// **'Chủ nhật'**
  String get calendarWeekdayFull7;

  /// No description provided for @calendarCellLabel.
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, ngày {day} tháng {month} năm {year}, âm lịch ngày {lunarDay} tháng {lunarMonth}, {quality}'**
  String calendarCellLabel(
    String weekday,
    int day,
    int month,
    int year,
    int lunarDay,
    int lunarMonth,
    String quality,
  );

  /// No description provided for @calendarLunarMonthStart.
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month}'**
  String calendarLunarMonthStart(int day, int month);

  /// No description provided for @calendarHoangDao.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hoàng đạo'**
  String get calendarHoangDao;

  /// No description provided for @calendarHacDao.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hắc đạo'**
  String get calendarHacDao;

  /// No description provided for @calendarSelectedDate.
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, {day} tháng {month} năm {year}'**
  String calendarSelectedDate(String weekday, int day, int month, int year);

  /// No description provided for @calendarSectionDate.
  ///
  /// In vi, this message translates to:
  /// **'Dương lịch và âm lịch'**
  String get calendarSectionDate;

  /// No description provided for @calendarLunarDate.
  ///
  /// In vi, this message translates to:
  /// **'Âm lịch: ngày {day} tháng {month}{leap} năm {yearName}'**
  String calendarLunarDate(int day, int month, String leap, String yearName);

  /// No description provided for @calendarLeapSuffix.
  ///
  /// In vi, this message translates to:
  /// **' nhuận'**
  String get calendarLeapSuffix;

  /// No description provided for @calendarCanChiLine.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day} · Tháng {month} · Năm {year}'**
  String calendarCanChiLine(String day, String month, String year);

  /// No description provided for @calendarSolarTerm.
  ///
  /// In vi, this message translates to:
  /// **'Tiết khí: {term}'**
  String calendarSolarTerm(String term);

  /// No description provided for @calendarSolarTermStarts.
  ///
  /// In vi, this message translates to:
  /// **'Tiết khí: {term} (bắt đầu hôm nay)'**
  String calendarSolarTermStarts(String term);

  /// No description provided for @calendarFirstDay.
  ///
  /// In vi, this message translates to:
  /// **'Mùng 1 âm lịch'**
  String get calendarFirstDay;

  /// No description provided for @calendarFullMoon.
  ///
  /// In vi, this message translates to:
  /// **'Rằm (15 âm lịch)'**
  String get calendarFullMoon;

  /// No description provided for @calendarSectionQuality.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá ngày'**
  String get calendarSectionQuality;

  /// No description provided for @calendarRatingGood.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tốt'**
  String get calendarRatingGood;

  /// No description provided for @calendarRatingNeutral.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bình thường'**
  String get calendarRatingNeutral;

  /// No description provided for @calendarRatingBad.
  ///
  /// In vi, this message translates to:
  /// **'Ngày xấu'**
  String get calendarRatingBad;

  /// No description provided for @calendarGodLine.
  ///
  /// In vi, this message translates to:
  /// **'{kind} · {god}'**
  String calendarGodLine(String kind, String god);

  /// No description provided for @calendarTruc.
  ///
  /// In vi, this message translates to:
  /// **'Trực {name}: {note}'**
  String calendarTruc(String name, String note);

  /// No description provided for @calendarRatingNote.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá gộp hoàng đạo/hắc đạo và trực của ngày, chỉ để tham khảo.'**
  String get calendarRatingNote;

  /// No description provided for @calendarSectionHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ hoàng đạo'**
  String get calendarSectionHours;

  /// No description provided for @calendarHourLine.
  ///
  /// In vi, this message translates to:
  /// **'Giờ {name} ({start}–{end}) · {god}'**
  String calendarHourLine(String name, String start, String end, String god);

  /// No description provided for @calendarSectionDeparture.
  ///
  /// In vi, this message translates to:
  /// **'Xuất hành'**
  String get calendarSectionDeparture;

  /// No description provided for @calendarDepartureDay.
  ///
  /// In vi, this message translates to:
  /// **'Khổng Minh lục diệu: {name}. {note}'**
  String calendarDepartureDay(String name, String note);

  /// No description provided for @calendarHyThan.
  ///
  /// In vi, this message translates to:
  /// **'Hướng hỷ thần (cầu may): {direction}'**
  String calendarHyThan(String direction);

  /// No description provided for @calendarTaiThan.
  ///
  /// In vi, this message translates to:
  /// **'Hướng tài thần (cầu tài): {direction}'**
  String calendarTaiThan(String direction);

  /// No description provided for @calendarDepartureHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ đẹp để xuất hành'**
  String get calendarDepartureHours;

  /// No description provided for @calendarNoDepartureHours.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay không có giờ hoàng đạo nào hợp xuất hành.'**
  String get calendarNoDepartureHours;

  /// No description provided for @calendarAllHours.
  ///
  /// In vi, this message translates to:
  /// **'Xem đủ 12 giờ'**
  String get calendarAllHours;

  /// No description provided for @calendarHourDetail.
  ///
  /// In vi, this message translates to:
  /// **'Giờ {name} ({start}–{end}): {kind}; xuất hành {cung}'**
  String calendarHourDetail(
    String name,
    String start,
    String end,
    String kind,
    String cung,
  );

  /// No description provided for @calendarHourHoangDao.
  ///
  /// In vi, this message translates to:
  /// **'hoàng đạo'**
  String get calendarHourHoangDao;

  /// No description provided for @calendarHourHacDao.
  ///
  /// In vi, this message translates to:
  /// **'hắc đạo'**
  String get calendarHourHacDao;

  /// No description provided for @calendarDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Lịch vạn niên chỉ mang tính tham khảo theo văn hóa truyền thống và chưa được chuyên gia thẩm định. Hãy cân nhắc theo hoàn cảnh của bạn; không thay thế lời khuyên y tế, pháp lý hay tài chính.'**
  String get calendarDisclaimer;

  /// No description provided for @calendarLegend.
  ///
  /// In vi, this message translates to:
  /// **'● Ngày hoàng đạo   ○ Ngày hắc đạo   Chữ nhỏ: ngày âm lịch'**
  String get calendarLegend;

  /// No description provided for @calendarSectionMansion.
  ///
  /// In vi, this message translates to:
  /// **'Sao nhị thập bát tú'**
  String get calendarSectionMansion;

  /// No description provided for @calendarMansionLine.
  ///
  /// In vi, this message translates to:
  /// **'Sao {name} ({element}, {animal})'**
  String calendarMansionLine(String name, String element, String animal);

  /// No description provided for @calendarMansionKiet.
  ///
  /// In vi, this message translates to:
  /// **'Kiết tú (sao tốt)'**
  String get calendarMansionKiet;

  /// No description provided for @calendarMansionBinh.
  ///
  /// In vi, this message translates to:
  /// **'Bình tú (sao trung bình)'**
  String get calendarMansionBinh;

  /// No description provided for @calendarMansionHung.
  ///
  /// In vi, this message translates to:
  /// **'Hung tú (sao xấu)'**
  String get calendarMansionHung;

  /// No description provided for @calendarMansionFavorable.
  ///
  /// In vi, this message translates to:
  /// **'Nên làm: {text}'**
  String calendarMansionFavorable(String text);

  /// No description provided for @calendarMansionAvoid.
  ///
  /// In vi, this message translates to:
  /// **'Kiêng cữ: {text}'**
  String calendarMansionAvoid(String text);

  /// No description provided for @calendarSectionActivities.
  ///
  /// In vi, this message translates to:
  /// **'Nên làm, kỵ theo từng việc'**
  String get calendarSectionActivities;

  /// No description provided for @calendarActivitiesNote.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp từ hoàng đạo/hắc đạo, Trực, sao nhị thập bát tú và (với xuất hành) Khổng Minh lục diệu của ngày; chỉ để tham khảo.'**
  String get calendarActivitiesNote;

  /// No description provided for @calendarActivityWedding.
  ///
  /// In vi, this message translates to:
  /// **'Cưới hỏi'**
  String get calendarActivityWedding;

  /// No description provided for @calendarActivityOpening.
  ///
  /// In vi, this message translates to:
  /// **'Khai trương'**
  String get calendarActivityOpening;

  /// No description provided for @calendarActivityBuilding.
  ///
  /// In vi, this message translates to:
  /// **'Xây cất, động thổ'**
  String get calendarActivityBuilding;

  /// No description provided for @calendarActivityDeparture.
  ///
  /// In vi, this message translates to:
  /// **'Xuất hành'**
  String get calendarActivityDeparture;

  /// No description provided for @calendarActivityBurial.
  ///
  /// In vi, this message translates to:
  /// **'An táng, sửa mồ mả'**
  String get calendarActivityBurial;

  /// No description provided for @calendarActivityLawsuit.
  ///
  /// In vi, this message translates to:
  /// **'Kiện tụng'**
  String get calendarActivityLawsuit;

  /// No description provided for @calendarVerdictFavorable.
  ///
  /// In vi, this message translates to:
  /// **'Nên làm'**
  String get calendarVerdictFavorable;

  /// No description provided for @calendarVerdictNeutral.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get calendarVerdictNeutral;

  /// No description provided for @calendarVerdictUnfavorable.
  ///
  /// In vi, this message translates to:
  /// **'Nên tránh'**
  String get calendarVerdictUnfavorable;

  /// No description provided for @calendarActivityRow.
  ///
  /// In vi, this message translates to:
  /// **'{activity}: {verdict}'**
  String calendarActivityRow(String activity, String verdict);

  /// No description provided for @calendarEvidenceFor.
  ///
  /// In vi, this message translates to:
  /// **'Thuận: {what}'**
  String calendarEvidenceFor(String what);

  /// No description provided for @calendarEvidenceAgainst.
  ///
  /// In vi, this message translates to:
  /// **'Ngược: {what}'**
  String calendarEvidenceAgainst(String what);

  /// No description provided for @calendarWhatHoangDao.
  ///
  /// In vi, this message translates to:
  /// **'ngày hoàng đạo ({god})'**
  String calendarWhatHoangDao(String god);

  /// No description provided for @calendarWhatHacDao.
  ///
  /// In vi, this message translates to:
  /// **'ngày hắc đạo ({god})'**
  String calendarWhatHacDao(String god);

  /// No description provided for @calendarWhatTruc.
  ///
  /// In vi, this message translates to:
  /// **'Trực {name}'**
  String calendarWhatTruc(String name);

  /// No description provided for @calendarWhatMansion.
  ///
  /// In vi, this message translates to:
  /// **'sao {name}'**
  String calendarWhatMansion(String name);

  /// No description provided for @calendarWhatLucDieu.
  ///
  /// In vi, this message translates to:
  /// **'Khổng Minh {name}'**
  String calendarWhatLucDieu(String name);

  /// No description provided for @calendarNoEvidence.
  ///
  /// In vi, this message translates to:
  /// **'Không có chỉ dẫn riêng cho việc này.'**
  String get calendarNoEvidence;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
