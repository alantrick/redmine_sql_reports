# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class CreateCategories < ActiveRecord::Migration
  def self.up
    add_column :sql_reports, :category_id, :integer, :null => true
    create_table :sql_report_categories do |t|
      t.string :name
      t.integer :order
    end
  end

  def self.down
    remove_column :sql_reports, :public
    drop_table :sql_report_categories
  end
end
