import 'package:flutter/material.dart';

class FamilyMemberModel {
  final String id;
  final String name;
  final String role; // 'Chủ hộ' or 'Thành viên'
  final String avatarLetter;
  final Color avatarBgColor;
  final bool isOwner;
  final bool isCurrentUser;
  final DateTime joinedDate;

  const FamilyMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarLetter,
    required this.avatarBgColor,
    this.isOwner = false,
    this.isCurrentUser = false,
    required this.joinedDate,
  });

  FamilyMemberModel copyWith({
    String? id,
    String? name,
    String? role,
    String? avatarLetter,
    Color? avatarBgColor,
    bool? isOwner,
    bool? isCurrentUser,
    DateTime? joinedDate,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarLetter: avatarLetter ?? this.avatarLetter,
      avatarBgColor: avatarBgColor ?? this.avatarBgColor,
      isOwner: isOwner ?? this.isOwner,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

class FamilyGroupModel {
  final String id;
  final String name;
  final int maxMembers;
  final bool isPremium;
  final List<FamilyMemberModel> members;

  const FamilyGroupModel({
    required this.id,
    required this.name,
    this.maxMembers = 2,
    this.isPremium = false,
    required this.members,
  });

  int get currentCount => members.length;
  bool get isFull => currentCount >= maxMembers;

  FamilyGroupModel copyWith({
    String? id,
    String? name,
    int? maxMembers,
    bool? isPremium,
    List<FamilyMemberModel>? members,
  }) {
    return FamilyGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
      isPremium: isPremium ?? this.isPremium,
      members: members ?? this.members,
    );
  }
}
