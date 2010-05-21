ActionController::Routing::Routes.draw do |map|

  map.tinymce_combine_js '/javascripts/tinymce_managed.js',
    :controller => 'tinymce/filemanager',
    :action => 'tinymce_managed_js'

  map.tinymce_combine_css '/stylesheets/tinymce_managed.css',
    :controller => 'tinymce/filemanager',
    :action => 'tinymce_managed_css'

  map.connect ':controller/tinymce_filemanager_list_images', :action => 'tinymce_filemanager_list_images'
  map.connect ':controller/tinymce_filemanager_upload_image', :action => 'tinymce_filemanager_upload_image'
  map.connect ':controller/tinymce_filemanager_destroy_image', :action => 'tinymce_filemanager_destroy_image'
  map.connect ':controller/tinymce_filemanager_create_images_folder', :action => 'tinymce_filemanager_create_images_folder'

  map.connect ':controller/tinymce_filemanager_list_madia', :action => 'tinymce_filemanager_list_media'
  map.connect ':controller/tinymce_filemanager_upload_media', :action => 'tinymce_filemanager_upload_media'
  map.connect ':controller/tinymce_filemanager_destroy_media', :action => 'tinymce_filemanager_destroy_media'
  map.connect ':controller/tinymce_filemanager_create_media_folder', :action => 'tinymce_filemanager_create_media_folder'
  
end