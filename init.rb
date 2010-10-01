require 'RMagick'
require 'tinymce_filemanager'

ActionView::Base.send(:include, TinymceFilemanager::ViewHelpers)
ActionView::Helpers::FormBuilder.send(:include, TinymceFilemanager::BuilderMethods)