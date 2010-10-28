# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportMember < ActiveRecord::Base
  unloadable
  
  belongs_to :sql_report
  belongs_to :principal

  def after_create
    if principal.is_a?(Group)
      principal.users.each do |user|
        member = SqlReportMember.find :first, :conditions => {
          :sql_report_id => sql_report, :principal_id => user.id, :inherited_from => id }
        if (member == nil)
          member = SqlReportMember.new(:sql_report_id => sql_report, :principal_id => user.id, :inherited_from => id)
        else
          member.inherited_from = id
        end
        member.save!
      end
    end
  end
  
  def inherited?
    !inherited_from.nil?
  end
  
  def deletable?
    !inherited?
  end
  
  def <=>(member)
    principal <=> member.principal
  end
  
  def before_destroy
    children = SqlReportMember.find(:all, :conditions => { :inherited_from => id })
    if (children != nil)
      children.each {|child| child.destroy}
    end
  end
end

