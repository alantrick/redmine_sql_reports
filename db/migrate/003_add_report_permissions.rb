# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class AddReportPermissions < ActiveRecord::Migration
  def self.up
    add_column :sql_reports, :public, :boolean, :default => 1
    create_table :sql_report_members, :id => false do |t|
      t.integer :principal_id
      t.integer :sql_report_id
    end
  end

  def self.down
    remove_column :sql_reports, :public
    drop_table :sql_report_members
  end
end
