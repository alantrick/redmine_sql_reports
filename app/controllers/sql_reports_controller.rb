# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportsController < ApplicationController
  unloadable
  before_filter :authorize_global
  def index
    @reports = SqlReport.find(:all)
  end
  
  def show
    @report = SqlReport.find(params[:id])
    args = {'user_id' => session[:user_id]}
    @error = "The report returned no results"
    @table = []
    begin
      @table = @report.run_query(args)
    rescue ArgumentError => e
      @error = e.message
    end
  end
end
