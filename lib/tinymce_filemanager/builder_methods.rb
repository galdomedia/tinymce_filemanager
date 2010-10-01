module TinymceFilemanager::BuilderMethods

  def tinymce_managed method, options = {}
    @template.append_class_name(options, 'tinymce_managed')
    self.text_area(method, options)
  end

end