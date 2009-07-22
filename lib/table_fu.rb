module ActionView
  module Helpers
    module TagHelper

      def table(collection, options={})
        folder_name = ActionController::RecordIdentifier.partial_path(collection.first).split("/").shift
        options[:path_prefix] ||= ""
        options[:skip_head] ||= !FileTest.exists?("#{Rails.root}/app/views/#{options[:path_prefix]}#{folder_name}/_table_head.html.erb")
        @ignore_columns = nil
        @ignore_columns ||= (options[:ignore_columns] ||= [])
        if collection.any?
          content_tag(:table,
            (options[:skip_head] ? "" : render(:partial => options[:path_prefix] + folder_name + "/table_head")) +
            render(:partial => options[:path_prefix] + folder_name + "/table_row", :collection => collection),
          :class => options[:class])
        end
      end


      def th(name, *args)
        tag_options = args.extract_options!
        value = args.first if args.first.is_a?(String)
        @ignore_columns ||= []
        value ||= name.to_s.titleize
        content_tag(:th, value, tag_options) unless @ignore_columns.include?(name)
      end
      alias :table_head :th


      def td(name, *args, &block)
        @ignore_columns ||= []
        options = args.extract_options!
        unless @ignore_columns.include?(name)
          if block_given?
            concat(content_tag(:td, capture(&block), options))
          else
            content_tag(:td, (args[0] || ''), options)
          end
        end
      end
      alias :table_data :td
      
    end
  end
end
