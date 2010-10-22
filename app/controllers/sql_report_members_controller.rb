# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportMembersController < ApplicationController
  unloadable
  before_filter :authorize_global

  def new
    render_403 if !User.current.admin?
    render_404 if !SqlReport.exists? params[:id]
    @report = SqlReport.find params[:id]
    members = []
    if params[:member] && request.post?
      attrs = params[:member].dup
      if (user_ids = attrs.delete(:user_ids))
        user_ids.each do |user_id|
          members << SqlReportMember.new(attrs.merge(:principal_id => user_id))
        end
      else
        members << SqlReportMember.new(attrs)
      end
      @report.sql_report_members << members
    end
    respond_to do |format|
      if members.present? && members.all? {|m| m.valid? }

        format.html { redirect_to :controller => 'sql_reports', :action => 'settings', :tab => 'members', :id => @report }

        format.js { 
          render(:update) {|page| 
            page.replace_html "tab-content-members", :partial => 'sql_reports/members'
            page << 'hideOnLoad()'
            members.each {|member| page.visual_effect(:highlight, "member-#{member.id}") }
          }
        }
      else

        format.js {
          render(:update) {|page|
            errors = members.collect {|m|
              m.errors.full_messages
            }.flatten.uniq

            page.alert(l(:notice_failed_to_save_members, :errors => errors.join(', ')))
          }
        }
        
      end
    end
  end

  def autocomplete_for_member
    render_403 if !User.current.admin?
    render_404 if !SqlReport.exists? params[:id]
    report = SqlReport.find params[:id]
    @principals = Principal.active.like(params[:q]).find(:all, :limit => 100) - report.principals
      render :layout => false
  end

  def destroy
    render_403 if !User.current.admin?
    @member = SqlReportMember.find_by_sql_report_id_and_principal_id params[:sql_report_id], params[:principal_id]
    @report = @member.sql_report
    @member.destroy if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'sql_reports', :action => 'settings', :tab => 'members', :id => @report }
      format.js { 
        render(:update) {|page| 
          page.replace_html "tab-content-members", :partial => 'sql_reports/members'
          page << 'hideOnLoad()'
        }
      }
    end
  end
end 
