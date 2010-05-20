class TinymceFilemanagerIconsInstallationGenerator < Rails::Generator::Base

  def manifest
    record do |m|

      src_prefix = File.join('icons', 'tinymce_filemanager')
      dest_prefix = File.join('public', 'icons', 'tinymce_filemanager')

      m.directory dest_prefix

      [
        'folder_hover.png',
        'folder.png',
        'media_object.png'
      ].each do |path|

        src = File.join(src_prefix, path)
        dest = File.join(dest_prefix, path)

        if path =~ /\./
          m.file src, dest
        else
          m.directory dest
        end

      end

    end
  end

end
