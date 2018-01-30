#!/bin/env ruby
# encoding: utf-8

module Jules
  module CommonInteractions
    def nested_scroll(direction)
      scroll('NestedScrollView', direction)
    end

    # scroll types: :soft, :super_soft and :severe
    # directions: :up and :down
    # by default :scroll_type is :soft and :direction is :down
    def scroll_and_touch(element, options = {})
      scroll_until_i_see(element, options)
      touch(element)
    end

    # scroll types: :soft, :super_soft and :severe
    # directions: :up and :down
    # by default :scroll_type is :soft and :direction is :down
    def scroll_until_i_see(element, options = {})
      search(element, options)
    end

    # scroll_types: :soft, :super_soft and :severe
    # directions: :up and :down
    # by default :scroll_type is :soft and :direction is :down
    def scroll_until_i_see_mark(mark, options = {})
      search("* marked:'#{mark}'", options)
    end

    def scroll_by_type(type, direction)
      scroll_type = scroll_coord_container[type]
      coordinate = scroll_type[direction]

      perform_action('drag', coordinate.from_x, coordinate.to_x,
        coordinate.from_y, coordinate.to_y, coordinate.steps)
    end

    def until_not_have_same_content(options = { raise_if_not_found: nil })
      current_content = query('*')
      last_content = nil

      until current_content == last_content
        yield(current_content)
        last_content = current_content
        current_content = query('*')
      end

      element = options[:raise_if_not_found]
      raise Jules::Exceptions::ElementNotFoundError,
        "Element not found with query \"#{element}\"" if element
    end

    private

    ScrollCoordinate = Struct.new(:from_x, :to_x, :from_y, :to_y, :steps)

    def scroll_coord_container
      return {
        super_soft: {
          up: ScrollCoordinate.new(0, 0, 50, 40, 10),
          down: ScrollCoordinate.new(0, 0, 50, 60, 10)
        },
        soft: {
          up: ScrollCoordinate.new(0, 0, 50, 30, 20),
          down: ScrollCoordinate.new(0, 0, 50, 70, 20)
        },
        severe: {
          up: ScrollCoordinate.new(0, 0, 50, 0, 5),
          down: ScrollCoordinate.new(0, 0, 50, 100, 5)
        }
      }
    end

    def search(element, options = {})
      options = default_scroll_options.merge(options)
      until_not_have_same_content raise_if_not_found: element do
        break if element_exists(element)
        scroll_by_type options[:scroll_type], options[:direction]
      end
    end

    def default_scroll_options
      { scroll_type: :soft, direction: :up }
    end
  end
end