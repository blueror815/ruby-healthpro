CustomForms::Engine.routes.draw do
  resources :custom_forms do
    resources :form_data
  end

  resources :form_data do
    resources :comments, only: :create, controller: '/comments'
  end

  resources :form_sections, only: [:destroy]
  
  resources :section_fields, only: [:destroy] do
    post :update_row_order, on: :collection
  end

  resources :field_types

  resources :form_categories

  resources :forms, only: [:index, :show]

  get 'get_model_attributes' => 'custom_forms#get_model_attributes'
  get 'get_form_attributes' => 'custom_forms#get_form_attributes'
end
