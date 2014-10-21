module ApplicationHelper


  #-- some failed transactions set model errors that are not matched to a specific form field.
  #-- These are called “base errors.” For example, the User model sets an error like this:
  #-- errors.add :base, "Credit card declined" .

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
      <div class="alert alert-danger fade in">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
      </div>
    HTML
    html.html_safe
  end

end
