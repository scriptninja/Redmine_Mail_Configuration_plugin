
begin
require_dependency 'application'
rescue LoadError
end
require_dependency 'my_controller'



module MailConfiguratorMyControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      after_filter :save_additional_prefereces_from_view, :only => [:account]
    end

  end
end

module InstanceMethods
  def save_additional_prefereces_from_view
      if request.post? && flash[:notice] == l(:notice_account_updated)
        #Params for mail notification
        # - block entirely mail notification
        User.current.pref[:block_mail_notification] = (params[:block_mail_notification] == '1')
        # - mail only if assigned.
        User.current.pref[:assigned_only_mail_notification] = (params[:assigned_only_mail_notification] == '1')
        User.current.pref.save
      end
  end
end

