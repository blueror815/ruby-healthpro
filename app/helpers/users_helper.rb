module UsersHelper
  def tile_list_item value, label, icon = ""
    if value == "" || value.nil?
    else
      content_tag :li, class: "tile" do
        content_tag :div, class: "tile-content ink-reaction" do
          tile_icon =  content_tag :div, class: "tile-icon" do
            if icon and icon != ""
              content_tag :i, class: "fa fa-#{icon}"
            end
          end
          tile_text = content_tag :div, class: "tile-text" do
            content_tag(:span, value.humanize) + content_tag(:small, label)
          end

          tile_icon + tile_text
        end
      end
    end
  end
end