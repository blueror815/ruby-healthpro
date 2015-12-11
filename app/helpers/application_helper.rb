module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def reimbursement_title(r)
    if r.reimbursement.value_type == 1
      r.reimbursement.title
    elsif r.reimbursement.value_type == 2
      "#{r.reimbursement.title} x#{r.action_count}"
    else
      "#{r.reimbursement.title} #{number_to_currency(r.amount)}"
    end
  end

  def state_badge (state)
    if state == "approved"
      content_tag :span, nil, class: "badge style-success" do
        content_tag :i, nil, class: "fa fa-check"
      end
    elsif state == ("pending" || "submitted")
      content_tag :span, nil, class: "badge style-warning" do
        content_tag :i, nil, class: "fa fa-question"
      end
    elsif state == "rejected"
      content_tag :span, nil, class: "badge style-danger" do
        content_tag :i, nil, class: "fa fa-times"
      end
    end
  end

  def is_active items
    items = items.map{ |item| item[:url]}
    m = request.path.match ".*(#{items.join '|'})"
    m and request.path.end_with? m[0]
  end

  def sidebar_folder_item url, title
    render partial: 'layouts/sidebar_folder_item', locals: {folder_item_path: url, folder_item_title: title}
  end

  # this method returns an arry attributs etc used for select options 
  # it takes tow paramteters 
  # first parameter (required) the model name 
  # second parameter (optional) the expression that would be used to retrieve the label of the object, by default it uses the name attribute 
  def model_options(model_name, label_expression = "instance.try(:name)")
    model_options = []
    model_name.find_each{ |instance| model_options << { label: eval(label_expression), value: "#{instance.id}" } }
    model_options.to_json
  end

  def patient_model_options
    model_options = []
    Patient.find_each{ |instance| model_options << { label: "#{instance.try(:display_name)}", value: "#{instance.id}" } }
    model_options.to_json
  end

  def section_submit_action title="submit", form_id
    content_tag(:div, nil, class: "section-floating-action-row") do
      content_tag(:button, nil, class: "btn btn-floating-action ink-reaction btn-accent btn-lg submit-action", :"data-form-id" => form_id, :"data-original-title" => title, :"data-placement" => "top", :"data-toggle" => "tooltip", type: "submit" , name: "commit") do
        content_tag(:i, nil, class: "fa fa-save")
      end
    end
  end

  def section_action_offcanvas icon, url, title, floating = false
    content_tag(:div, nil, class: "section#{'-floating' if floating}-action-row") do
      content_tag(:a, nil, class: "btn btn-floating-action ink-reaction #{floating ? 'btn-accent btn-lg' : 'btn-info btn-xs'}", 
        :"data-original-title" => title, :"data-placement" => "top", "data-toggle" => "offcanvas", "data-backdrop" => "false", href: url) do
        content_tag(:i, nil, class: "fa fa-#{icon}")
      end
    end
  end

  def section_action icon, url, title
    _section_action icon, url, title
  end

  def section_floating_action icon, url, title
    _section_action icon, url, title, true
  end

  def material_form_text_field form, method, label, options= {}
    material_form_group(label, options) do
      form.text_field method, class: classes("form-control", options["class"])
    end
  end

  def material_text_field object_name, method, label, options= {}
    material_form_group(label, options) do
      text_field object_name, method, class: classes("form-control", options["class"])
    end
  end

  def material_form_group(label, options = {}, &block)
    content_tag(:div, class: classes("form-group", options["class"])) do
      concat capture(&block)
      concat label_tag(label)
    end
  end

  #TODO
  def custom_form_field(field_form, section_field, &block)
    type = section_field.field_type.field_type.match(/select/) ? 'select' : section_field.field_type.field_type
    label = section_field.field_alias || section_field.field_type.try(:name)
    
    if type == "text"
      material_form_text_field field_form, section_field.field_type.id, label
    else
      "No Field Type"
    end
  end

  def material_view_form_group(label, options = {}, &block)
    content_tag(:div, class: classes("form-group", options["class"])) do
      concat label_tag(label)
      concat capture(&block)
    end
  end

  def material_static_field label, value, options= {}
    material_view_form_group(label, options) do
      content_tag :p,  label, class: classes("form-control-static", options["class"])
    end
  end

  def field_item value, label
    unless value == "" || value.nil?
      content_tag :li, class: "tile" do
        content_tag :div, class: "tile-content" do
          tile_text = content_tag :div, class: "tile-text" do
            concat(content_tag(:small, label))
            concat(content_tag(:span, value, class: "text-sm"))
          end
        end
      end
    end
  end

  #TODO
  def form_field_view(form, section_field)
    type = section_field.field_type.field_type.match(/select/) ? 'select' : section_field.field_type.field_type
    if section_field.field_alias and section_field.field_alias!= ""
      label = section_field.field_alias 
    else
      label = section_field.field_type.try(:name)
    end

    value_data  = if form.sections_data[section_field.id.to_s] && form.sections_data[section_field.id.to_s].to_s.end_with?('file')
                    form.attachments.find_by(section_field_id: section_field.id)
                  else
                    form.sections_data[section_field.id.to_s] || ""
                  end

    value_field = render "custom_forms/form_data/view/fields/#{type}", value: value_data

    value_tag = content_tag(:span, class: "hide-overflow") do
      value_field
    end
    dl_item(value_tag, label.humanize)
  end

  def form_field_edit(user_forms_form, user_forms_section_form, section_field)
    label = section_field.field_alias.present? ? section_field.field_alias : section_field.field_type.name
    type = section_field.field_type.field_type.match(/select/) ? 'select' : section_field.field_type.field_type
   
    input = user_forms_form.fields_for "sections_data", OpenStruct.new(user_forms_form.object.sections_data) do |field|
      render "custom_forms/form_data/fields/#{type}_field", f: field, field: section_field, form_datum: user_forms_form, form_section: user_forms_section_form
    end

    content_tag(:dt, label) + content_tag(:dd, input)
  end

  def dl_input(value, label)
    if value == "" || value.nil?
      content_tag(:dt, label) + content_tag(:dd, "Not Set")
    else
      content_tag(:dt, label) + content_tag(:dd, input)
    end
  end

  def dl_item(value, label)
    if value.blank?
      content_tag(:dt, label) + content_tag(:dd, "Not Set")
    else
      content_tag(:dt, label) + content_tag(:dd, value)
    end
  end

  def format_time(time)
    time ? time.strftime('%I:%M %p') : '-'
  end
  def get_commentable_id(commentable)

    commentable.class.to_s.demodulize.downcase + "-" + commentable.id.to_s 
  end


  def time(time)
    if time

      time.strftime("%I:%M %p")
    else
      "N/S"
    end
  end

  def date(date)
    if date
      date.strftime("%B %d, %Y")
    else
      "N/S"
    end
  end

  def visit_time(v)
    "#{date(v.date)} [#{time(v.time_in)} - #{time(v.time_out)}]"
  end
  private
    def _section_action icon, url, title, floating= false
      content_tag(:div, nil, class: "section#{'-floating' if floating}-action-row") do
        content_tag(:a, nil, class: "btn btn-floating-action ink-reaction #{floating ? 'btn-accent btn-lg' : 'btn-info btn-xs'}", :"data-original-title" => title, :"data-placement" => "top", :"data-toggle" => "tooltip", href: url) do
          content_tag(:i, nil, class: "fa fa-#{icon}")
        end
      end
    end

    def classes(*classes)
      classes.reject(&:nil?).join(' ')
    end

    def format_time(time)
      time ? time.strftime('%H:%M %p') : '-'
    end

    def options_from_collection_for_select_with_data(collection, value_method, text_method, selected = nil, data = {})
      options = collection.map do |element|
        [element.send(text_method), element.send(value_method), data.map do |k, v|
          {"data-#{k}" => element.send(v)}
        end
        ].flatten
      end
      selected, disabled = extract_selected_and_disabled(selected)
      select_deselect = {}
      select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
      select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)
   
      options_for_select(options, select_deselect)
  end
end
