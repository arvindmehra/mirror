module ApplicationHelper
    def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :notice
        "alert-success"
      when :alert
        "alert-warning"
      when :error
        "alert-danger"
      else
        flash_type.to_s
    end
  end
end
