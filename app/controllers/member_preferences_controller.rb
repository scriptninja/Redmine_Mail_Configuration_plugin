# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU GeSSneral Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class MemberPreferencesController < ApplicationController
  before_filter :find_member

  def edit
    if request.post? and User.current.allowed_to?(:manage_members, @project)
          @member.pref[:notify_when_new_issue_created] = params["for_new_issue_created_#{@member.id}"]

          @member.pref[:assigned_notification] = params["issue_assigned_to_#{@member.id}"]
          if (@member.pref[:assigned_notification] == '1' && !params["notified_when_members_ids"].nil?)
            @member.pref[:notify_when_member_id] = params["notified_when_members_ids"]
          else
            @member.pref[:assigned_notification] = false
            @member.pref[:notify_when_member_id] = []
          end

          @member.pref[:custom_mail] = params["custom_mail_select_#{@member.id}"]
          if (@member.pref[:custom_mail] == '1')
            @member.pref[:custom_mail_adress] = params["member_custom_mail_#{@member.id}"]
          end

        @member.pref.save
         respond_to do |format|
            format.html { redirect_to :controller => 'projects', :action => 'settings', :tab => 'members', :id => @project }
            format.js {
              render(:update) {|page|
                page.replace_html "tab-content-members", :partial => 'projects/settings/members'
                page.visual_effect(:highlight, "member-#{@member.id}")
              }
            }
          end
      end
    end

  private

  def find_member
    @member = Member.find(params[:id])
    @project = @member.project
    rescue ActiveRecord::RecordNotFound
    render_404
  end
  
end
