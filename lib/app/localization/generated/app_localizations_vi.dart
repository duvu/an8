// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'An';

  @override
  String get splashSlogan => 'Cho người hữu duyên';

  @override
  String get navHome => 'Hôm nay';

  @override
  String get navLibrary => 'Bài tập';

  @override
  String get navProgress => 'Tiến độ';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get homeGreeting => 'Hôm nay mình tập nhẹ nhé.';

  @override
  String get homeOtherRoutines => 'Bài khác';

  @override
  String get homeEmpty => 'Chưa có bài tập nào được phát hành.';

  @override
  String get startAction => 'Bắt đầu';

  @override
  String get demoBanner =>
      'Bản xem trước — chưa phải hướng dẫn tập chính thức.';

  @override
  String get demoBadge => 'DEMO CONTENT';

  @override
  String minutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes phút $seconds giây';
  }

  @override
  String routineMetaLine(String duration, String intensity, String position) {
    return '$duration · $intensity · $position';
  }

  @override
  String get positionSeated => 'Ngồi';

  @override
  String get positionStanding => 'Đứng';

  @override
  String get positionMixed => 'Đứng + ngồi';

  @override
  String get intensityGentle => 'Nhẹ nhàng';

  @override
  String get intensityEasy => 'Dễ';

  @override
  String get intensityModerate => 'Vừa';

  @override
  String get detailTitle => 'Chi tiết bài';

  @override
  String detailStepsHeader(int count) {
    return '$count động tác';
  }

  @override
  String detailStepItem(String order, String title, String duration) {
    return '$order. $title · $duration';
  }

  @override
  String get detailSafetyHeader => 'Lưu ý an toàn';

  @override
  String get stopWarning =>
      'Dừng nếu chóng mặt, đau ngực, khó thở hoặc tê/yếu mới xuất hiện hay tăng lên.';

  @override
  String get detailStartAction => 'Bắt đầu bài tập';

  @override
  String get needsDownload => 'Cần tải';

  @override
  String get needsDownloadExplanation =>
      'Bài này chưa tải về máy. Tải trước khi tập khi không có mạng.';

  @override
  String get preflightTitle => 'Trước khi tập';

  @override
  String get preflightSpace => 'Chọn vị trí đủ rộng, nền không trơn.';

  @override
  String get preflightChair => 'Chuẩn bị ghế chắc chắn hoặc chỗ vịn nếu cần.';

  @override
  String get preflightComfort =>
      'Tập trong phạm vi thoải mái, không cố quá sức.';

  @override
  String get preflightConfirm => 'Tôi đã đọc, bắt đầu';

  @override
  String get safetyLink => 'Xem nguyên tắc an toàn';

  @override
  String playerStepCounter(int current, int total) {
    return 'Bước $current / $total';
  }

  @override
  String playerTotalRemaining(String time) {
    return '$time toàn bài';
  }

  @override
  String get playerPause => 'Tạm dừng';

  @override
  String get playerResume => 'Tiếp tục';

  @override
  String get playerPrevious => 'Bước trước';

  @override
  String get playerNext => 'Bước tiếp';

  @override
  String get playerPreparing => 'Đang chuẩn bị…';

  @override
  String get playerPaused => 'Đang tạm dừng.';

  @override
  String get playerInterrupted =>
      'Đã tạm dừng vì ứng dụng bị gián đoạn. Bấm Tiếp tục khi sẵn sàng.';

  @override
  String get playerBuffering => 'Đang tải nội dung…';

  @override
  String get playerError => 'Không tải được hình hướng dẫn.';

  @override
  String get playerSkip => 'Bỏ qua bước';

  @override
  String get playerBack => 'Quay lại';

  @override
  String playerProgressLabel(int percent) {
    return 'Tiến độ bài tập $percent%';
  }

  @override
  String get playerDemoMediaNotice => 'Hình minh họa AI chưa kiểm duyệt';

  @override
  String get summaryCompletedTitle => 'Hoàn thành bài tập';

  @override
  String get summaryEndedTitle => 'Đã kết thúc sớm';

  @override
  String summaryActive(String time) {
    return 'Thời gian tập thực tế: $time';
  }

  @override
  String get summaryCompletedMessage =>
      'Hôm nay bạn đã dành thời gian vận động nhẹ và thư giãn.';

  @override
  String get summaryEndedMessage =>
      'Buổi tập được lưu là chưa hoàn thành. Bạn có thể tập lại khi thấy thoải mái.';

  @override
  String get summaryHome => 'Về trang chủ';

  @override
  String get summaryProgress => 'Xem tiến độ';

  @override
  String get loadError => 'Không tải được dữ liệu.';

  @override
  String get retry => 'Thử lại';

  @override
  String get notFound => 'Không tìm thấy nội dung.';

  @override
  String get progressTitle => 'Tiến độ';

  @override
  String get progressEmpty =>
      'Chưa có buổi tập nào. Khi bạn tập, lịch sử sẽ hiện ở đây.';

  @override
  String progressTotal(String time) {
    return 'Tổng thời gian tập: $time';
  }

  @override
  String progressCounts(int count, int completed) {
    return '$count buổi · $completed hoàn thành';
  }

  @override
  String get statusCompleted => 'Hoàn thành';

  @override
  String get statusAbandoned => 'Dừng sớm';

  @override
  String get statusInterrupted => 'Bị gián đoạn';

  @override
  String get statusInProgress => 'Đang tập';

  @override
  String historyItemSubtitle(String date, String status, String time) {
    return '$date · $status · $time';
  }

  @override
  String get safetyTitle => 'An toàn khi tập';

  @override
  String get safetyIntro =>
      'An là nội dung vận động nhẹ để thư giãn, không thay thế tư vấn, chẩn đoán hay điều trị y tế.';

  @override
  String get safetyRuleSpace =>
      'Tập trong không gian an toàn, nền không trơn; dùng ghế chắc hoặc chỗ vịn khi cần.';

  @override
  String get safetyRuleGentle =>
      'Chuyển động chậm, trong phạm vi thoải mái; không nín thở, không cố quá sức.';

  @override
  String get safetyRuleNeck =>
      'Không ấn sâu hay xoa bóp mạnh vùng cổ trước hoặc dưới góc hàm.';

  @override
  String get safetyEmergency =>
      'Nếu triệu chứng nặng hoặc kéo dài, hãy gọi cấp cứu 115 hoặc đến cơ sở y tế gần nhất.';

  @override
  String get safetyBack => 'Quay lại';

  @override
  String get libraryTitle => 'Bài tập';

  @override
  String get librarySearchHint => 'Tìm bài hoặc động tác';

  @override
  String get libraryFilterGoal => 'Mục tiêu';

  @override
  String get libraryFilterPosition => 'Tư thế';

  @override
  String get libraryFilterDuration => 'Thời lượng';

  @override
  String get libraryFilterAll => 'Tất cả';

  @override
  String get libraryOfflineOnly => 'Chỉ bài có sẵn trên máy';

  @override
  String get libraryEmpty => 'Không có bài phù hợp với bộ lọc.';

  @override
  String get libraryClearFilters => 'Xóa bộ lọc';

  @override
  String libraryResultCount(int count) {
    return '$count bài';
  }

  @override
  String get durationShort => 'Đến 6 phút';

  @override
  String get durationMedium => '7–10 phút';

  @override
  String get durationLong => 'Trên 10 phút';

  @override
  String get availableOffline => 'Có sẵn trên máy';

  @override
  String get tagStarter => 'Mới bắt đầu';

  @override
  String get tagMorning => 'Buổi sáng';

  @override
  String get tagEvening => 'Buổi tối';

  @override
  String get tagNeckShoulder => 'Cổ vai';

  @override
  String get tagSeated => 'Trên ghế';

  @override
  String get tagGentle => 'Nhẹ nhàng';

  @override
  String get onboardingValueTitle => 'Dưỡng sinh nhẹ nhàng mỗi ngày';

  @override
  String get onboardingValueBody =>
      'Các bài vận động ngắn, chậm, có thể tập trên ghế. Không cần tài khoản, không hỏi thông tin sức khỏe.';

  @override
  String get onboardingSafetyNotice =>
      'An là nội dung thư giãn, không thay thế tư vấn hay điều trị y tế. Hãy dừng khi thấy khó chịu.';

  @override
  String get onboardingContinue => 'Tiếp tục';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingPrefsTitle => 'Bạn muốn tập thế nào? (không bắt buộc)';

  @override
  String get onboardingGoal => 'Mục tiêu';

  @override
  String get onboardingPosition => 'Tư thế';

  @override
  String get onboardingPositionAny => 'Cả hai';

  @override
  String get onboardingDone => 'Khám phá bài tập';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsPracticeSection => 'Khi tập';

  @override
  String get settingsCaptions => 'Hiện lời hướng dẫn';

  @override
  String get settingsCaptionsHint => 'Câu hướng dẫn hiển thị dưới hình.';

  @override
  String get settingsReducedMotion => 'Giảm chuyển động';

  @override
  String get settingsReducedMotionHint =>
      'Chuyển hình không hiệu ứng. Nội dung hướng dẫn vẫn giữ nguyên.';

  @override
  String get settingsReminderSection => 'Nhắc nhở';

  @override
  String get settingsReminder => 'Nhắc tập mỗi ngày';

  @override
  String settingsReminderTime(String time) {
    return 'Giờ nhắc: $time';
  }

  @override
  String get settingsReminderChangeTime => 'Đổi giờ';

  @override
  String get settingsReminderDenied =>
      'Chưa được cấp quyền thông báo. Bạn có thể bật trong Cài đặt của điện thoại.';

  @override
  String get settingsReminderError =>
      'Không đặt được nhắc nhở. Vui lòng thử lại.';

  @override
  String get reminderTitle => 'An';

  @override
  String get reminderBody =>
      'Đến giờ vận động nhẹ rồi. Tập khi bạn thấy thoải mái nhé.';

  @override
  String get settingsBreakSection => 'Nhắc đứng dậy';

  @override
  String get settingsBreak => 'Nhắc đứng dậy vận động';

  @override
  String get settingsBreakHint =>
      'Ngồi lâu cả ngày không tốt cho sức khỏe. An nhắc bạn đứng lên, đi lại và uống nước.';

  @override
  String get settingsBreakInterval => 'Cách nhau';

  @override
  String settingsBreakIntervalOption(int minutes) {
    return '$minutes phút';
  }

  @override
  String settingsBreakFrom(String time) {
    return 'Từ: $time';
  }

  @override
  String settingsBreakTo(String time) {
    return 'Đến: $time';
  }

  @override
  String get settingsBreakAlertLabel => 'Kiểu nhắc';

  @override
  String get settingsBreakAlertSilent => 'Chỉ thông báo';

  @override
  String get settingsBreakAlertVibrate => 'Rung';

  @override
  String get settingsBreakAlertSound => 'Chuông';

  @override
  String get settingsBreakAlertIosNote =>
      'Trên iPhone, kiểu \"Rung\" hoạt động như \"Chỉ thông báo\"; hãy dùng \"Chuông\" nếu cần nghe thấy.';

  @override
  String get settingsBreakInvalidWindow =>
      'Khoảng giờ quá ngắn so với khoảng cách giữa hai lần nhắc. Hãy kéo dài giờ kết thúc hoặc chọn khoảng cách ngắn hơn.';

  @override
  String get breakReminderBody1 =>
      'Bạn đã ngồi một lúc rồi. Đứng dậy, đi lại vài phút nhé.';

  @override
  String get breakReminderBody2 =>
      'Đứng lên vươn vai, xoay cổ nhẹ nhàng và uống một ngụm nước.';

  @override
  String get breakReminderBody3 =>
      'Nghỉ mắt một chút: nhìn xa 20 giây, rồi đứng dậy vận động nhẹ.';

  @override
  String get settingsMoreSection => 'Khác';

  @override
  String get settingsSafety => 'An toàn khi tập';

  @override
  String get settingsDownloads => 'Bài đã tải';

  @override
  String get settingsPrivacy => 'Quyền riêng tư';

  @override
  String get settingsPrivacyBody =>
      'Dữ liệu tập, số đo sức khỏe và cài đặt chỉ lưu trên máy này: không gửi đi đâu, không sao lưu lên đám mây, không cần tài khoản.';

  @override
  String get settingsTextSizeHint => 'Cỡ chữ theo cài đặt của điện thoại.';

  @override
  String get downloadsTitle => 'Bài đã tải';

  @override
  String get downloadsReady => 'Có sẵn trên máy';

  @override
  String get downloadsMissing => 'Chưa có trên máy';

  @override
  String downloadsSize(String megabytes) {
    return '$megabytes MB';
  }

  @override
  String get downloadsNote =>
      'Các bài xem trước hiện đi kèm ứng dụng nên tập được khi không có mạng. Tải bài mới qua mạng sẽ có khi nội dung chính thức được phát hành.';

  @override
  String distanceNextUp(String title) {
    return 'Tiếp theo: $title';
  }

  @override
  String get distanceEndingLast => 'Sắp kết thúc bài';

  @override
  String get distanceRemaining => 'còn lại';

  @override
  String distanceTimerLabel(String title, String time) {
    return '$title, còn lại $time';
  }

  @override
  String distanceEndingNext(String title) {
    return 'Sắp đổi sang: $title';
  }

  @override
  String get easternTitle => 'Dưỡng sinh phương Đông';

  @override
  String easternEntrySubtitle(int count, int playable) {
    return '$count hệ truyền thống · $playable hệ đã có bài tập';
  }

  @override
  String get easternIntro =>
      'Giới thiệu các hệ dưỡng sinh truyền thống. Hệ nào đủ ảnh từng bước thì tập được ngay; các hệ khác sẽ được bổ sung dần sau khi kiểm duyệt kỹ thuật và hình ảnh.';

  @override
  String get easternPreparing => 'Đang chuẩn bị – chưa có bài tập';

  @override
  String get easternResearch => 'Đang nghiên cứu nguồn';

  @override
  String easternFormCount(int count) {
    return '$count thức';
  }

  @override
  String easternCoverLabel(String title) {
    return 'Ảnh bìa minh họa $title, không thể hiện tư thế tập';
  }

  @override
  String get easternCoverNotice =>
      'Ảnh bìa minh họa, không phải hướng dẫn tư thế.';

  @override
  String get easternFormsHeader => 'Các thức';

  @override
  String easternFormItem(int number, String title) {
    return '$number. $title';
  }

  @override
  String get easternNotesHeader => 'Ghi chú';

  @override
  String get easternRequiredHeader => 'Cần làm trước khi biên soạn';

  @override
  String get easternSourcesHeader => 'Nguồn tham khảo';

  @override
  String get easternLevelGentleToModerate => 'Nhẹ đến vừa';

  @override
  String get easternLevelModerate => 'Vừa';

  @override
  String get settingsSoundCues => 'Âm báo khi tập';

  @override
  String get settingsSoundCuesHint =>
      'Tiếng chuông nhẹ khi đếm ngược, khi đổi động tác, báo trước 10 giây và khi hoàn thành.';

  @override
  String get easternFormIllustrationNotice =>
      'Ảnh minh họa chưa được đối chiếu kỹ thuật. Không tập theo ảnh này; bài tập có hướng dẫn sẽ được bổ sung sau khi chuyên gia duyệt.';

  @override
  String easternFormIllustrationLabel(String title) {
    return 'Ảnh minh họa thức $title, chưa đối chiếu kỹ thuật';
  }

  @override
  String get tagBaduanjin => 'Bát Đoạn Cẩm';

  @override
  String get tagEasternQigong => 'Khí công phương Đông';

  @override
  String get easternPlayable => 'Đã có bài tập';

  @override
  String easternPracticeAction(String title) {
    return 'Tập bài $title';
  }

  @override
  String get easternStepsHeader => 'Các bước';

  @override
  String get easternOverviewHeader => 'Bảng tổng quan các thức';

  @override
  String get easternOverviewNotice =>
      'Tranh minh họa để làm quen tên và dáng các thức. Chưa được đối chiếu kỹ thuật, không tập theo tranh này.';

  @override
  String get easternOverviewOpen => 'Chạm để xem lớn, có thể phóng to';

  @override
  String easternOverviewLabel(String system, String title) {
    return 'Bảng tổng quan $system, $title';
  }

  @override
  String get pauseTitle => 'Đang tạm dừng';

  @override
  String get pauseMessage =>
      'Nghỉ một chút nếu cần. Nếu dừng hẳn, thời gian đã tập được lưu là chưa hoàn thành.';

  @override
  String get pauseResume => 'Tiếp tục';

  @override
  String get pauseStop => 'Dừng hẳn';

  @override
  String get settingsBackgroundMusic => 'Nhạc nền khi tập';

  @override
  String get settingsBackgroundMusicHint =>
      'Nhạc nhẹ không lời, tự dừng khi bạn tạm dừng.';

  @override
  String get learnHeader => 'Tìm hiểu';

  @override
  String get learnMeaning => 'Ý nghĩa';

  @override
  String get learnAwareness => 'Khi tập, hãy để ý';

  @override
  String get learnNote => 'Ghi chú';

  @override
  String get learnSystemHeader => 'Lịch sử và văn hóa';

  @override
  String get learnHistory => 'Lịch sử';

  @override
  String get learnContext => 'Bối cảnh văn hóa';

  @override
  String get learnSpirit => 'Tinh thần của bài';

  @override
  String get learnReadingCautions => 'Lưu ý khi đọc';

  @override
  String get learnSources => 'Nguồn tham khảo';

  @override
  String get learnDisclaimer =>
      'Nội dung tìm hiểu do An biên tập, chưa được chuyên gia thẩm định. Đây không phải hướng dẫn kỹ thuật hay lời khuyên y tế.';

  @override
  String get learnStoriesHeader => 'Chuyện kể';

  @override
  String learnOpenAction(String title) {
    return 'Tìm hiểu $title';
  }

  @override
  String get navHealth => 'Sức khỏe';

  @override
  String get healthTitle => 'Sức khỏe';

  @override
  String get healthConsentTitle => 'Theo dõi chỉ số sức khỏe';

  @override
  String get healthConsentIntro =>
      'Ghi lại các số đo hằng ngày để bạn và bác sĩ dễ theo dõi theo thời gian.';

  @override
  String get healthConsentManual =>
      'Bạn tự nhập số đo: cân nặng, chiều cao, huyết áp, nhịp tim, đường huyết, SpO2, nhiệt độ, vòng eo.';

  @override
  String get healthConsentLocal =>
      'Dữ liệu chỉ lưu trên điện thoại này. App không gửi đi đâu và không sao lưu lên đám mây.';

  @override
  String get healthConsentDelete =>
      'Bạn có thể xóa toàn bộ dữ liệu sức khỏe bất cứ lúc nào trong Cài đặt.';

  @override
  String get healthConsentNoDiagnosis =>
      'App không chẩn đoán bệnh. Khoảng tham khảo chỉ giúp bạn biết khi nào nên hỏi bác sĩ.';

  @override
  String get healthConsentAccept => 'Đồng ý và bắt đầu';

  @override
  String get healthAddAction => 'Ghi chỉ số';

  @override
  String get healthNoReading => 'Chưa có số đo';

  @override
  String get healthDisclaimer =>
      'Đây là sổ theo dõi cá nhân, không thay thế khám bệnh. Hãy mang số đo khi đi khám và làm theo hướng dẫn của bác sĩ.';

  @override
  String get metricWeight => 'Cân nặng';

  @override
  String get metricHeight => 'Chiều cao';

  @override
  String get metricBloodPressure => 'Huyết áp';

  @override
  String get metricHeartRate => 'Nhịp tim';

  @override
  String get metricBloodGlucose => 'Đường huyết';

  @override
  String get metricOxygenSaturation => 'SpO2 (ô-xy trong máu)';

  @override
  String get metricTemperature => 'Nhiệt độ cơ thể';

  @override
  String get metricWaist => 'Vòng eo';

  @override
  String get unitKg => 'kg';

  @override
  String get unitCm => 'cm';

  @override
  String get unitMmHg => 'mmHg';

  @override
  String get unitBpm => 'lần/phút';

  @override
  String get unitMmolL => 'mmol/L';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitPercent => '%';

  @override
  String get unitCelsius => '°C';

  @override
  String get bmiTitle => 'BMI';

  @override
  String get bmiUnder => 'Thấp hơn mức tham khảo';

  @override
  String get bmiNormal => 'Trong mức tham khảo';

  @override
  String get bmiOver => 'Thừa cân (mức tham khảo người châu Á)';

  @override
  String get bmiObese => 'Béo phì (mức tham khảo người châu Á)';

  @override
  String get bmiNeedsBoth => 'Ghi cân nặng và chiều cao để tính BMI.';

  @override
  String get bmiNote =>
      'Tính từ cân nặng và chiều cao gần nhất. Ở người cao tuổi, BMI chỉ là số tham khảo.';

  @override
  String get bmiNeedsWeight => 'Ghi cân nặng để tính BMI.';

  @override
  String bmiWeightRange(String height, String min, String max) {
    return 'Cân nặng tham khảo với chiều cao $height cm: $min–$max kg';
  }

  @override
  String get bmiWeightInRange => 'Cân nặng hiện tại nằm trong khoảng này.';

  @override
  String bmiWeightAbove(String kg) {
    return 'Cân nặng hiện tại nhiều hơn mức trên $kg kg.';
  }

  @override
  String bmiWeightBelow(String kg) {
    return 'Cân nặng hiện tại ít hơn mức dưới $kg kg.';
  }

  @override
  String get bmiWeightAdvice =>
      'Ở người cao tuổi, đừng tự ăn kiêng hay ép tăng cân; hãy hỏi bác sĩ trước khi đặt mục tiêu cân nặng.';

  @override
  String get weightLossNotice =>
      'Cân nặng giảm từ 5% trở lên trong 6 tháng. Nếu bạn không chủ ý giảm cân, hãy trao đổi với bác sĩ.';

  @override
  String get statusInRange => 'Trong khoảng tham khảo';

  @override
  String get statusOutside => 'Ngoài khoảng tham khảo';

  @override
  String get statusUrgent => 'Cần chú ý ngay';

  @override
  String get reasonPressureHigh =>
      'Huyết áp đo tại nhà từ 135/85 mmHg trở lên. Đo lại sau khi ngồi nghỉ 5 phút; nếu nhiều lần vẫn cao, hãy hỏi bác sĩ.';

  @override
  String get reasonPressureLow =>
      'Huyết áp thấp hơn 90/60 mmHg. Nếu thấy chóng mặt, mệt, hãy ngồi hoặc nằm nghỉ và hỏi bác sĩ.';

  @override
  String get reasonPressureVeryHigh =>
      'Huyết áp rất cao (từ 180/120 mmHg). Nếu kèm đau ngực, khó thở, đau đầu dữ dội, yếu hoặc tê tay chân, nói khó: gọi 115 ngay. Nếu không có các dấu hiệu đó, ngồi nghỉ 5 phút rồi đo lại và liên hệ bác sĩ sớm.';

  @override
  String get reasonPulseHigh =>
      'Nhịp tim lúc nghỉ trên 100 lần/phút. Ngồi nghỉ rồi đo lại; nếu vẫn cao hoặc thấy hồi hộp, khó thở, hãy hỏi bác sĩ.';

  @override
  String get reasonPulseLow =>
      'Nhịp tim lúc nghỉ dưới 60 lần/phút. Điều này có thể bình thường ở một số người; nếu kèm chóng mặt, mệt lả, hãy hỏi bác sĩ.';

  @override
  String get reasonGlucoseHigh =>
      'Đường huyết cao hơn khoảng tham khảo cho thời điểm đo. Hãy ghi lại và trao đổi với bác sĩ.';

  @override
  String get reasonGlucoseLow =>
      'Đường huyết thấp (dưới 3,9 mmol/L). Nếu run, vã mồ hôi, lú lẫn: xử trí ngay theo hướng dẫn bác sĩ đã dặn hoặc gọi 115.';

  @override
  String get reasonGlucoseVeryHigh =>
      'Đường huyết rất cao (từ 16,7 mmol/L). Liên hệ bác sĩ ngay; nếu lơ mơ, khó thở, nôn nhiều: gọi 115.';

  @override
  String get reasonOxygenLow =>
      'SpO2 dưới 95%. Ngồi thẳng, nghỉ rồi đo lại; nếu vẫn thấp, hãy hỏi bác sĩ.';

  @override
  String get reasonOxygenVeryLow =>
      'SpO2 từ 92% trở xuống. Nếu khó thở, môi tím, lú lẫn: gọi 115 ngay. Nếu không, đo lại và liên hệ bác sĩ ngay.';

  @override
  String get reasonFever =>
      'Sốt (từ 37,5 °C). Uống đủ nước, nghỉ ngơi và theo dõi; hỏi bác sĩ nếu sốt kéo dài hoặc kèm dấu hiệu khác.';

  @override
  String get reasonHighFever =>
      'Sốt cao (từ 39,5 °C). Liên hệ bác sĩ ngay; nếu lú lẫn, co giật, khó thở: gọi 115.';

  @override
  String get reasonTemperatureLow =>
      'Thân nhiệt thấp (dưới 35,5 °C). Đo lại, giữ ấm; nếu vẫn thấp hoặc lơ mơ, hãy liên hệ bác sĩ.';

  @override
  String get referencePressure =>
      'Khoảng tham khảo đo tại nhà: dưới 135/85 mmHg (ESC/ESH 2018, Hội Tim mạch Việt Nam 2018).';

  @override
  String get referenceHeartRate =>
      'Khoảng tham khảo lúc nghỉ: 60–100 lần/phút.';

  @override
  String get referenceGlucose =>
      'Khoảng tham khảo: lúc đói dưới 7,0 mmol/L; sau ăn 2 giờ hoặc bất kỳ dưới 11,1 mmol/L (ADA). Người đang điều trị có thể có mục tiêu riêng do bác sĩ đặt.';

  @override
  String get referenceOxygen => 'Khoảng tham khảo: từ 95% trở lên.';

  @override
  String get referenceTemperature => 'Khoảng tham khảo: 35,5–37,4 °C.';

  @override
  String get referenceWeight =>
      'Cân vào cùng giờ, cùng trang phục để dễ so sánh. Giảm cân ngoài ý muốn là dấu hiệu cần hỏi bác sĩ.';

  @override
  String get referenceHeight =>
      'Chiều cao dùng để tính BMI; ở người cao tuổi nên đo lại vài lần mỗi năm.';

  @override
  String get referenceWaist => 'Đo ngang rốn, cuối thì thở ra nhẹ.';

  @override
  String get referenceSource =>
      'Mục tiêu điều trị của bạn có thể khác; hãy theo hướng dẫn của bác sĩ.';

  @override
  String get timingFasting => 'Lúc đói';

  @override
  String get timingAfterMeal => 'Sau ăn 2 giờ';

  @override
  String get timingRandom => 'Bất kỳ';

  @override
  String get healthMetricField => 'Chỉ số';

  @override
  String healthValueField(String unit) {
    return 'Giá trị ($unit)';
  }

  @override
  String get healthTimingField => 'Thời điểm đo';

  @override
  String get healthUnitField => 'Đơn vị';

  @override
  String healthMeasuredAt(String date, String time) {
    return 'Đo lúc $date $time';
  }

  @override
  String get healthChangeDate => 'Đổi ngày';

  @override
  String get healthChangeTime => 'Đổi giờ';

  @override
  String get healthNoteField => 'Ghi chú (không bắt buộc)';

  @override
  String get healthSave => 'Lưu';

  @override
  String get healthSaved => 'Đã lưu số đo.';

  @override
  String healthErrorRange(String min, String max) {
    return 'Giá trị có vẻ chưa đúng. Hãy nhập trong khoảng $min–$max.';
  }

  @override
  String get healthErrorPressureOrder =>
      'Số trên (tâm thu) phải lớn hơn số dưới (tâm trương).';

  @override
  String get healthErrorTiming => 'Chọn thời điểm đo đường huyết.';

  @override
  String get healthUrgentTitle => 'Cần chú ý';

  @override
  String get healthUrgentOk => 'Tôi đã hiểu';

  @override
  String get healthHistoryHeader => 'Các lần đo';

  @override
  String healthChartLabel(String metric, int count, String latest) {
    return 'Biểu đồ $metric: $count lần đo, gần nhất $latest';
  }

  @override
  String get healthDeleteReading => 'Xóa số đo';

  @override
  String get healthDeleteReadingConfirm => 'Xóa số đo này?';

  @override
  String get healthDeleteConfirmAction => 'Xóa';

  @override
  String get healthCancel => 'Hủy';

  @override
  String get settingsHealthSection => 'Dữ liệu sức khỏe';

  @override
  String get settingsHealthDeleteAll => 'Xóa toàn bộ dữ liệu sức khỏe';

  @override
  String get settingsHealthDeleteAllHint =>
      'Xóa mọi số đo trên máy và tắt theo dõi. Không thể hoàn tác.';

  @override
  String get settingsHealthDeleteAllConfirm =>
      'Xóa toàn bộ số đo sức khỏe trên điện thoại này? Không thể hoàn tác.';

  @override
  String get settingsHealthDeleted => 'Đã xóa toàn bộ dữ liệu sức khỏe.';

  @override
  String get healthErrorFuture => 'Thời điểm đo không thể ở tương lai.';

  @override
  String get healthPressureField => 'Huyết áp (mmHg) và nhịp tim';

  @override
  String get healthSystolicField => 'Tâm thu';

  @override
  String get healthDiastolicField => 'Tâm trương';

  @override
  String get healthPulseField => 'Nhịp tim';

  @override
  String get healthPressureHint =>
      'Gõ lần lượt 3 số trên máy đo, ô tự chuyển khi đủ số. Nhịp tim có thể bỏ trống.';

  @override
  String get healthPressureFormat => 'Hãy nhập cả số tâm thu và số tâm trương.';

  @override
  String healthPulseRange(String min, String max) {
    return 'Nhịp tim có vẻ chưa đúng. Hãy nhập trong khoảng $min–$max.';
  }

  @override
  String get healthExportAction => 'Xuất dữ liệu (CSV, ảnh)';

  @override
  String get healthExportTitle => 'Xuất dữ liệu sức khỏe';

  @override
  String get healthExportIntro =>
      'Tạo file để mang đi khám hoặc gửi cho người thân. Sau khi tạo, bạn tự chọn nơi gửi hoặc lưu (Zalo, Gmail, Drive, Tệp…). App không tự gửi đi đâu.';

  @override
  String get healthExportPrivacy =>
      'File chứa thông tin sức khỏe của bạn. Chỉ gửi cho người bạn tin tưởng.';

  @override
  String get healthExportCsv => 'Xuất file CSV (mở bằng Excel)';

  @override
  String get healthExportCsvHint => 'Toàn bộ số đo, mỗi lần đo một dòng.';

  @override
  String get healthExportImage => 'Xuất ảnh tóm tắt';

  @override
  String get healthExportImageHint =>
      'Ảnh bên dưới: số đo gần nhất và biểu đồ, tiện cho bác sĩ xem nhanh.';

  @override
  String get healthExportPreview => 'Xem trước ảnh';

  @override
  String get healthExportEmpty => 'Chưa có số đo nào để xuất.';

  @override
  String get healthExportFailed => 'Không tạo được file. Hãy thử lại.';

  @override
  String get healthExportSubject => 'An – số đo sức khỏe';

  @override
  String get healthReportTitle => 'Sổ theo dõi sức khỏe';

  @override
  String healthReportCreated(String date, String time) {
    return 'Tạo lúc $date $time';
  }

  @override
  String get healthReportLatest => 'Số đo gần nhất';

  @override
  String get healthReportTrends => 'Xu hướng';

  @override
  String get csvMeasuredAt => 'Ngày giờ đo';

  @override
  String get csvMetric => 'Chỉ số';

  @override
  String get csvValue => 'Giá trị';

  @override
  String get csvSecondValue => 'Giá trị 2 (tâm trương)';

  @override
  String get csvUnit => 'Đơn vị';

  @override
  String get csvGlucoseTiming => 'Thời điểm đo đường huyết';

  @override
  String get csvNote => 'Ghi chú';

  @override
  String get calendarTitle => 'Lịch vạn niên';

  @override
  String get calendarOpen => 'Xem lịch';

  @override
  String get calendarToday => 'Hôm nay';

  @override
  String get calendarPickDate => 'Chọn ngày';

  @override
  String get calendarPrevMonth => 'Tháng trước';

  @override
  String get calendarNextMonth => 'Tháng sau';

  @override
  String calendarMonthTitle(int month, int year) {
    return 'Tháng $month năm $year';
  }

  @override
  String calendarMonthSubtitle(String yearName) {
    return 'Năm $yearName';
  }

  @override
  String get calendarWeekdayShort1 => 'T2';

  @override
  String get calendarWeekdayFull1 => 'Thứ hai';

  @override
  String get calendarWeekdayShort2 => 'T3';

  @override
  String get calendarWeekdayFull2 => 'Thứ ba';

  @override
  String get calendarWeekdayShort3 => 'T4';

  @override
  String get calendarWeekdayFull3 => 'Thứ tư';

  @override
  String get calendarWeekdayShort4 => 'T5';

  @override
  String get calendarWeekdayFull4 => 'Thứ năm';

  @override
  String get calendarWeekdayShort5 => 'T6';

  @override
  String get calendarWeekdayFull5 => 'Thứ sáu';

  @override
  String get calendarWeekdayShort6 => 'T7';

  @override
  String get calendarWeekdayFull6 => 'Thứ bảy';

  @override
  String get calendarWeekdayShort7 => 'CN';

  @override
  String get calendarWeekdayFull7 => 'Chủ nhật';

  @override
  String calendarCellLabel(
    String weekday,
    int day,
    int month,
    int year,
    int lunarDay,
    int lunarMonth,
    String quality,
  ) {
    return '$weekday, ngày $day tháng $month năm $year, âm lịch ngày $lunarDay tháng $lunarMonth, $quality';
  }

  @override
  String calendarLunarMonthStart(int day, int month) {
    return '$day/$month';
  }

  @override
  String get calendarHoangDao => 'Ngày hoàng đạo';

  @override
  String get calendarHacDao => 'Ngày hắc đạo';

  @override
  String calendarSelectedDate(String weekday, int day, int month, int year) {
    return '$weekday, $day tháng $month năm $year';
  }

  @override
  String get calendarSectionDate => 'Dương lịch và âm lịch';

  @override
  String calendarLunarDate(int day, int month, String leap, String yearName) {
    return 'Âm lịch: ngày $day tháng $month$leap năm $yearName';
  }

  @override
  String get calendarLeapSuffix => ' nhuận';

  @override
  String calendarCanChiLine(String day, String month, String year) {
    return 'Ngày $day · Tháng $month · Năm $year';
  }

  @override
  String calendarSolarTerm(String term) {
    return 'Tiết khí: $term';
  }

  @override
  String calendarSolarTermStarts(String term) {
    return 'Tiết khí: $term (bắt đầu hôm nay)';
  }

  @override
  String get calendarFirstDay => 'Mùng 1 âm lịch';

  @override
  String get calendarFullMoon => 'Rằm (15 âm lịch)';

  @override
  String get calendarSectionQuality => 'Đánh giá ngày';

  @override
  String get calendarRatingGood => 'Ngày tốt';

  @override
  String get calendarRatingNeutral => 'Ngày bình thường';

  @override
  String get calendarRatingBad => 'Ngày xấu';

  @override
  String calendarGodLine(String kind, String god) {
    return '$kind · $god';
  }

  @override
  String calendarTruc(String name, String note) {
    return 'Trực $name: $note';
  }

  @override
  String get calendarRatingNote =>
      'Đánh giá gộp hoàng đạo/hắc đạo và trực của ngày, chỉ để tham khảo.';

  @override
  String get calendarSectionHours => 'Giờ hoàng đạo';

  @override
  String calendarHourLine(String name, String start, String end, String god) {
    return 'Giờ $name ($start–$end) · $god';
  }

  @override
  String get calendarSectionDeparture => 'Xuất hành';

  @override
  String calendarDepartureDay(String name, String note) {
    return 'Khổng Minh lục diệu: $name. $note';
  }

  @override
  String calendarHyThan(String direction) {
    return 'Hướng hỷ thần (cầu may): $direction';
  }

  @override
  String calendarTaiThan(String direction) {
    return 'Hướng tài thần (cầu tài): $direction';
  }

  @override
  String get calendarDepartureHours => 'Giờ đẹp để xuất hành';

  @override
  String get calendarNoDepartureHours =>
      'Hôm nay không có giờ hoàng đạo nào hợp xuất hành.';

  @override
  String get calendarAllHours => 'Xem đủ 12 giờ';

  @override
  String calendarHourDetail(
    String name,
    String start,
    String end,
    String kind,
    String cung,
  ) {
    return 'Giờ $name ($start–$end): $kind; xuất hành $cung';
  }

  @override
  String get calendarHourHoangDao => 'hoàng đạo';

  @override
  String get calendarHourHacDao => 'hắc đạo';

  @override
  String get calendarDisclaimer =>
      'Lịch vạn niên chỉ mang tính tham khảo theo văn hóa truyền thống và chưa được chuyên gia thẩm định. Hãy cân nhắc theo hoàn cảnh của bạn; không thay thế lời khuyên y tế, pháp lý hay tài chính.';

  @override
  String get calendarLegend =>
      '● Ngày hoàng đạo   ○ Ngày hắc đạo   Chữ nhỏ: ngày âm lịch';

  @override
  String get calendarSectionMansion => 'Sao nhị thập bát tú';

  @override
  String calendarMansionLine(String name, String element, String animal) {
    return 'Sao $name ($element, $animal)';
  }

  @override
  String get calendarMansionKiet => 'Kiết tú (sao tốt)';

  @override
  String get calendarMansionBinh => 'Bình tú (sao trung bình)';

  @override
  String get calendarMansionHung => 'Hung tú (sao xấu)';

  @override
  String calendarMansionFavorable(String text) {
    return 'Nên làm: $text';
  }

  @override
  String calendarMansionAvoid(String text) {
    return 'Kiêng cữ: $text';
  }

  @override
  String get calendarSectionActivities => 'Nên làm, kỵ theo từng việc';

  @override
  String get calendarActivitiesNote =>
      'Tổng hợp từ hoàng đạo/hắc đạo, Trực, sao nhị thập bát tú và (với xuất hành) Khổng Minh lục diệu của ngày; chỉ để tham khảo.';

  @override
  String get calendarActivityWedding => 'Cưới hỏi';

  @override
  String get calendarActivityOpening => 'Khai trương';

  @override
  String get calendarActivityBuilding => 'Xây cất, động thổ';

  @override
  String get calendarActivityDeparture => 'Xuất hành';

  @override
  String get calendarActivityBurial => 'An táng, sửa mồ mả';

  @override
  String get calendarActivityLawsuit => 'Kiện tụng';

  @override
  String get calendarVerdictFavorable => 'Nên làm';

  @override
  String get calendarVerdictNeutral => 'Bình thường';

  @override
  String get calendarVerdictUnfavorable => 'Nên tránh';

  @override
  String calendarActivityRow(String activity, String verdict) {
    return '$activity: $verdict';
  }

  @override
  String calendarEvidenceFor(String what) {
    return 'Thuận: $what';
  }

  @override
  String calendarEvidenceAgainst(String what) {
    return 'Ngược: $what';
  }

  @override
  String calendarWhatHoangDao(String god) {
    return 'ngày hoàng đạo ($god)';
  }

  @override
  String calendarWhatHacDao(String god) {
    return 'ngày hắc đạo ($god)';
  }

  @override
  String calendarWhatTruc(String name) {
    return 'Trực $name';
  }

  @override
  String calendarWhatMansion(String name) {
    return 'sao $name';
  }

  @override
  String calendarWhatLucDieu(String name) {
    return 'Khổng Minh $name';
  }

  @override
  String get calendarNoEvidence => 'Không có chỉ dẫn riêng cho việc này.';
}
