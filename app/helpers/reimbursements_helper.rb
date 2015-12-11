module ReimbursementsHelper
  def link_to_add_fields(name, rv, f, partial)
    new_object = ReimbursementsVisit.new
    fields = f.fields_for(:reimbursements_visits, new_object, child_index: 'new_reimbursements_visits') do |builder|
      render partial: 'reimbursement_fields', locals: { builder: builder, available_reimbursements: @available_reimbursements }
    end
    klass = 'btn btn-raised'
    link_to(name, 'javascript:void(0)', onclick: "add_fields(this, \"reimbursements_visits\", \"#{escape_javascript(fields)}\")", class: klass)
  end

  def link_to_remove_fields(name, _element)
    link_to(name, 'javascript:void(0)', onclick: 'remove_reimbursements_fields(this)', class: 'btn head-remove-btn ink-reaction btn-icon-toggle btn-primary btn-xs')
  end

  def options_from_collection_for_select_with_attributes(collection, value_method, text_method, attr_name, attr_field, selected = nil)
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method), attr_name => element.send(attr_field)]
    end

    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end
end
