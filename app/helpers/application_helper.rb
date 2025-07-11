module ApplicationHelper
  def render_svg(name, classes: 'fill-current', title: nil)
    # asset_path("icons/#{name}.svg")
    file_path = "icons/#{name}.svg"
    title ||= name.underscore.humanize

    inline_svg(file_path, aria: true, nocomment: true, title: title, classes: classes)
  end

  def status_color(status)
    case status
    when 'approved' then 'bg-green-100 text-green-800'
    when 'pending' then 'bg-yellow-100 text-yellow-800'
    else 'bg-red-100 text-red-800'
    end
  end
  
  def status_class(status)
    case status
    when 'healthy'
      'px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800'
    when 'low'
      'px-3 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-800'
    when 'critical'
      'px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800'
    when 'negative'
      'px-3 py-1 rounded-full text-xs font-semibold bg-red-800 text-white'
    end
  end
end
