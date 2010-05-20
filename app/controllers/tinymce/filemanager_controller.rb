class Tinymce::FilemanagerController < ActionController::Base
  def tinymce_managed_js
    @manager_controller = params[:manager]
    response.headers["Content-Type"] = "text/javascript; charset=utf-8"
    render :template =>"tinymce_filemanager/tinymce_managed_js", :layout => false
  end

  def tinymce_managed_css
    
  end
  
end
