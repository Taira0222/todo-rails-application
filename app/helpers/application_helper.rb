module ApplicationHelper
  # flashメッセージの色分けロジック
  def flash_color_class(type)
    case type.to_sym
    when :notice
      "bg-blue-100 text-blue-700 border-blue-300"
    when :success
      "bg-green-100 text-green-700 border-green-300"
    when :alert, :error
      "bg-red-100 text-red-700 border-red-300"
    else
      "bg-gray-100 text-gray-700 border-gray-300"
    end
  end
end
