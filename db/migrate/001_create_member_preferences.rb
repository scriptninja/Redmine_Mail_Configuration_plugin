class CreateMemberPreferences < ActiveRecord::Migration
  def self.up
    create_table :member_preferences do |t|
      t.column "member_id", :integer, :default => 0, :null => false
      t.column "others", :text
    end
  end

  def self.down
    drop_table :member_preferences
  end
end