class AdminConfigurationsController < ApplicationController
  before_action :set_latest_payroll, only: [:index, :update]

  def index
    authorize! :administrate, Timesheet
    @admin_configurations = AdminConfiguration.all
  end

  def update
    authorize! :administrate, Timesheet
    @admin_configuration = AdminConfiguration.find(params[:id])
    respond_to do |format|
      if @admin_configuration.update(admin_configurations_params)
        format.html { redirect_to admin_configurations_path, flash: {success: 'Configuration was successfully updated. These configuration will be applied for the next payperiod.'} }
        format.json { render :show, status: :ok, location: admin_configurations_path }
      else 
        format.html { redirect_to admin_configurations_path, flash: {error: 'Configurations was not updated.'} }
        format.json { render json: 'Configurations was not updated.', status: :unprocessable_entity }
      end
    end
  end

  private

  def set_latest_payroll
    @latest_payroll = Payroll.last
  end

  def admin_configurations_params
    params.require(:admin_configuration).permit(configurations: [period: [:days, :hours], submission_allowance: [:days, :hours], admission_allowance: [:days, :hours]])
  end
end
