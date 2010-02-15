# Hooks to attach to the Redmine Projects.
class MailConfiguratorMembersTableHook < Redmine::Hook::ViewListener

  def protect_against_forgery?
    false
  end

  # Renders an additional table header to the membership setting
  #
  # Context:
  # * :project => Current project
  #
#  def view_projects_settings_members_table_header(context ={ })
#    return '' unless (User.current.allowed_to?(:edit_member_mail_preferences, context[:project]) || User.current.admin?)
#    return "<th>#{l(:mail_if)}</td>"
#  end


  # Context:
  # * :project => Current project
  # * :member => Current Member record
  #
#  def view_projects_settings_members_table_row(context = { })
#    member = context[:member]
#    project = context[:project]
#    members = project.members
#
#    return '' unless (User.current.allowed_to?(:edit_member_mail_preferences, project) || User.current.admin?)
#
#     render(:partial => "mail_configurator/mail_if", :object => {:members => members, :member => member, :project => @project})
#
#  end

#  def model_project_copy_before_save(context = {})
#    source = context[:source_project]
#    destination = context[:destination_project]
#
#    Rate.find(:all, :conditions => {:project_id => source.id}).each do |source_rate|
#      destination_rate = Rate.new
#
#      destination_rate.attributes = source_rate.attributes.except("project_id")
#      destination_rate.project = destination
#      destination_rate.save # Need to save here because there is no relation on project to rate
#    end
#  end

  end

