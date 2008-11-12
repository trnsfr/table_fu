module ActionView
  module Helpers
    module TagHelper

      def table(collection, options={})
        options[:skip_head] ||= false
        folder_name = collection.first.class.name.downcase.pluralize
        @ignore_columns = nil
        @ignore_columns ||= (options[:ignore_columns] ||= [])
        if collection.any?
          content_tag(:table,
            (options[:skip_head] ? "" : render(:partial => folder_name + "/table_head")) +
            render(:partial => folder_name + "/table_row", :collection => collection),
          :class => options[:class])
        end
      end


      def th(name, value=nil, tag_options={})
        @ignore_columns ||= []
        value ||= name.to_s.capitalize
        content_tag(:th, value, tag_options) unless @ignore_columns.include?(name)
      end
      alias :table_head :th


      def td(name, *args, &block)
        @ignore_columns ||= []
        options = args.extract_options!
        unless @ignore_columns.include?(name)
          if block_given?
            concat(content_tag(:td, capture(&block), options), block.binding)
          else
            content_tag(:td, (args[0] || ''), options)
          end
        end
      end
      alias :table_data :td      
      
    end
  end
end
