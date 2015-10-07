module ViewComponents
  module ComponentsBuilder
    class Component

      attr_reader    :context, :attributes
      cattr_accessor :classes

      def initialize(context, attributes)
        @context = context
        @attributes = attributes
        @data = Hash.new
      end

      def to_h
        @attributes.merge(@data)
      end

      def render
        context.render partial: partial, locals: { name => to_h }
      end

      def self.create!(name, sections, attributes, partial)
        (self.classes ||= {})[name] = Class.new(self) do
          sections.each do |section|
            section_name = section[:name]
            define_method section_name do |*args, &block|
              instance_variable_get("@data")[section_name] = context.capture(&block)
            end
          end

          define_method :partial do
            partial
          end

          define_method :name do
            name
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
          block.call(component)
          component.render
        end
      )
    end
  end
end
