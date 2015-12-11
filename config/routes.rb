Rails.application.routes.draw do

  get 'templates/floating_menu'

  get 'billing_reports/payments' => 'billing_reports#payments', as: 'payments_datatable'
  get 'billing_reports/payments_summary' => 'billing_reports#payments_summary', as: 'payments_summary'
  get 'billing_reports/weekly_bills_summary'
  get 'billing_reports/receivables_summary'
  get 'bills/index_report_bills'
  get 'fetch_bill_paid_amount' => 'bills#fetch_bill_paid_amount', as: 'fetch_bill_paid_amount'

  resources :bonuses
  resources :payments
  resources :on_calls do
    resources :comments
  end
  resources :claim_types
  resources :payment_types
  resources :availabilities
  resources :insurance_companies
  resources :reimbursement_timesheets do
    resources :comments
  end

  get 'bills/delete_all_bills' => 'bills#delete_all_bills'
  resources :bills do
    resources :payments
    collection do
      post :import
      get :reports
      get :receivables
    end
  end

  resources :reports do
    member do
      get :generate_instance
      get :export
    end
    collection do
      get :get_form_fields
      get :get_field_aliases
      get :get_field_basic_types
    end
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_all_as_read
      get :mark_as_read
    end
  end

  resources :hour_types
  resources :hours do
    resources :comments
  end

  get 'show_patients_forms' => 'admin_patients#show_patients_forms', as: 'show_patients_forms'
  
  resources :admin_configurations, only: [:index, :update]

  namespace :admin do
    get :users
    put :update_users_roles_permissions
    get :patients
    put :update_patients_roles_permissions
    put :timesheets
    put :update_timesheets_roles_permissions
    get :visits
    put :update_visits_roles_permissions
    get :bills
    put :update_bills_roles_permissions
  end

  resources :coverage_areas

  resources :agencies

  resources :visits do
    resources :comments
    get :add_reimbursement
  end

  resources :visit_types

  resources :reimbursements

  resources :diseases

  resources :departments

  get 'reports/get_total_report'

  get 'create_timesheet' => "timesheets#create_timesheet", as: 'create_timesheet'

  # need to refactor engine routes
  mount CustomForms::Engine => '/'

  get 'timesheets/update_task_state', as: 'update_task_state'

  get 'timesheets/latest' => 'timesheets#show_latest', as: 'latest_timesheet'
  get 'employees_timesheets' => 'timesheets#employees_timesheets', as: 'employees_timesheets'
  
  resources :timesheets, only: [:index, :show, :update] do
    resources :comments
    member do
      put :submit
      put :admit
      put :pay
      get :send_email_to_owner
    end
  end
  put 'timesheets' => 'timesheets#index' 
  resources :payrolls do 
    member do
      get 'payroll_statistics/get_exceeded_employees', as: 'get_exceeded_employees'
      get 'payroll_statistics/show_employees_visits_per_patient', as: 'show_employees_visits_per_patient'
      get 'payroll_statistics/show_top_ten_employees', as: 'show_top_ten_employees'
      get 'payroll_statistics/show_employees_with_reimb', as: 'show_employees_with_reimb'
      get 'payroll_statistics/show_employees_with_over_time', as: 'show_employees_with_over_time'
      
    end
  end

  resources :roles

  resources :user_documents

  resources :document_types

  get 'admin/index'

  resources :license_types

  resources :job_types

  get "find_patients_matches" => "patients#find_patients_matches", as: "find_patients_matches"
  get 'patients/delete_all_patients' => 'patients#delete_all_patients', as: "delete_all_patients"
  resources :patients do
    put :update_forms, on: :member
    get :get_patient_data
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # scrapers
  get 'scrape_users' => 'users#scrape_users'
  get 'scrape_agencies' => 'agencies#scrape_agencies'
  get 'scrape_patients' => 'patients#scrape_patients'
  get 'scrape_visits' => 'visits#scrape_visits'

  root 'users#index'
  devise_for :users, controllers: { registrations: 'users' }
  resources :users, except: :destroy do
    put :update_forms, on: :member
    post :reset_password_via_email
    resources :timesheets, only: [:index, :show, :update] do
      member do
        put :submit
        put :admit
        put :pay
      end
    end
    member do
      post :deactivate_user
      post :activate_user
      put :update_password
    end
    resources :visits
  end

  get 'edit_roles' => 'users#edit_user_roles', as: 'edit_user_roles'
  put 'update_user_role' => 'users#update_user_role', as: 'update_user_role'

  get 'view_assigned_visits' => 'visits#view_assigned_visits', as: 'view_assigned_visits'
  get 'get_visit_type_dependant_data' => 'visit_types#get_visit_type_dependant_data', as: 'get_visit_type_dependant_data'

  get 'static_page/:page' => 'static#show'
  get 'show_comments' => 'visits#show_comments'

end
