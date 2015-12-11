FactoryGirl.define do
  factory :custom_form, class: CustomForms::CustomForm do
  end

  factory :visits_custom_form, class: CustomForms::CustomForm do
    # title "visits"
    # # permissions: permissions,
    # association :form_category, factory: :visits_category
    # sections Hash.new {
    #         :"0"=>{
    #           title: "state",
    #           fields:{
    #             :"0" => {
    #               name: "state",
    #               type: "select",
    #               options: "paid, pending, unpaid",
    #               multivalue: "0",
    #               associated_model: "",
    #               associated_model_attr: "id"
    #             },
    #             :"1" => {
    #               name: "name",
    #               type: "text",
    #               options: "",
    #               multivalue: "0",
    #               associated_model: "",
    #               associated_model_attr: "id"
    #             },
    #             :"2" => {
    #               name: "date",
    #               type: "date",
    #               options: "",
    #               multivalue: "0",
    #               associated_model: "",
    #               associated_model_attr: "id"
    #             },
    #             :"3"=>{
    #               name: "activities",
    #               type: "select",
    #               options: "",
    #               required: "0",
    #               multivalue: "1",
    #               index_display: "0",
    #               associated_model: "",
    #               associated_form_attr: "['0']['name']",
    #               associated_custom_form: "activity"}
    #           # permissions: permissions,
    #         }
    #       }
    #     }
  end
end
