# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

module SqlReportsHelper

    def report_header column
      if column =~ /(\w+)\_id$/
        return $1.capitalize
      end
      return column
    end
    
    # TODO: this is super hackish and the current behavior will probably go away
    # soon
    def report_cell column, data
      if column =~ /(\w+)\_id$/
        case $1
        when 'user'
          d = User.find(data)
          return link_to d.to_s, {:controller => "users", :action => 'show', :id => data}
        when 'project'
          d = Project.find(data)
          return link_to d.to_s, {:controller => "projects", :action => 'show', :id => data}
        when 'issue'
          d = Issue.find(data)
          return link_to d.to_s, {:controller => "issues", :action => 'show', :id => data}
        when 'version'
          d = Version.find(data)
          return link_to d.to_s, {:controller => "versions", :action => 'show', :id => data}
        end
      end
      return data
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
