module ApplicationHelper
  def render_svg(name, classes: 'fill-current', title: nil)
    # asset_path("icons/#{name}.svg")
    file_path = "icons/#{name}.svg"
    title ||= name.underscore.humanize

    inline_svg(file_path, aria: true, nocomment: true, title: title, classes: classes)
  end
end
