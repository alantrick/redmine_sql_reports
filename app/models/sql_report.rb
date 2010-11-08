# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReport < ActiveRecord::Base
  unloadable
  has_many :sql_report_members
  has_many :principals, :through => :sql_report_members
  belongs_to :category, :class_name=>'SqlReportCategory', :foreign_key => 'assigned_to_id'
  
  validates_presence_of :title
  validates_presence_of :query
  
  named_scope :in_order, :order => connection.quote_column_name('order') + ', title'
  named_scope :visible, lambda { { :conditions => SqlReport.visible_by(User.current) } }
  named_scope :uncategorized, :conditions => ['category_id IS ?', nil]
  
  def self.visible_by(user)
    return {} if user.admin? # no constraints for admin
    sms = SqlReportMember.find(:all, :conditions => {:principal_id => user })
    report_ids = sms.map { |sm| sm.sql_report_id }
    constraint = "public = #{connection.quoted_true}"
    constraint = ["id IN (?) OR " + constraint, report_ids] if report_ids.any?
    return constraint
  end
  
  def visible?(user)
    return true if user.admin? or public
    return SqlReportMember.find(:all, :conditions =>
      {:principal_id=> user, 'sql_report_id' =>id}).any?
  end
  
  def run_query(params)
    # make copy of query to expand arguments
    expanded_query = String.new query
    
    expanded_query.gsub!(/\{(\w+)(?:\:([^\}]*))?\}/) do
      arg = params[$1] == nil ? $2 : params[$1]
      if arg == nil
        raise ArgumentError,
          'Parameter %s not provided, and no default available' % $1
      end
      connection.quote(arg.to_s)
    end
    
    stmt = connection.raw_connection.prepare expanded_query
    
    adapters = {'MySQL' => MySQLResult, 'SQLite' => SQLiteResult}
    cls = adapters[connection.adapter_name]
    if cls == nil
      raise NotImplementedError,
        "Unsupported database '%s'" % connection.adapter_name
    end
    return cls.new stmt
  end
  
  def to_s
    title
  end
end

