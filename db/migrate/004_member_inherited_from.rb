# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class MemberInheritedFrom < ActiveRecord::Migration
  def self.up
    add_column :sql_report_members, :id,  :primary_key
    add_column :sql_report_members, :inherited_from, :integer
  end
  def self.down
    remove_column :sql_reports, :id
    remove_column :sql_reports, :inherited_from
  end
end
