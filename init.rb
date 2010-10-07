# Redmine SQL Reports
# Copyright (C) 2010 Alan Trick, Trinity Western University

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'redmine'

Redmine::Plugin.register :redmine_sql_reports do
  name 'Redmine Sql Reports plugin'
  author 'Alan Trick'
  description 'Allows the creation of reports using arbitrary SQL'
  version '0.1.0'
  url 'http://example.com/path/to/plugin'
  author_url 'https://tricks.webfactional.com/trick'
  
  permission :view_reports, {:sql_reports => [:index, :show]}, :require => :loggedin
  
  menu :top_menu, :redmine_sql_reports, {:controller => :sql_reports, :action => 'index'},
    :caption => :sql_reports_title
end
