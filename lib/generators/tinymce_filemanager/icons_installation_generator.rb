module TinymceFilemanager

  class IconsInstallationGenerator < Rails::Generators::Base

    FILES = [
      'folder_hover.png',
      'folder.png',
      'media_object.png'
    ]

    desc "Copy TinyMce icons files to public/images/icons/tinymce_filemanager folder."

    source_root File.expand_path('../templates', __FILE__)

    def install_icons
      src_prefix = File.join('icons', 'tinymce_filemanager')
      dest_prefix = File.join('public', 'images', 'icons', 'tinymce_filemanager')

      FILES.each do |path|
        src = File.join(src_prefix, path)
        dest = File.join(dest_prefix, path)

        copy_file(src, dest) if path =~ /\./
      end
    end

  end

end