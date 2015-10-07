module ViewComponents
  module ComponentsBuilder
    class Component

      attr_reader    :context, :attributes
      cattr_accessor :classes

      def initialize(context, attributes = {})
        @context = context
        @attributes = attributes
        @data = Hash[self.class.sections.select{|s| s[:multiple] != false}.map{|s| [s[:name], []]}]
      end

      def to_h
        @attributes.merge(@data)
      end

      def render
        context.render partial: self.class.partial, locals: { self.class.component_name => to_h }
      end

      def self.create!(name, sections, attributes, partial)
        (self.classes ||= {})[name] = Class.new(self) do

          instance_variable_set("@sections", [])
          define_singleton_method :sections do
            instance_variable_get("@sections")
          end

          define_singleton_method :partial do
            partial
          end

          define_singleton_method :component_name do
            name
          end

          sections.each do |section|
            instance_variable_get("@sections") << section

            method_name = if section[:multiple].kind_of?(String) || section[:multiple].kind_of?(Symbol)
              section[:multiple]
            elsif section[:multiple]
              section[:name].to_s.singularize.to_sym
            else
              section[:name]
            end

            subcomponent = section[:component]

            define_method method_name do |*args, &block|
              content = if subcomponent
                c = Component.classes[subcomponent].new(self.send(:context), args.first)
                block.call(c) if block
                c.render
              else
                context.capture(&block)
              end

              data = instance_variable_get("@data")
              if section[:multiple]
                data[section[:name]] << content
              else
                data[section[:name]] = content
              end
            end

          end
        end
      end

    end

    class ComponentDsl
      def initialize(options = {})
        @options = {sections: [], attributes: []}

        (options[:attributes] || []).each do |definition|
          self.attribute definition
        end

        (options[:sections] || []).each do |definition|
          if definition.is_a?(Hash)
            self.section definition.delete(:name), definition
          else
            self.section definition
          end
        end
      end

      def attribute(name)
        @options[:attributes] << {name: name}
      end

      def section(name, options = {})
        @options[:sections] << {name: name, multiple: false, component: nil}.merge!(options)
      end

      def options
        @options
      end

      def render(view)
        @options[:partial] = view
      end
    end

    def define_component(name, options = {})
      c = ComponentDsl.new(options)
      c.render "components/#{name}"
      yield c if block_given?
      Component.create!(name, c.options[:sections], c.options[:attributes], c.options[:partial])

      class_eval %(
        def #{name}(attributes = {}, &block)
          component = Component.classes[:#{name}].new(self, attributes)
          block.call(component) if block_given?
          component.render
        end
      )
    end
  end
end
