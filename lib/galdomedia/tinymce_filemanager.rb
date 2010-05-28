module Galdomedia
  module TinymceFilemanager

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def tinymce_filemanager_list_images()
      end

      def tinymce_filemanager_upload_image()
      end

      def tinymce_filemanager_destroy_image()
      end

      def tinymce_filemanager_create_images_folder()
      end

      def tinymce_filemanager_list_media()
      end

      def tinymce_filemanager_upload_media()
      end

      def tinymce_filemanager_destroy_media()
      end

      def tinymce_filemanager_create_media_folder()
      end

      protected

      def thumbs_subdir(*params)
        write_inheritable_array(:thumbs_subdir, params)
      end

      def thumbs_size(*params)
        write_inheritable_array(:thumbs_size, params)
      end

      def image_accept_mime_types(*params)
        write_inheritable_array(:image_accept_mime_types, *params)
      end

      def image_save_into_public_subdir(*params)
        write_inheritable_array(:image_save_into_public_subdir, params)
      end

      def image_file_size_limit(*params)
        write_inheritable_array(:image_file_size_limit, params)
      end

      def media_accept_mime_types(*params)
        write_inheritable_array(:media_accept_mime_types, *params)
      end

      def media_save_into_public_subdir(*params)
        write_inheritable_array(:media_save_into_public_subdir, params)
      end

      def media_file_size_limit(*params)
        write_inheritable_array(:media_file_size_limit, params)
      end

    end

    private

    def images_folder
      self.class.read_inheritable_attribute(:image_save_into_public_subdir) || 'images'
    end

    def media_folder
      self.class.read_inheritable_attribute(:media_save_into_public_subdir) || 'media'
    end

    def thumbs_folder
      self.class.read_inheritable_attribute(:thumbs_subdir) || 'thumbs'
    end

    def accept_image_mime
      self.class.read_inheritable_attribute(:image_accept_mime_types) || ['image/jpeg', 'image/gif', 'image/png']
    end

    def accept_media_mime
      self.class.read_inheritable_attribute(:media_accept_mime_types) ||  ['video/mpeg', 'video/msvideo', 'video/quicktime', 'video/x-flv', 'application/x-shockwave-flash']
    end

    def image_size_limit
      (self.class.read_inheritable_attribute(:image_file_size_limit) && self.class.read_inheritable_attribute(:image_file_size_limit)[0]) || 5.megabytes
    end

    def media_size_limit
      (self.class.read_inheritable_attribute(:media_file_size_limit) && self.class.read_inheritable_attribute(:media_file_size_limit)[0]) || 30.megabytes
    end

    @@form_file_upload_form_name = 'upload_form'
    @@form_file_upload_field_name = 'file_attachment'

    @@form_folder_form_name = 'folder_form'
    @@form_folder_field_name = 'new_folder'


    @@thumbs_width = 96
    @@thumbs_height = 96

    protected

    def accept_images_mime_types(params)
      self.accept_image_mime = params
    end

    public

    def tinymce_filemanager_list_images
      list_base(images_folder, "tinymce_filemanager_list_images", 'tinymce_filemanager_upload_image', 'tinymce_filemanager_destroy_image', 'tinymce_filemanager_create_images_folder')
    end

    def tinymce_filemanager_upload_image
      upload_base(images_folder, "tinymce_filemanager_list_images", accept_image_mime, image_size_limit)
    end

    def tinymce_filemanager_destroy_image()
      destroy_base(images_folder, "tinymce_filemanager_list_images")
    end

    def tinymce_filemanager_create_images_folder()
      create_folder_base(images_folder ,"tinymce_filemanager_list_images")
    end


    def tinymce_filemanager_list_media
      list_base(media_folder, "tinymce_filemanager_list_media", 'tinymce_filemanager_upload_media', 'tinymce_filemanager_destroy_media', 'tinymce_filemanager_create_media_folder')
    end

    def tinymce_filemanager_upload_media
      upload_base(media_folder, "tinymce_filemanager_list_media", accept_media_mime, media_size_limit, true)
    end

    def tinymce_filemanager_destroy_media()
      destroy_base(media_folder, "tinymce_filemanager_list_media")
    end

    def tinymce_filemanager_create_media_folder()
      create_folder_base(media_folder ,"tinymce_filemanager_list_media")
    end

    private

    def list_base(base_folder, list_action, upload_action, destroy_action, create_folder_action)
      navi_list = split_navi(params[:navi], '$')
      @navi = build_navi(navi_list, '$')
      @navi_up = @navi.gsub(/([$]?[^$]+[$]?)$/, '')
      @navi_bar = build_navi_bar_items(navi_list, '$')
      @list_action = list_action

      @list_url = url_for(list_action)
      @destroy = url_for(destroy_action)
      @items = []
      @dirs = []

      @upload_form_name = @@form_file_upload_form_name
      @upload_field_name = @@form_file_upload_field_name
      @upload_action_name = url_for(upload_action)

      @folder_form_name = @@form_folder_form_name
      @folder_field_name = @@form_folder_field_name
      @folder_action_name = url_for(create_folder_action)

      @thumbs_width = @@thumbs_width
      @thumbs_height = @@thumbs_height
      
      if !navi_list.empty?
        @dirs = ['..']
      end
      
      Dir.entries(thumb_save_directory(base_folder, "", navi_list)).each do |i|
        if i!='.' && i!='..'
          if File.directory?(thumb_save_directory(base_folder, i, navi_list))
            @dirs << i
          else
            if i.index(/(.unknown)$/) != nil
              @items << { :normal => web_normal(base_folder, i.gsub(/(.unknown)$/, ""), navi_list), :small => web_normal(base_folder, i.gsub(/(.unknown)$/, ""), navi_list), :name => i.gsub(/(.unknown)$/, ""), :unknown => true }
            else
              @items << { :normal => web_normal(base_folder, i.gsub(/(.jpeg)$/, ""), navi_list), :small => web_small(base_folder, i, navi_list), :name => i.gsub(/(.jpeg)$/, ""), :unknown => false }
            end
          end
        end
      end
      
      @dirs_table = build_table(@dirs.sort, 6)
      @items_table = build_table(@items.sort{ | i, j | i[:name] <=> j[:name] }, 6)

      render :partial => 'tinymce_filemanager/table', :layout => 'tinymce_filemanager/main'
    end

    def destroy_base(base_folder, list_action)
      if !params[:destroy].blank?
        navi_list = split_navi(params[:navi], '$')
        @navi = build_navi(navi_list, '$')
        object_name = validate_name(params[:destroy])
        if File.directory?(thumb_save_directory(base_folder, object_name, navi_list))
          FileUtils.rm_rf(save_directory(base_folder, object_name, navi_list))
          FileUtils.rm_rf(thumb_save_directory(base_folder, object_name, navi_list))
        else
          FileUtils.rm_rf(save_directory(base_folder, object_name, navi_list))
          if File.exist?(thumb_save_directory(base_folder, "#{object_name}.jpeg", navi_list))
            FileUtils.rm_rf(thumb_save_directory(base_folder, "#{object_name}.jpeg", navi_list))
          end
          if File.exist?(thumb_save_directory(base_folder, "#{object_name}.unknown", navi_list))
            FileUtils.rm_rf(thumb_save_directory(base_folder, "#{object_name}.unknown", navi_list))
          end
        end
      end
      if !@navi.blank?
        redirect_to "#{url_for(:action => list_action)}?navi=#{URI.escape(@navi.gsub(/[$]$/, ''))}"
      else
        redirect_to :action => list_action
      end
    end

     def create_folder_base(base_folder ,list_action)
      navi_list = split_navi(params[:navi], '$')
      @navi = build_navi(navi_list, '$').gsub(/[$]$/, '')

      if !params[@@form_folder_form_name].blank? && !params[@@form_folder_form_name][@@form_folder_field_name].blank?
        folder_name = validate_name(params[@@form_folder_form_name][@@form_folder_field_name])
        check_or_create_directory(save_directory(base_folder, folder_name, navi_list))
        check_or_create_directory(thumb_save_directory(base_folder, folder_name, navi_list))
      end
      if !@navi.blank?
        redirect_to "#{url_for(:action => list_action)}?navi=#{URI.escape(@navi.gsub(/[$]$/, ''))}"
      else
        redirect_to :action => list_action
      end
    end

    def upload_base(base_folder, list_action, mime_types, size_max, media_thumb = false)
      navi_list = split_navi(params[:navi], '$')
      @navi = build_navi(navi_list, '$')

      if !params[@@form_file_upload_form_name].blank? and !params[@@form_file_upload_form_name][@@form_file_upload_field_name].blank?
        file = params[@@form_file_upload_form_name][@@form_file_upload_field_name]
        if file.type == Tempfile
          if File.size(file) < size_max
            if mime_types.include?(file.content_type())
              FileUtils.mv(file.path, save_directory(base_folder, validate_name(file.original_filename), navi_list))
              FileUtils.chmod 0666, save_directory(base_folder, validate_name(file.original_filename), navi_list)
              if media_thumb
                make_media_thumb(base_folder, file, navi_list)
              else
                make_image_thumb(base_folder, file, navi_list)
              end
              flash[:notice] = "File upload sucessful"
            else
              flash[:error] = "Invalid mime type! (#{file.content_type()})"
            end
          else
            flash[:error] = "File to large! (Limit: #{size_max} file: #{File.size(file)})"
          end
        else
          flash[:error] = "Field is not a file!"
        end
      end
      if !@navi.blank?
        redirect_to "#{url_for(:action => list_action)}?navi=#{URI.escape(@navi.gsub(/[$]$/, ''))}"
      else
        redirect_to :action => list_action
      end
    end

    def save_directory(base_folder, file_name, navi)
      check_or_create_directory("#{Rails.public_path }/#{base_folder}")
      "#{Rails.public_path }/#{base_folder}/#{build_navi(navi, '/')}#{file_name}"
    end

    def thumb_save_directory(base_folder, file_name, navi)
      check_or_create_directory("#{Rails.public_path }/#{base_folder}/_#{thumbs_folder}_")
      "#{Rails.public_path }/#{base_folder}/_#{thumbs_folder}_/#{build_navi(navi, '/')}#{file_name}"
    end

    def web_normal(base_folder, file_name, navi)
      "/#{base_folder}/#{build_navi(navi, '/')}#{file_name}"
    end

    def web_small(base_folder, file_name, navi)
      "/#{base_folder}/_#{thumbs_folder}_/#{build_navi(navi, '/')}#{file_name}"
    end

    def check_or_create_directory(path)
      if Dir[path].blank?
        FileUtils.mkdir_p(path)
      end
    end

    def validate_name(name)
      name.gsub(/[\/]/, '').gsub(/[$]/, '').gsub(/\.\./, '')
    end

    def split_navi(navi, separator)
      list = []
      if !navi.blank?
        navi.split(separator).each do |p|
          if !p.to_s.include?('..') && !p.blank?
            list << p
          end
        end
      end
      list
    end

    def build_navi(list, separator)
      navi = ""
      list.each do |p|
        if navi.empty?
          navi += "#{p}"
        else
          navi += "#{separator}#{p}"
        end
      end
      (!navi.blank? && "#{navi}#{separator}") || ""
    end

    def build_navi_bar_items(list, separator)
      navi = []
      navi_str = ""
      if !list.empty?
        navi << {:link => "", :name => "ROOT"}
        list.each do |p|
          if p.length > 10
              name = "#{p[0..7]}..."
            else
              name = p
            end
          if navi_str.empty?
            navi_str += "#{p}"
            navi << {:link => "", :name => name}
          else
            navi_str += "#{separator}#{p}"
            navi << {:link => navi_str, :name => name}
          end
        end
      end
      navi
    end

    def build_table(items, columns_max)
      table = []
      row = []
      counter = 0
      items.each do |i|
        row << i
        counter += 1
        if counter == columns_max
          counter = 0
          table << row
          row = []
        end
      end
      table << row
    end
    
    def make_image_thumb(base_folder, file, navi_list)
      image = Magick::Image.read(save_directory(base_folder, validate_name(file.original_filename), navi_list)).first
      image = image.resize_to_fill(@@thumbs_width, @@thumbs_height)
      image.write(thumb_save_directory(base_folder, "#{validate_name(file.original_filename)}.jpeg", navi_list))
      #File.open((thumb_save_directory(base_folder, validate_name("#{file.original_filename}.unknown"), navi_list)), 'w')
    end

    def make_media_thumb(base_folder, file, navi_list)
      source_file = save_directory(base_folder, validate_name(file.original_filename), navi_list)
      destination_file = thumb_save_directory(base_folder, validate_name(file.original_filename), navi_list)
      f = File.open("#{destination_file}.unknown", 'w')
      f.close
      command = "ffmpeg -i \"#{source_file}\" -ss 20 -vframes 1 -s #{@@thumbs_width}x#{@@thumbs_height} \"#{destination_file}.jpeg\""
      command += " && rm \"#{destination_file}.unknown\""
      system(command)
    end
  end
end
