# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReport < ActiveRecord::Base
  unloadable
  
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

