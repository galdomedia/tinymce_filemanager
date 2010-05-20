ActionController::Routing::Routes.draw do |map|

  map.tinymce_combine_js '/javascripts/tinymce_managed.js',
    :controller => 'tinymce/filemanager',
    :action => 'tinymce_managed_js'

  map.tinymce_combine_css '/stylesheets/tinymce_managed.css',
    :controller => 'tinymce/filemanager',
    :action => 'tinymce_managed_css'
  
end