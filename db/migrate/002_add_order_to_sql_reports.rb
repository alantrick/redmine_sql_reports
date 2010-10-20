# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class AddOrderToSqlReports < ActiveRecord::Migration
  def self.up
    add_column :sql_reports, :order, :int
  end

  def self.down
    remove_column :sql_reports, :order
  end
end
