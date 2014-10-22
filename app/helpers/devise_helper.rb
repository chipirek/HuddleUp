module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class='alert alert-danger' id="error_explanation">
      <button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>
      <strong>OK, Error(s) prevented this request from being completed:</strong>
      <ul style='margin-left:25px;'>#{messages}</ul>
    </div>

    HTML

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end