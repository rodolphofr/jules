#!/bin/env ruby
# encoding: utf-8
require 'rspec'

module Jules
  module CommonAsserts
    def expect_page(page, timeout: 10)
      name = page.respond_to?(:name) ? page.name : page.class.name
      part = page.class.name.end_with?('Section') ? 'Section' : 'Page'

      begin
        page.await(timeout: timeout)
        expect(page).to be_displayed
      rescue RSpec::Expectations::ExpectationNotMetError
        raise RSpec::Expectations::ExpectationNotMetError,
          "#{part} #{name} not displayed. Maybe the 'trait' is incorrect."
      rescue Calabash::Android::WaitHelpers::WaitError
        raise Calabash::Android::WaitHelpers::WaitError,
          "#{part} #{name} not displayed. Timeout exceeded."
      end
    end

    def assert_popup(*elements, timeout: timeout)
      begin
        wait_for_elements_exist(elements, timeout: timeout)
      rescue
        false
      end
      true
    end

    alias_method :assert_section, :assert_popup
    alias_method :expect_section, :expect_page
  end
end