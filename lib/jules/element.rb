#!/bin/env ruby
# encoding: utf-8

module Jules
  module CalabashProxy
    require 'calabash-android/operations'
    include Calabash::Android::Operations
  end

  class Element
    attr_reader :selector

    DEFAULT_TIMEOUT = 10.freeze

    def initialize(selector)
      @selector = selector
    end

    def set(text)
      execute setText: text.to_s
    end

    def text
      execute :text
    end

    def check
      execute setChecked: true
    end

    def uncheck
      execute setChecked: false
    end

    def attrs
      execute
    end

    def scroll_to(direction = :up)
      interactions.scroll_until_i_see(selector, { direction: direction })
    end

    def set_date(date)
      touch
      picker = DatePicker.new
      picker.await
      picker.set_date date
      picker.ok
    end

    def set_with_keyboard(text)
      touch
      keyboard_enter_text(text.to_s, timeout: DEFAULT_TIMEOUT)
    end

    def set_with_keyboard_and_hide(text)
      set_with_keyboard(text)
      press_enter_button
      sleep 0.7
      hide_soft_keyboard
    end

    def await(timeout = DEFAULT_TIMEOUT)
      wait_for_element_exists(timeout: timeout)
    end

    def find_elements(selector)
      _selector = "#{@selector} #{selector}"
      elements  = calabash_proxy.query(_selector)
      elements.map.with_index do |element, index|
        Element.new("#{_selector} index:#{index}")
      end
    end

    def find_element(selector, direction: :up)
      _selector = "#{@selector} #{selector}"
      interactions.scroll_until_i_see(_selector, { direction: direction })
      Element.new(_selector)
    end

    def visible?
      begin
        when_element_exists(timeout: DEFAULT_TIMEOUT, action: -> { return true })
      rescue
        false
      end
    end

    def has_text?(text)
      !!(self.text =~ /#{text}/i)
    end

    def has_attr?(attr)
      attrs.key?(attr)
    end

    def selected?
      execute :isSelected
    end

    def enabled?
      execute :isEnabled
    end

    def checked?
      execute :isChecked
    end

    def clickable?
      execute :isClickable
    end

    def exists?
      element_exists
    end

    def to_s
      @selector
    end

    def to_str
      @selector
    end

    def method_missing(method_name, *args, &block)
      if calabash_proxy.respond_to?(method_name.to_sym)
        calabash_proxy.send(method_name, selector, *args, &block)
      elsif has_attr?(method_name.to_s)
        attrs[method_name.to_s]
      else
        super
      end
    end

    private

    def execute(*options)
      if not element_exists
        raise Jules::Exceptions::ElementNotFoundError,
          "Element not found with query \"#{selector}\""
      end
      array_res = query(*options)
      array_res.first
    end

    def calabash_proxy
      @calabash_proxy ||= Class.new.extend(Jules::CalabashProxy)
    end

    def interactions
      @interactions ||= Class.new.extend(Jules::CommonInteractions)
    end
  end

  class DatePicker < Element
    extend ElementContainer

    attr_reader :date

    element :label_year, "* id:'date_picker_header_year'"
    element :label_date, "* id:'date_picker_header_date'"
    element :button_ok, "* id:'button1'"
    element :button_cancel, "* id:'button2'"
    element :button_next, "* id:'next'"

    PATTERN_SET_DATE = '%d-%m-%Y'.freeze

    def initialize(date = Date.today)
      super("* id:'datePicker'")
      @date = date.is_a?(Date) ? date : format_to_date(date)
    end

    def set_date(date)
      qualified = get_qualified_date(date)
      super qualified.strftime(PATTERN_SET_DATE)
      @date = qualified
    end

    def set_day(day)
      set_date Date.new(@date.year, @date.month, day.to_i)
    end

    def get_year
      label_year.text
    end

    def get_text_date
      label_date.text
    end

    def ok
      button_ok.touch
    end

    def cancel
      button_cancel.touch
    end

    private

    def get_qualified_date(date)
      case date
      when 'next weekend'
        get_next_weekend(date)
      when 'next full month'
        get_next_full_month(date)
      when String
        format_to_date(date)
      end
    end

    def format_to_date(date)
      date = date.tr('/', '-') if date.include? '/'
      Date.strptime(date, PATTERN_SET_DATE)
    end

    def get_next_weekend(date)
      unless date.saturday? || date.sunday?
        date = get_next_weekend(date.next_day)
      end
      date
    end

    def get_next_full_month(date)
      unless Date.new(date.year, date.month, -1) != 31
        date = get_next_full_month(date.next_month)
      end
      date
    end
  end
end

