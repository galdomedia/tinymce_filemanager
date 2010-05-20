require 'RMagick'
require 'galdomedia/tinymce_filemanager'

ActionView::Base.send(:include, Galdomedia::TinymceFilemanager::ViewHelpers)
ActionView::Helpers::FormBuilder.send(:include, Galdomedia::TinymceFilemanager::BuilderMethods)

