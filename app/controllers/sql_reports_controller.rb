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
    rescue Exception => e
      @error = e.message
    end
  end
  
  def edit
    render_403 if !User.current.admin
    @report = SqlReport.find(params[:id])
    if request.post? and @report.update_attributes(params[:report])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @report
    end
  end
   
  def add
    render_403 if !User.current.admin
    @report = SqlReport.new params[:report]
    if request.post?
      @report.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @report
    end
  end
end
