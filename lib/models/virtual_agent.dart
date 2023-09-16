class VirtualAgent {
  final String id;
  final String? avatar;
  final String name;
  final String themeColor;
  final String? replyLanguage;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool? workspaceRequiredLogin;
  final bool? isTicketEnable;
  final String workspaceId;

  VirtualAgent(
      {required this.id,
      this.avatar,
      required this.name,
      required this.themeColor,
      this.replyLanguage,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.workspaceRequiredLogin,
      this.isTicketEnable,
      required this.workspaceId});
}
