class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_layout
  before_action :load_people_reports
  
  def load_people_reports
    @people_reports = Report.select{ |c| c.category== "HR"}
  end
  
  def notify(notifiable, receivers, action = action_name)
    Array(receivers).each do |receiver|
      notification = Notification.create(notifiable: notifiable, action: action, 
      receiver: receiver)
      notification.senders << current_user
      notification.save
    end
  end

  def notify_users_for_comment(notifiable, receivers, action = action_name)
    Array(receivers).each do |receiver|
      notification = Notification.joins("INNER JOIN comments ON comments.id = notifications.notifiable_id").
      where('comments.commentable_id' => notifiable.commentable.id, action: action, 
        receiver: receiver).unread.first_or_create(notifiable: notifiable)
      if !notification.senders.include?(current_user)
        notification.senders << current_user
        notification.save
      else
        #touch notification to show last commenter avatar and sort notifications
        notification.user_notifications.find_by(sender: current_user).touch
        notification.touch
      end
    end
  end

  private
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path, flash: { error: exception.message }
    end

    def set_layout
      @controller_names = ['roles', 'agencies', 'job_types', 'departments', 'coverage_areas', 
        'visit_types', 'hour_types']
      if @controller_names.include? controller_name
        if action_name == 'edit' || action_name == 'update'
          @partial = 'layouts/edit'
        elsif action_name == 'index'
          @partial = 'layouts/card_index'
        elsif action_name == 'new' || action_name == 'create'
          @partial = 'layouts/new'
        end
      end
    end

      #TODO_PROHEALTH refactor this method duplication 
    def forms_fields(form, action)
      section_fields = []
      form.form_sections.each do |section|
        if section['permissions']["#{current_user.role.short_name}"]
          if section['permissions']["#{current_user.role.short_name}"][action] == '1'
            section_fields << section.section_fields.map do |field|
              if field.field_type.field_type.start_with?('select') && field.field_type.options['multivalue'] == '1'
                { field.id.to_s.to_sym => [] }
              else
                field.id.to_s.to_sym
              end
            end
          end
        end
      end
      section_fields
    end

    def set_user_form_authorization
      @action = if ['new', 'update_forms'].include? action_name
                  'create'
                elsif ['update', 'destroy'].include? action_name
                  'edit'
                else
                  action_name
                end
    end

    def set_date_interval_params
      
      params[:from] = fix_date_param(:from, Date.today.beginning_of_week) 
      params[:to] = fix_date_param(:to, Date.today.end_of_week)
    end

    def fix_date_param key, date
     
      date = params[key] ? params[key] : date
      params[key] = fix_date_format(date)
    end

    def fix_date_format date
      if date.class == Date
        date
      elsif date.class == String
        
        begin
          Date.strptime(date, "%m-%d-%Y")
        rescue ArgumentError
          Date.strptime(date, "%Y-%m-%d") 
        end
      end
    end
end
