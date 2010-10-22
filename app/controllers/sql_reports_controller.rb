# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportsController < ApplicationController
  unloadable
  before_filter :authorize_global
  
  def index
    @reports = SqlReport.visible.find_in_order
  end
  
  def show
    render_404 if !SqlReport.exists? params[:id]
    @report = SqlReport.find params[:id]
    render_403 if !@report.visible? User.current
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
    render_404 if !SqlReport.exists? params[:id]
    @report = SqlReport.find params[:id]
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
  
  def destroy
    render_403 if !User.current.admin
    # rails 405 wanabe
    raise ActionController::NotImplemented if !request.post?
    render_404 if !SqlReport.exists? params[:id]
    SqlReport.delete params[:id]
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'index'
  end
end
