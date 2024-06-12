// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) => Workspace(
      id: json['id'] as String,
      companyName: json['company_name'] as String?,
      customTicketDomain: json['custom_ticket_domain'] as String?,
      logo: json['logo'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$WorkspaceToJson(Workspace instance) => <String, dynamic>{
      'id': instance.id,
      'logo': instance.logo,
      'name': instance.name,
      'company_name': instance.companyName,
      'custom_ticket_domain': instance.customTicketDomain,
    };

Bot _$BotFromJson(Map<String, dynamic> json) => Bot(
      id: json['id'] as String,
      avatar: json['avatar'] as String?,
      name: json['name'] as String,
      themeColor: json['theme_color'] as String?,
      replyLanguage: json['reply_language'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      workspaceRequiredLogin: json['workspace_required_login'] as bool?,
      isTicketEnable: json['is_ticket_enable'] as bool?,
      workspaceId: json['workspace_id'] as String?,
      workspace: json['workspace'] == null
          ? null
          : Workspace.fromJson(json['workspace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BotToJson(Bot instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'name': instance.name,
      'workspace': instance.workspace,
      'theme_color': instance.themeColor,
      'reply_language': instance.replyLanguage,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'workspace_required_login': instance.workspaceRequiredLogin,
      'is_ticket_enable': instance.isTicketEnable,
      'workspace_id': instance.workspaceId,
    };
