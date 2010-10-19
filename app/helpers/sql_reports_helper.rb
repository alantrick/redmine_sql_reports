# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

module SqlReportsHelper
  def link_to_if_admin *args
    if User.current.admin
      link_to *args
    end
  end

  def report_header column
    if column =~ /^(\w+)\_id$/
      column = $1
    end
    return column.split(/[\s_]+/).map{|s| s.capitalize}.join ' '
  end
  
  def report_cell column, data
    if column =~ /^([A-Z]\w+)$/
      return link_model $1, data
    elsif column =~ /^(\w+)\_id$/
      # go from under_scores to CamelCase
      classname = $1.split('_').map{|s| s.capitalize}.join
      return link_model classname, data
    else
      return data
    end
  end
  
  def link_model classname, data
    begin
      cls = Kernel.const_get(classname)
      d = cls.find(data)
      # using cls.table_name for the controller name is a hack,
      # but I think it works and I don't know a better way to access the
      # controller
      return link_to d.to_s, {:controller => cls.table_name, :action => 'show', :id => data}
    rescue NameError, LoadError, NoMethodError
      return data
    end
  end
end


class MySQLResult
  def initialize(stmt)
    @stmt = stmt.execute
    @columns = @stmt.result_metadata.fetch_fields.map { |f| f.name }
  end
  
  def columns
    @columns
  end
  
  def rows
    row = @stmt.fetch
    while row != nil
      yield Hash[*columns.zip(row).flatten]
      row = @stmt.fetch
    end
  end
end
class SQLiteResult
  def initialize(result)
    @res = result.execute
  end
  
  def columns
    @res.columns
  end
  
  def rows
    for row in @res
      yield row
    end
  end
end
