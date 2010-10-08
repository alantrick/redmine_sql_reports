# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class CreateSqlReports < ActiveRecord::Migration
  def self.up
    create_table :sql_reports do |t|
      t.column :title, :text
      t.column :query, :text
    end
  end

  def self.down
    drop_table :sql_reports
  end
end
