module ChartsHelper
  def render_chart(title:, id:, type:, data:, options: {}, height: nil)
    render 'shared/chart', 
      title: title,
      id: id,
      type: type,
      data: data,
      options: options,
      height: height
  end
end