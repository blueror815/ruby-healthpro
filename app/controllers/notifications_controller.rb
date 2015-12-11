class NotificationsController < ApplicationController

  def index
    @notifications = Notification.of(current_user).where.not(action: 'submit').where.not(action: 'admit_notify_payers') 
    @submission_notifications = Notification.of(current_user).where(action: 'submit')
    @admission_notifications = Notification.of(current_user).where(action: 'admit_notify_payers')
  end

  def mark_all_as_read
    Notification.mark_all_as_read! for: current_user
    respond_to do |format|
      format.js
    end
  end

  def mark_as_read
    notifications = Notification.where(id: params[:notification_ids])
    Notification.mark_as_read! notifications
    respond_to do |format|
      format.html { redirect_to params[:redirect_path] }
    end
  end

  private
    def notification_params
      params.require(:notification).permit(:sender_id, :receiver_id, :notifiable_id, :notifiable_type, :redirect_path)
    end
end
