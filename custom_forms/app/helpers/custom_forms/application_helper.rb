module CustomForms
  module ApplicationHelper
    def sidebar_folder_item url, title
      render partial: 'layouts/sidebar_folder_item', locals: {folder_item_path: url, folder_item_title: title}
    end

    def form_field_view(form, section_field)
      type = section_field.field_type.field_type.match(/select/) ? 'select' : section_field.field_type.field_type
      if section_field.field_alias and section_field.field_alias!= ""
        label = section_field.field_alias 
      else
        label = section_field.field_type.try(:name)
      end

      value_data  = if form.sections_data[section_field.id.to_s] == 'file'
                      form.attachments.find_by(section_field_id: section_field.id)
                    else
                      form.sections_data[section_field.id.to_s] || ""
                    end

      value_field = render "custom_forms/form_data/view/fields/#{type}", value: value_data

      dl_item(value_field, label.humanize)
    end

    def dl_item(value, label)
      if value == "" || value.nil?
        content_tag(:dt, label) + content_tag(:dd, "Not Set")
      else
        content_tag(:dt, label) + content_tag(:dd, value)
      end
    end

    def is_active items
      items = items.map{ |item| item[:url]}
      m = request.path.match ".*(#{items.join '|'})"
      m and request.path.end_with? m[0]
    end
  
    def section_submit_action title="submit", form_id = "id"
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

    def _section_action icon, url, title, floating= false
      content_tag(:div, nil, class: "section#{'-floating' if floating}-action-row") do
        content_tag(:a, nil, class: "btn btn-floating-action ink-reaction #{floating ? 'btn-accent btn-lg' : 'btn-info btn-xs'}", :"data-original-title" => title, :"data-placement" => "top", :"data-toggle" => "tooltip", href: url) do
          content_tag(:i, nil, class: "fa fa-#{icon}")
        end
      end
    end


    def link_to_add_fields(name, f, association, partial, object_key, klass = '')
      permissions = {}
      @user_roles.each do |user_role|
        permissions[user_role] = {}
        @user_abilities.each do |user_ability|
          permissions[user_role][user_ability] = 0
        end
      end
      new_object = if f.object.send(association).klass.attribute_names.include?'permissions'
                     f.object.send(association).klass.new(permissions: permissions)
                   else
                     f.object.send(association).klass.new
                   end
      id = new_object.object_id
      hash = { 'permissions' => {}, 'fields' => { '0' => {} } }
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render(partial, f: builder)
      end

      last_obj_id = f.object.send(object_key).blank? ? 0 : f.object.send(object_key).length

      klass += ' btn btn-raised'
      link_to(name, 'javascript:void(0)', id: last_obj_id, onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: klass)
    end

    def link_to_remove_fields(name, element)
      link_to(name, 'javascript:void(0)', onclick: "remove_fields(this, '#{element}')", class: 'btn head-remove-btn ink-reaction btn-icon-toggle btn-primary btn-xs')
    end

    def link_to_remove_section_field(name, element)
      link_to(name, 'javascript:void(0)', onclick: "remove_section_field(this, '#{element}')", class: 'btn head-remove-btn ink-reaction btn-icon-toggle btn-primary btn-xs')
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

    #TODO_PROHEALTH
    def form_field_edit(user_forms_form, user_forms_section_form, section_field)
      label = section_field.field_alias.present? ? section_field.field_alias : section_field.field_type.name
      type = section_field.field_type.field_type.match(/select/) ? 'select' : section_field.field_type.field_type
     
      input = user_forms_form.fields_for "sections_data", OpenStruct.new(user_forms_form.object.sections_data) do |field|
        render "custom_forms/form_data/fields/#{type}_field", f: field, field: section_field, form_datum: user_forms_form, form_section: user_forms_section_form
      end

      content_tag(:dt, label) + content_tag(:dd, input)
    end
  end
end
