# Copyright (C) 2010 Alan Trick, Trinity Western University
# see COPYING for license

class SqlReportCategoriesController < ApplicationController
  unloadable
  before_filter :authorize_global

  def index
    @categories = SqlReportCategory.find_in_order
  end
  
  def add
    render_403 if !User.current.admin?
    @cat = SqlReportCategory.new params[:category]
    
    if request.post?
      if @cat.save
        respond_to do |format|
          format.html do
            flash[:notice] = l(:notice_successful_create)
            redirect_to :controller => 'sql_report_categories', :action => 'index'
          end
          format.js do
            # IE doesn't support the replace_html rjs method for select box options
            render(:update) {|page| page.replace "sql_report_category_id",
              content_tag('select', '<option></option>' +
                options_from_collection_for_select(@report.categories, 'id', 'name', @cat.id),
                  :id => 'sql_report_category_id', :name => 'report[category_id]'
              )
            }
          end
        end
      else
        respond_to do |format|
          format.html
          format.js do
            render(:update) {|page| page.alert(@cat.errors.full_messages.join('\n')) }
          end
        end
      end
    end
  end
  
  def edit
    render_403 if !User.current.admin
    @cat = SqlReportCategory.find_by_id params[:id]
    render_404 if @cat == nil
    if request.post? and @cat.update_attributes(params[:category])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    end
    
  end

  def destroy
    render_403 if !User.current.admin
    @cat = SqlReportCategory.find_by_id params[:id]
    render_404 if @cat == nil
    @cat.destroy if request.post?
    
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js { 
        render(:update) {|page| 
          @categories = SqlReportCategory.find_in_order
          page.replace_html "category-table", :partial => 'sql_report_categories/table'
          page << 'hideOnLoad()'
        }
      }
    end
  end
end 
