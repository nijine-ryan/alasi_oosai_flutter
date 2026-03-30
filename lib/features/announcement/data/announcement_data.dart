import 'announcement_model.dart';

final List<AnnouncementGroup> announcementGroups = [
  AnnouncementGroup(
    dateLabel: '14 March 2026',
    announcements: [
      AnnouncementModel(
        title: 'Town Hall Meeting Summary',
        description:
            "Watch the highlights from yesterday's community discussion regarding the new park development project.",
        time: '03:45 PM',
        type: AnnouncementType.video,
        mediaUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCx6esfJlr6ev7GwyWhvrgDTzEBHITH0YOs18rCfWbkoS2gVbuHQ4pvEVfT_VizoCQTxcRYpDHF6TocKLClV4q5dnQ1R4kUqjWNnovZxiwr-dERwNXengHrkvAMDhJal33BDpdUCA06EYgctK5TX27tIQg2k0-5mIUH029FPHZCghn77cb1Iv9yJW5bzmrTaQ2xZeqgBDP60n_na9722AW8kTuXfdfVvLB3LM0NoRge36Rb2r2qXpj7nGmxEzpBDBkIhcLa5dYPV0Fj',
        videoDuration: '04:12',
      ),
    ],
  ),
  AnnouncementGroup(
    dateLabel: '12 March 2026',
    announcements: [
      AnnouncementModel(
        title: 'Voice Note from Trustee',
        description:
            'Listen to the latest update regarding the upcoming annual general meeting and budget allocation.',
        time: '11:20 AM',
        type: AnnouncementType.audio,
        audioCurrentTime: '0:45',
        audioTotalTime: '2:30',
        audioProgress: 0.33,
      ),
      AnnouncementModel(
        title: 'Community Water Project Update',
        description:
            'The trust has successfully completed the borehole drilling at Section B. Clean water is now available for all residents.',
        time: '10:45 AM',
        type: AnnouncementType.image,
        mediaUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAhAnDN09qj-vOffoYm4s_O7qKWZOx9dvlxYZOBMnibc3AEJmnbkDZRephBBn7G6MitQUZn9di5Gx6VtOgtpAGPeUZDnZJ949z3vtlN9etOFlWqKubtZXxpB2IaVGfzvkvQWkU8EuNCxqGgu-yvRraIX-vh5Iz94C0IzJ4Ko3Ha27EnGZXZZPc1--DcRTx1Msye2LejJ1ip1YZRZvB7pdR4-W-bVjPPO2uS0pkrPxyZrbROy6dLzhI1uTasMZUGaBOHyGHGLvuyib-6',
      ),
    ],
  ),
];
