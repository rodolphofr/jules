module Jules
  module ElementContainer
    def element(element_name, selector)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= Jules::Element.new("#{selector}")
        end
      }
    end

    def elements(collection_name, selector)
      define_method collection_name.to_s do
        results  = query(selector)
        elements = []

        elements = results.map.with_index do |_, index|
          Jules::Element.new("#{selector} index:#{index}")
        end

        elements
      end
    end

    def collection(collection_name, selector, filter, options = {})
      define_method collection_name.to_s do
        results  = query(selector, filter)
        contents = filter(results, options)
        contents
      end
    end

    def section(element_name, class_name)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= page(#{class_name})
        end
      }
    end

    private

    def filter(results, options)
      contents = []

      results.each do |content|
        unless content.is_a? Hash
          if options.key? :match
            pattern = options[:match]
            contents << content if content.match(pattern)
          else
            contents << content
          end
        end
      end

      contents
    end
  end
end
