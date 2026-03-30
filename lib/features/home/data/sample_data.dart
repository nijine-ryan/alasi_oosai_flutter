import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/models.dart';

// ─── Sample Data ──────────────────────────────────────────────────────────────
final List<EventModel> sampleEvents = [
  EventModel(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuASU0LiDhABAmj9NezD720KA2rs2_Z1nWZ_s0JWx9NqfXKM9YE3n8wzgPKkxsOfLWvYu261GskEK_lGOkcjH8TdsIhjbPV1KIRFxUo2XfH6WbpiCbSdNGk8mFC8cKuDU4-4Dn_boprE7K7u5GQlDvsSY64tqS4FLgB-6fQijq9fB71N2A-nmc9snFL1Ujz7KK8BdRAINAaIsxrqCIb4Y6Jdz9nTbaztyeIZYim1istw8RwU7XsjT2LzJfVWf9kFBnIIP_XKRGlTFJXv',
    month: 'Oct',
    day: '15',
    tag: 'Education',
    tagColor: AppColors.primary,
    title: 'Youth Mentorship Program',
    description:
        'Empower the next generation. Join us for a day of collaborative learning, professional growth, and meaningful connections.',
    footerType: EventFooterType.avatars,
    footerText: '+12',
    buttonLabel: 'Join Event',
    buttonColor: AppColors.primary,
  ),
  EventModel(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDoXe8JhCx1YQXLWKPW27nvBplz992xdcKFLPPlu_O02N-Zoro0OgXsT3vtGsyXzg_H22f2VM1H8DRxELZxwxQAWn-nBUZP44lWRiCu-zJNskF_CoBX9ny5ek_MDjNGopE77WApQtPtAqXppBEg7nSOJA3zOF0yLRT_IToG5E7Sz-UU45MNnD7SovLsSJ8faBFW3OL7YWq7x7cPrzZWykqEKreuZEmBf-B6KDOtDDjSjDkdL73y5H0NsWn5-MvV1ekcJsT138pxBy6W',
    month: 'Nov',
    day: '05',
    tag: 'Community',
    tagColor: AppColors.secondary,
    title: 'Annual Charity Gala',
    description:
        'A night of celebration and fundraising for local community initiatives. Dress code: Formal.',
    footerType: EventFooterType.location,
    footerText: 'Grand Ballroom',
    buttonLabel: 'Get Tickets',
    buttonColor: AppColors.secondary,
  ),
  EventModel(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAvxtW05Powaq7ZdeH4-SFq7nfvKOxISA2VwGR9PavQUyOv0auj_XfFrYlHgwnXUbvaECsICq-ZT-O8T5iOoGDaCaQa-SwhoJyY7990YuylMKgeKM4vrZU1zbNgAF4DSC1tEaHjQ5PTJ4oExdLSLigh5S2aj4-QbKyg1QQ8XNNFp-PNm2CZHarU-F8vVOYEWszSbOdAIKzhYT7VO_NRtA-lnoJRuEADB2DO_jmbwa1BaNsCvlUZ_JrCQ-uiz_sHwYm5eqB-2y7YfdOR',
    month: 'Dec',
    day: '12',
    tag: 'Environment',
    tagColor: AppColors.primary,
    title: 'Green City Initiative',
    description:
        'Help us plant 500 trees across the city park. Fresh air, good work, and community bonding.',
    footerType: EventFooterType.group,
    footerText: '45 Joined',
    buttonLabel: 'Volunteer',
    buttonColor: AppColors.primary,
  ),
];

const List<String> attendeeAvatars = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBUFRFb_lxwR60wDeCoyE8NZfSs67A3HE_Vih64P5w1eSOl-9kFCcj82TPqCNdGkYnKSnnnI2KJw-7f6AsBU61fUnRM85thjk0CBcTG9cEleJs1udCxQepFGLOSvojipSWst_cnwwRW7CXYkjb6Lahr6fWvnxq-0D_1TEG09PlzcQEYuS0oYtyJ4jS4tV3BNgiVg9AcbtB9Q8bOf3GPpADJ4cW_iY6YKpV2iY8Hv-pNigW63TPoPFpykvSglqy5-7b1udDa79ft3Oak',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuB4hr8Suwd4KuXkMxaTdFO2kFtk32ILZ7MK95fuwOyEDJrRwRkrNtzJ932Yq3jkFd_aYCtHoOfYchyoaJivW_xuvBUYb9LlxQ7jvPGDesocJlzDwwUZdQUDohDe4UvQBO8Mu-1nyu7iI8NiB2AZwj9QguWr7WyPPU4JFnmmsxxAzcchQho7Z3y6QxrK1ljt0HdyK9KzPF9jbzlRsaJb67hxwThPsqWSbGO9M8BHTqY6Wui75ykCaQLc3yUS_j_0iDKLP5b3Y-zWW5O1',
];
