module EasyFormFor
  module ViewHelpers
    
    attr_accessor :keys, :object
    EXCLUDE_KEYS = %w(created_at updated_at id)
    
    def easy_form_for(object, options={}, &block)
      @object = object
      @options = options
      set_keys
      generate_form(&block).html_safe
    end

    private 
    
    def generate_form(&block)
      form_class = @options[:classes][:form] if @options[:classes]
      form_options = {:html => {:class => form_class}} if form_class ||= {:html => {}}
      form_options[:html].merge! @options[:field_options][:form] if @options[:field_options] && @options[:field_options][:form]
      form_for(@object, form_options) do |f|
        @keys.each_with_index do |key, i|
          concat(yield f) if block_given? && @options[:yield_block] && @options[:yield_block][:before] && (@options[:yield_block][:before] == key.to_sym || (@options[:yield_block][:before] == :start && i == 0))
          field_type(f, key)
          concat(yield f) if block_given? && @options[:yield_block] && @options[:yield_block][:after] && (@options[:yield_block][:after] == key.to_sym || (@options[:yield_block][:after] == :end && i + 1 >= @keys.size))
        end
        concat(yield f) if block_given? && @options[:yield_block].blank?
        submit_options = @options[:field_options][:submit] if @options[:field_options] && @options[:field_options][:submit]
        concat f.submit(:submit, submit_options ||= {})
      end
    end
    
    def field_type(f, key, args={})
      if key.match /_id/
        type = "select"
        class_name = key.split(/_id/).first
        attribute = @options[:associations][class_name.to_sym] ||= 'name' if @options[:associations] && @options[:associations][class_name.to_sym]
        selects = options_for_select(Kernel.const_get(class_name.camelcase).order("#{attribute || 'name'} asc").map{|k| word = k.send(attribute || 'name'); [word.first.upcase == word.first ? word : word.titleize, k.id]})
        args[:class] = @options[:classes][:fields] if @options[:classes] && @options[:classes][:fields]
        if @options[:field_options] && @options[:field_options][key.to_sym]
          if @options[:field_options][key.to_sym][:class]
            args[:class] += " #{@options[:field_options][key.to_sym][:class]}" 
            @options[:field_options][key.to_sym].delete(:class)
          end
          args.merge!(@options[:field_options][key.to_sym]) 
        end
        concat f.label(key.to_sym, class_name.to_s.capitalize)
        concat f.send(type, key.to_sym, selects, {}, args)
      else
        type = case object.class.columns_hash[key].type
        when :string then 'text_field'
        when :text   then 'text_area'
        when :date   then 'date_select'
        when :boolean then 'check_box'
        when :integer then "text_field"
        else
          'text_field'
        end
        args[:class] = @options[:classes][:fields] if @options[:classes] && @options[:classes][:fields]
        if @options[:field_options] && @options[:field_options][key.to_sym]
          if @options[:field_options][key.to_sym][:class]
            args[:class] += " #{@options[:field_options][key.to_sym][:class]}" 
            @options[:field_options][key.to_sym].delete(:class)
          end
          args.merge!(@options[:field_options][key.to_sym]) 
        end
        if args[:hidden] == true
          type = 'hidden_field' 
          args.delete(:hidden)
        end
        label_text = args[:label]
        concat f.label(key.to_sym, label_text)
        concat f.send(type, key.to_sym, args)
      end
      
    end
    
    def set_keys
      @keys = sort_by(@options.has_key?(:only) ? only_keys : except_keys)
    end
    
    
    def sort_by(keys)
      return keys if @options[:sort_by].nil?
      if @options[:sort_by].instance_of? Array
        @options[:sort_by].reverse.each { |key| keys.unshift(keys.delete(key.to_s)) }
        keys
      else
        case @options[:sort_by]
        when :alphabetical then keys.sort
        when :type then keys.sort_by { |key| @object.class.columns_hash[key].type.to_s }.reverse
        else
          keys.sort
        end
      end
    end
    
    def only_keys
      [@options[:only]].flatten.compact.map { |key| key.to_s  }
    end
    
    def except_keys
      excluded_keys = (EXCLUDE_KEYS + [@options[:except]]).flatten.compact.map{|k| k.to_s}
      attrs = @object.attributes.keys.delete_if { |key| excluded_keys.include? key.to_s }
    end
    
  end
end