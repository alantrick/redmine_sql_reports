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
      sql_quote(arg.to_s)
    end
    return connection.select_all expanded_query
  end
  
  def sql_quote(str)
    str.gsub(/\\|'/) { |c| "\\#{c}" }
  end

end
