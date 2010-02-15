require_dependency 'issue'

module MailConfiguratorIssuePatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        
            base.class_eval do
                attr_accessor :is_new
                alias_method_chain :recipients, :mail_configurator
            end
      end

    
    module InstanceMethods

      #Helping function TODO:  Create as output_array = recipiens (with no return)
      def add_mails_to_recipients(output_array, input_array)
          input_array.each do |m|
            output_array.push(m.user.mail)
          end
        return output_array = output_array.flatten.compact.uniq
      end

      def add_user_blocking_preferences_to_mails_list(list)
        # This will remove mail notification for all projects (and at any conditions) for users that selected blocking option
          withdrawned_mails = @members.select { |m| m.user.pref[:block_mail_notification]== true }.collect {|m| m.user.mail}
          # This is mail blocker for users that don't want to be notificated if they are not assigned to issue
          only_if_assigned_option_mails = @members.select { |m| m.user.pref[:assigned_only_mail_notification] == true }.collect {|m| m.user.mail}
          list = list - only_if_assigned_option_mails
          list << assigned_to.mail if assigned_to && assigned_to.active?
          list = list - withdrawned_mails
          list = list.compact.uniq

      end

        def recipients_with_mail_configurator

          @members = project.members
          #Redmine core recipients
          recipients = recipients_without_mail_configurator
          #User preferences based customistation
          recipients = add_user_blocking_preferences_to_mails_list(recipients)
          
          @ext_members = []
          @members.each do |member|
            @ext_members << member if defined?(member.pref) && member.pref[:notify_when_member_id].is_a?(Array)
          end
          
          # Memeber preferences based notifications
          if !@ext_members.empty?
            mail_me_if_new_issue = []
              if !self.is_new.nil?
                mail_me_if_new_issue = @ext_members.select { |m| (m.pref[:notify_when_new_issue_created] == '1') }
              end
            recipients = add_mails_to_recipients(recipients, mail_me_if_new_issue) unless mail_me_if_new_issue.empty?

            @assigned_member = !assigned_to.nil? ? @ext_members.select {|m| m.user.id == (assigned_to.id)}.first.id.to_s : 'none'
            mail_me_if_assigned_to = []
            @ext_members.each do |member|
              if member.pref[:assigned_notification] == '1' && !(member.pref[:notify_when_member_id].select {|p| p == @assigned_member}).empty?
                mail_me_if_assigned_to << member
              end
            end
            recipients = add_mails_to_recipients(recipients, mail_me_if_assigned_to) unless mail_me_if_assigned_to.empty?

            #List of members that need to replace thier mails
            members_custom_mails_list = @ext_members.select { |m| m.pref[:custom_mail_adress] if !m.pref[:custom_mail].nil? }

            if !members_custom_mails_list.empty? && !recipients.empty?
              #List of membres with custom mails and in recipients array
              @list = []

              recipients.each do |email|
              @list << members_custom_mails_list.select {|member_with_custom_mail| member_with_custom_mail.user.mail == email}
              #recipients.delete(email)
              end
              @list = @list.flatten.compact.uniq

              #Add custom mails list to the recipents
              if !@list.empty?
                @list.each do |m|
                  recipients.delete(m.user.mail)
                  recipients << m.pref[:custom_mail_adress]
                end
                recipients = recipients.flatten.compact.uniq;
              end
            end
          end # Memeber preferences based notifications end
         # recipients << '' if recipients.empty? 
          recipients.delete_if {|m| m.empty? }
          return recipients
        end
    end
end
