module Jules
  module ElementContainer
    def element(element_name, selector)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= Jules::Element.new("#{selector}")
        end
      }
    end

    def elements(collection_name, selector, filter, conditions = {})
      define_method collection_name.to_s do
        results = query(selector, *filter)

        unless results.empty?
          results = if filter.nil?
                      transform_in_elements(selector, results)
                    else
                      self.filter(results, conditions)
                    end
        end

        results
      end
    end

    alias_method :collection, :elements

    def section(element_name, class_name)
      class_eval %{
        def #{element_name}
          @#{element_name} ||= page(#{class_name})
        end
      }
    end

    private

    def filter(results, conditions)
      contents = []

      results.each do |content|
        unless content.is_a? Hash
          if conditions.key? :match
            pattern = conditions[:match]
            contents << content if content.match(pattern)
          else
            contents << content
          end
        end
      end

      contents
    end

    def transform_in_elements(selector, results)
      results.map.with_index do |_, index|
        Jules::Element.new("#{selector} index:#{index}")
      end
    end
  end
end
