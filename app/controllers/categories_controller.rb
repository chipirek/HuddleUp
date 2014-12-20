class CategoriesController < ApplicationController


  load_and_authorize_resource :project
  load_and_authorize_resource :category, :through => :project


  def create
    @category = Category.new (params[:category])
    @category.project_id=params[:project_id]

    respond_to do |format|
      if @category.save
        format.html { redirect_to project_settings_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        # format.html { render action: "new" }
        format.html {
          flash[:error] = @category.errors.full_messages.first
          redirect_to project_settings_path
          }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to project_settings_path, notice: 'Category was successfully removed.' }
      format.json { head :no_content }
    end
  end


end
