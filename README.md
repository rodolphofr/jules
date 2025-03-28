# Jules - Calabash Page Object Model

Jules is a Ruby gem designed to facilitate automated functional testing for Android applications using Calabash, following the Page Object Model (POM) design pattern. This approach helps keep tests organized, reusable, and easier to maintain by separating the logic of interacting with the app's interface from the test scenarios themselves.

## What is Jules?

Jules provides an abstraction layer that centralizes the definition of UI elements and actions for each page in your Android application. Instead of scattering element selectors and interaction code throughout your tests, you define "pages" — classes that encapsulate both the UI elements and the methods to interact with them. This makes your tests cleaner, less redundant, and more resilient to changes in the user interface.

## What Problem Does It Solve?

When developing automated tests for mobile applications, UI changes can break multiple tests if element selectors are hard-coded in every scenario. By adopting the Page Object Model, Jules:
- **Centralizes** the definition of UI elements in dedicated classes.
- **Encapsulates** common actions (such as tapping, entering text, and verifying states) into reusable methods.
- **Isolates** layout changes to a single location, making tests easier to maintain as the application evolves.

## Features

- **Intuitive Page DSL:** Define elements and actions for each screen in a declarative manner.
- **Calabash Integration:** Seamlessly works with the Calabash framework for Android.
- **Interaction Methods:** Simplifies common operations like waiting for elements, tapping, entering text, and validating states.
- **Reusability and Maintainability:** By separating UI logic from test scenarios, tests become more robust and easier to update.

## Installation

Add the gem to your `Gemfile`:

```ruby
gem 'jules'
```

Then run:

```bash
bundle install
```

Or install it directly via RubyGems:

```bash
gem install jules
```

## Configuration

After installation, ensure your Calabash environment is properly set up for testing on Android devices or emulators. Refer to the [Calabash documentation](https://github.com/calabash/calabash-android) for further configuration details.

## Usage

### Defining a Page

To use Jules, create a class that inherits from `Jules::Page` and define the UI elements and methods that encapsulate the actions on that page. For example:

```ruby
class LoginPage < Jules::Page
  # Define the page elements.
  element :username_field, "android.widget.EditText", index: 0
  element :password_field, "android.widget.EditText", index: 1
  element :login_button,   "android.widget.Button"

  # Method to execute the login flow.
  def login(user, pass)
    wait_for_element(username_field)
    touch username_field
    enter_text user

    wait_for_element(password_field)
    touch password_field
    enter_text pass

    touch login_button
  end
end
```

### Example Use Case: Login

Below is an example of how to use the gem to perform a login test on a sample page:

```ruby
require 'jules'
require_relative 'login_page'

# Instantiate the login page.
login_page = LoginPage.new

# Define login credentials.
username = "sample_user"
password = "password123"

# Execute the login flow.
login_page.login(username, password)

# Verify that the login was successful by waiting for an element on the home screen.
if login_page.wait_for_element(:home_screen_element)
  puts "Login successful!"
else
  puts "Login failed."
end
```

### Automated Login Test with Asserts

Jules also supports integrating assertions to validate test outcomes. Below is an example of an automated login test using assertions:

```ruby
require_relative 'login_page'
require 'minitest/autorun'

class LoginTest < Minitest::Test
  def test_login_successful
    login_page = LoginPage.new

    # Login credentials.
    username = "sample_user"
    password = "password123"

    # Execute the login flow.
    login_page.login(username, password)

    # Assert that the login was successful.
    assert login_page.wait_for_element(:home_screen_element), "Login failed: Home screen element not found."
  end
end
```

In this example, the `LoginPage` class encapsulates the details for interacting with the username field, password field, and login button. The `login` method makes the test more readable and easier to maintain since any UI changes will only require updates in this class. The automated test then uses assertions to verify that the login process resulted in the expected screen element being displayed.
