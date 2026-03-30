/// Two states only:
/// - selectable: member can be tapped and selected
/// - alreadyRegistered: member is locked, shown with "Already registered" + green "Active" badge
enum MemberStatus { selectable, selected, alreadyRegistered }

class FamilyMemberModel {
  final String id; // mapped from _id
  final String name;
  final String? imageUrl;
  final MemberStatus status;

  FamilyMemberModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.status,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    MemberStatus status;
    switch (json['status']) {
      case 'active':
        status = MemberStatus.alreadyRegistered;
        break;
      case 'not_registered':
      default:
        status = MemberStatus.selectable;
        break;
    }
    return FamilyMemberModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?, // null if not present
      status: status,
    );
  }

  FamilyMemberModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    MemberStatus? status,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}

// ── Sample data ───────────────────────────────────────────────────────────────

final List<FamilyMemberModel> sampleFamilyMembers = [
  FamilyMemberModel(
    id: '1',
    name: 'Sarah Jenkins',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCloPzqyC5yvNyMT0B-NkUZKYN_AIdjB3FC8gWvN35yEbd-zvlCnBEXV6RpbHDT68TG0jBy2b5Hr4UToW48ZjKxvIyXQCCgkk6QYWQPeSDasHSQcQ5uAxUXsNJsQ0zYrD0FPPy63GQFmyTmq-_wWq29aKAYeL4OJ7TC40x1Heue2tfGw7_Z_eSqjEpyPqPkQxxnQyQ2WEERujw-2_e8vnb1due4i_sHNzTdz-znt8P2p6xxkOb993k5kGkDvEM877jN7xknCmn53hiN',
    status: MemberStatus.selectable,
  ),
  FamilyMemberModel(
    id: '2',
    name: 'Michael Jenkins',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA727E-uHvoQl_rkD96dI2qhnlMRPAiG_nYg7X7EhpmHHv4w81SSkOAcLqJGNjzIGN0-F4hP3WXJ70nd9sJ6-H-fjJ9_1K77zzhLVRZ5qqjSBkhzq3j3-5KfTTKYJkPskzyLkr331EyR2okwNBC-bPISBmheydIdX9PcQpQx8XKRdJbRlsiqEAYRkRkFZWlIxf1oZt4vz28b4qkJoUntYxylTj8WpH7ddLalCl9PdDzMC7uBbuxisIftDrDe5uFygD4dA7ZtS0683Zg',
    status: MemberStatus.alreadyRegistered,
  ),
  FamilyMemberModel(
    id: '3',
    name: 'Elena Vance',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBq00A1Nca3HUbM5zYguCbYuAeYsxltnutX8iNqcEns3GAmm1RrJ8Pbd0c-gKhdJSD1mSHnmaD1K3tH2tmF5XNbL05y6G3jhMwIHHrDry21w-5pjAJXTZedVx3PkYHYuBEwWWZ-8xWLncOgz3fxvMhCBJFZ-FKNxbm6pupOPKTlUYUoNWwBYgR4JvsVBdogfbM8GILhGm45B76KknzLZfVOctNIQchZjJLl7UeiMDWcO2XbqNQrtCylY',
    status: MemberStatus.selectable,
  ),
  FamilyMemberModel(
    id: '4',
    name: 'Chloe Jenkins',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDeJlpErrpdZNnEoqxeOAWFKBYtU1d2VNvJ_iV1C1UozFMYLgYie_Gatatfp0e2Hk4bktzqo_3buDwVu1GzUiDsT1eKW2_rWguKP_Do48eCgwLUCTkY7bqr_mHFEPQdgojYoMmiRG6lsBVOicxdlcUFMkI2s0wv1Zgil3SsADm_qliypC5sX_XHjj9GdtjqZKcgC-n1aPlU7CuyFI9XRWkjo3AJSrzsmH4YWeECazBA793pOxiyerGIuAk9MQJjMl0Iz0IrS6EpqCko',
    status: MemberStatus.alreadyRegistered,
  ),
];
