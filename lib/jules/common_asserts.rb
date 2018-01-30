#!/bin/env ruby
# encoding: utf-8

require 'rspec'

module Jules
  module CommonAsserts
    def expect_page(page, timeout: 10)
      begin
        page.await(timeout: timeout)
        expect(page).to be_displayed
      rescue RSpec::Expectations::ExpectationNotMetError
        raise RSpec::Expectations::ExpectationNotMetError,
          "#{page.class.name} not displayed. Maybe the 'trait' is incorrect."
      rescue Calabash::Android::WaitHelpers::WaitError
        raise Calabash::Android::WaitHelpers::WaitError,
          "#{page.class.name} not displayed. Timeout exceeded."
      end
    end

    def assert_popup(*elements, timeout: 10)
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
