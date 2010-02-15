require_dependency 'issue_observer'

# Adds the VersionDetails to the Version model
module IssueObserverWithFlag
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
    unloadable # Send unloadable so it will not be unloaded in development
      def before_create(issue)
        issue.is_new = true
      end
    end

  end

  module ClassMethods

  end

end