# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportCategory < ActiveRecord::Base
  belongs_to :sql_report
  has_many :sql_reports, :foreign_key => 'category_id', :dependent => :nullify

  named_scope :in_order, :order => connection.quote_column_name('order') + ', name'
  validates_presence_of :name
  validates_length_of :name, :maximum => 30

  def to_s; name end

end 
