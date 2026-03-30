import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/family_member_model.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/member_list_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/member_list_item.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/member_list_bottom_bar.dart';
import 'package:alai_oosai/features/auth/presentation/screens/register/register_send_otp_screen.dart';
import 'package:alai_oosai/features/auth/data/family_member_service.dart';

class FamilyMemberListScreen extends StatefulWidget {
  final String villageId;
  final String familyCardNumber;

  const FamilyMemberListScreen({
    super.key,
    required this.villageId,
    required this.familyCardNumber,
  });

  @override
  State<FamilyMemberListScreen> createState() => FamilyMemberListScreenState();
}

class FamilyMemberListScreenState extends State<FamilyMemberListScreen> {
  List<FamilyMemberModel> members = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  void _fetchMembers() async {
    // Use the passed villageId as query param
    final familyId = widget.familyCardNumber;
    final villageId = widget.villageId;
    try {
      final fetched = await FamilyMemberService.fetchMembers(
        familyId: familyId,
        villageId: villageId,
      );
      setState(() {
        members = fetched;
        final preSelected = members.indexWhere(
          (m) => m.status == MemberStatus.selected,
        );
        _selectedIndex = preSelected != -1 ? preSelected : null;
      });
    } catch (e) {
      // Handle error (show snackbar, etc.)
      setState(() {
        members = [];
        _selectedIndex = null;
      });
    }
  }

  FamilyMemberModel? get _selectedMember =>
      _selectedIndex != null ? members[_selectedIndex!] : null;

  void _onMemberTap(int index) {
    final member = members[index];
    if (member.status == MemberStatus.alreadyRegistered) return;
    setState(() {
      if (_selectedIndex != null && _selectedIndex != index) {
        members[_selectedIndex!] = members[_selectedIndex!].copyWith(
          status: MemberStatus.selectable,
        );
      }
      if (_selectedIndex == index) {
        members[index] = member.copyWith(status: MemberStatus.selectable);
        _selectedIndex = null;
      } else {
        members[index] = member.copyWith(status: MemberStatus.selected);
        _selectedIndex = index;
      }
    });
  }

  void _onContinue() {
    if (_selectedMember == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterSendOtpScreen(
          selectedMembers: [_selectedMember!],
          familyCardNumber: widget.familyCardNumber,
          villageId: widget.villageId,
          userId: _selectedMember!.id,
        ),
      ),
    );
  }

  void _onSkip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterSendOtpScreen(
          selectedMembers: [],
          familyCardNumber: widget.familyCardNumber,
          villageId: widget.villageId,
          userId: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      AuthHeader(
                        title: 'Trusted Sentinel',
                        trailingWidget: const Text(
                          'SECURE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AuthColors.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: MemberListHeader(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MemberListItem(
                          member: members[index],
                          onTap: () => _onMemberTap(index),
                        ),
                      ),
                      childCount: members.length,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MemberListBottomBar(
                selectedCount: _selectedMember != null ? 1 : 0,
                continueLabel: _selectedMember != null
                    ? 'Continue with ${_selectedMember!.name}'
                    : null,
                onContinue: _onContinue,
                onSkip: _onSkip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
