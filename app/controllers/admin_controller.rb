class AdminController < ApplicationController

  def users
    authorize! :administrate, User
    @hr_category = FormCategory.find_by(name: 'HR')
    @hr_forms = CustomForms::CustomForm.where(form_category_id: @hr_category)
    set_permissions('User')
  end

  def update_users_roles_permissions
    authorize! :administrate, User
    new_permissions = []
    params[:roles].each do |k, v|
      existing_permissions = Role.find(k).permission_ids
      existing_permissions.select! do |permission_id|
        Permission.find(permission_id).object_type != 'User'
      end
      new_permissions << {permission_ids: (existing_permissions << v.keys.select{|key| v[key]=="1" }).flatten }
    end
    roles_permissions = Role.update(params[:roles].keys, new_permissions).reject { |p| p.errors.empty? }
    respond_to do |format|
      if roles_permissions.empty?
        format.html {redirect_to admin_users_path, flash: {success: 'Roles permissions was successfully updated.'}}
      else
        format.html {render action: 'users'}
      end
    end
  end
  
  def patients
    authorize! :administrate, Patient
    @patient_category = FormCategory.where(name: 'Patient').first
    @patient_forms = CustomForms::CustomForm.where(form_category_id: @patient_category)
    set_permissions('Patient')
  end

  def update_patients_roles_permissions
    authorize! :administrate, Patient
    new_permissions = []
    params[:roles].each do |k, v|
      existing_permissions = Role.find(k).permission_ids
      existing_permissions.select! do |permission_id|
        Permission.find(permission_id).object_type != 'Patient'
      end
      new_permissions << {permission_ids: (existing_permissions << v.keys.select{|key| v[key]=="1" }).flatten }
    end
    roles_permissions = Role.update(params[:roles].keys, new_permissions).reject { |p| p.errors.empty? }
    respond_to do |format|
      if roles_permissions.empty?
        format.html {redirect_to admin_patients_path, flash: {success: 'Roles permissions was successfully updated.'}}
      else
        format.html {render action: 'patients'}
      end
    end
  end

  def timesheets
    authorize! :administrate, Timesheet
    set_permissions('Timesheet')
  end

  def update_timesheets_roles_permissions
    authorize! :administrate, Timesheet
    new_permissions = []
    params[:roles].each do |k, v|
      existing_permissions = Role.find(k).permission_ids
      existing_permissions.select! do |permission_id|
        Permission.find(permission_id).object_type != 'Timesheet'
      end
      new_permissions << {permission_ids: (existing_permissions << v.keys.select{|key| v[key]=="1" }).flatten }
    end
    roles_permissions = Role.update(params[:roles].keys, new_permissions).reject { |p| p.errors.empty? }
    respond_to do |format|
      if roles_permissions.empty?
        format.html {redirect_to admin_timesheets_path, flash: {success: 'Roles permissions was successfully updated.'}}
      else
        format.html {render action: 'timesheets'}
      end
    end
  end

  def visits
    authorize! :administrate, Visit
    set_permissions('Visit')
  end

  def update_visits_roles_permissions
    authorize! :administrate, Visit
    new_permissions = []
    params[:roles].each do |k, v|
      existing_permissions = Role.find(k).permission_ids
      existing_permissions.select! do |permission_id|
        Permission.find(permission_id).object_type != 'Visit'
      end
      new_permissions << {permission_ids: (existing_permissions << v.keys.select{|key| v[key]=="1" }).flatten }
    end
    roles_permissions = Role.update(params[:roles].keys, new_permissions).reject { |p| p.errors.empty? }
    respond_to do |format|
      if roles_permissions.empty?
        format.html {redirect_to admin_visits_path, flash: {success: 'Roles permissions was successfully updated.'}}
      else
        format.html {render action: 'Visit'}
      end
    end
  end

  def bills
    authorize! :administrate, Bill
    set_permissions('Bill')
  end

  def update_bills_roles_permissions
    authorize! :administrate, Bill
    new_permissions = []
    params[:roles].each do |k, v|
      existing_permissions = Role.find(k).permission_ids
      existing_permissions.select! do |permission_id|
        Permission.find(permission_id).object_type != 'Bill'
      end
      new_permissions << {permission_ids: (existing_permissions << v.keys.select{|key| v[key]=="1" }).flatten }
    end
    roles_permissions = Role.update(params[:roles].keys, new_permissions).reject { |p| p.errors.empty? }
    respond_to do |format|
      if roles_permissions.empty?
        format.html {redirect_to admin_bills_path, flash: {success: 'Roles permissions was successfully updated.'}}
      else
        format.html {render action: 'Bill'}
      end
    end
  end

  private
  def set_permissions(object_type)
    @roles = Role.includes(:permissions)
    @permissions = Permission.where(object_type: object_type)

    @roles_permissions = {}
    @roles.each do |role|
      role_permissions = {}
      selected_permission_ids = role.try(:permission_ids)
      @permissions.each do |permission|
        role_permissions[permission.id.to_s] = selected_permission_ids.include?(permission.id) ? 1 : 0
      end
      @roles_permissions[role.id.to_s] = role_permissions
    end
  end
end
