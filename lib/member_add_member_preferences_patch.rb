require_dependency 'member'

# Adds the VersionDetails to the Version model
module MemberPatch
  def self.included(base) # :nodoc:
    #base.extend(ClassMethods)

    base.send(:include, InstanceMethods)
    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
       has_one :preference, :dependent => :destroy, :class_name => 'MemberPreference'

    end

  end

  module InstanceMethods

    def pref
      self.preference ||= MemberPreference.new(:member => self)
    end

  def notify_when_member_id
    @notify_when_member_id ||= !pref[:notify_when_member_id].nil? ? pref[:notify_when_member_id] : []
  end

  end

end
