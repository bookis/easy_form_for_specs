require 'lib/easy_form_for/view_helpers'
module EasyFormFor
  class Railtie < Rails::Railtie
    initializer "easy_form_for.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end