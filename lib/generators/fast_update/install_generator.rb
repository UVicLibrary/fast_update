class FastUpdate::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def inject_stylesheet
    css_file_path = "app/assets/stylesheets/application.css"
    copy_file("fast_update.css", "app/assets/stylesheets/fast_update.css") unless File.file?("app/assets/stylesheets/fast_update.css")
    unless File.read(css_file_path).include?("*= require fast_update\r\n")
      inject_into_file css_file_path, before: "*= require_self" do
        "*= require fast_update\r\n "
      end
    end
  end

  def inject_javascript
    js_file_path = "app/assets/javascripts/application.js"
    copy_file("fast_update.js", "app/assets/javascripts/fast_update.js") unless File.file?("app/assets/javascripts/fast_update.js")
    unless File.read(js_file_path).include?("//= require fast_update")
      if File.read(js_file_path).include?("//= require turbolinks")
        inject_into_file js_file_path, before: "//= require turbolinks" do
          "//= require fast_update\r\n"
        end
      else
        append_to_file js_file_path do
          "\r\n//= require fast_update\r\n"
        end
      end
    end
  end

  def copy_config_file
    copy_file("config/fast_update.yml", "config/fast_update.yml") unless File.file?("config/fast_update.yml")
  end
end