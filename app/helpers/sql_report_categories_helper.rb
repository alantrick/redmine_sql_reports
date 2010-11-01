# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

module SqlReportCategoriesHelper
  def link_to_if_admin *args
    if User.current.admin
      link_to *args
    end
  end
end
