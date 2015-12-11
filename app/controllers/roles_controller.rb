class RolesController < ApplicationController
  helper CustomForms::Engine.helpers
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :set_permissions, only: [:new, :show, :edit, :update]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
    @instances = @roles
    @model = 'role'
    @icon = 'fa-cogs'
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
    set_html_elements
  end

  # GET /roles/1/edit
  def edit
    @instance = @role
    @model = 'role'
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, flash: { success: 'Role was successfully created.' } }
        format.json { render :show, status: :created, location: @role }
      else
        set_html_elements
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_path, flash: { success: 'Role was successfully updated.' } }
        format.json { render :show, status: :ok, location: @role }
      else
        set_html_elements
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, flash: { success: 'Role was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
  def set_html_elements
    @instance = @role
    @model = 'role'
    @id = Role.count
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_permissions
    @permissions = Permission.all
    @role_permission = @role.try(:permission_ids) || []
  end

  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name, :short_name)
  end
end
