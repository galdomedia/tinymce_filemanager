Rails.application.routes.draw do

  controller 'tinymce/filemanager' do
    match '/javascripts/tinymce_managed.js', :action => 'tinymce_managed_js', :as => :tinymce_combine_js
    match '/stylesheets/tinymce_managed.css', :action => 'tinymce_managed_css', :as => :tinymce_combine_css
  end

  match ':controller/tinymce_filemanager/list_images', :action => 'tinymce_filemanager_list_images'
  match ':controller/tinymce_filemanager/upload_image', :action => 'tinymce_filemanager_upload_image'
  match ':controller/tinymce_filemanager/destroy_image', :action => 'tinymce_filemanager_destroy_image'
  match ':controller/tinymce_filemanager/create_images_folder', :action => 'tinymce_filemanager_create_images_folder'

  match ':controller/tinymce_filemanager/list_media', :action => 'tinymce_filemanager_list_media'
  match ':controller/tinymce_filemanager/upload_media', :action => 'tinymce_filemanager_upload_media'
  match ':controller/tinymce_filemanager/destroy_media', :action => 'tinymce_filemanager_destroy_media'
  match ':controller/tinymce_filemanager/create_media_folder', :action => 'tinymce_filemanager_create_media_folder'
  
end
