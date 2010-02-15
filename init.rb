require 'redmine'
begin
require 'config/initializers/session_store.rb'
rescue LoadError
end

# Patches to the Redmine core.  Will not work in development mode
require 'dispatcher'
require 'add_new_issue_flag_to_issue_observer_patch'
require 'issue_mail_recipients_patch'
require 'member_add_member_preferences_patch'
require 'my_controller_add_mail_preferences_patch'

Dispatcher.to_prepare do
  Issue.send(:include, MailConfiguratorIssuePatch)
  Member.send(:include, MemberPatch)
  MyController.send(:include, MailConfiguratorMyControllerPatch)
  IssueObserver.send(:include, IssueObserverWithFlag)
end


# Hooks
require 'account_view_mail_checkboxes_hook'
#require 'project_members_view_add_col_hook'

Redmine::Plugin.register :redmine_mail_configurator do
  name 'Redmine Mail Configurator plugin'
  author 'Marek Kreft'
  description 'This plugin adds new options (restrictions) to prevent sending mails if not needed'
  version '0.1.0'


  requires_redmine :version_or_higher => '0.9.0'

end
