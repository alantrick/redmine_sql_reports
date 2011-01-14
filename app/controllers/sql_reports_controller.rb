# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license
require 'csv'
require 'vendor/plugins/redmine_sql_reports/app/helpers/sql_reports_helper'

class SqlReportsController < ApplicationController
  include SqlReportsHelper
  unloadable
  before_filter :authorize_global
  
  def index
    @categories = SqlReportCategory.in_order
    @uncategorized = SqlReport.uncategorized.visible.in_order
  end
  
  def show
    @title = I18n.t(:report_title, {:report => @report})
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
    respond_to do |format|
      format.html
      format.csv do
        report = StringIO.new
        CSV::Writer.generate(report, ',') do |csv|
          csv << @table.columns.map { |col| report_header col }
          @table.rows do |row|
            csv << @table.columns.map { |col| row[col] }
          end
        end
        report.rewind
        send_data(report.read,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => "report-#{@report.id}.csv")
      end
    end
  end
  
  def edit
    render_403 if !User.current.admin
    render_404 if !SqlReport.exists? params[:id]
    @report = SqlReport.find params[:id]
    @categories = SqlReportCategory.in_order
    if request.post? and @report.update_attributes(params[:report])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @report
    end
  end
  
  def add
    render_403 if !User.current.admin
    @report = SqlReport.new params[:report]
    @categories = SqlReportCategory.in_order
    if request.post? and @report.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @report
    end
  end
  
  def destroy
    render_403 if !User.current.admin
    raise ActionController::NotImplemented if !request.post? # rails 405 wanabe
    render_404 if !SqlReport.exists? params[:id]
    SqlReport.delete params[:id]
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'index'
  end
end
