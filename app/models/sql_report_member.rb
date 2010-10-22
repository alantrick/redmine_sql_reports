# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportMember < ActiveRecord::Base
  unloadable
  
  belongs_to :sql_report
  belongs_to :principal

  def <=>(member)
    principal <=> member.principal
  end
  def destroy
    self.class.delete_all(:sql_report_id => sql_report, :principal_id => principal)
  end
end

