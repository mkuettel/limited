# Limited

Some utility functions to help you limit some actions in your applications
(like logins, contact forms, posting of comments, etc.) to stop spammers
to absue your services.

## Installation

Add this line to your application's Gemfile:

    gem 'limited'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install limited

## Usage

You need to define your actions somewhere in your application like this:

    Limited.configure do
      # this action should only be 1337 times at most 
      action :name_of_action, 1337

      # only 1 login all 10 seconds
      action :login, 1, 10

      # at maximum 123 contact emails a day
      action :sending_contact_email, 123, :day
    end

The second parameter given to action defines how many times the action
can be executed.

After defining an Action you can directly call a method on the `Limited`
module to access your Action like this:

    Limited.name_of_action 
    Limited.login
    Limited.sending_contact_email

Here are a few commonly used methods which every Action provides:

<table>
  <tr>
    <td>executed</td>
    <td>Call this method everytime the specified action is being executed</td>
  </tr>
  <tr>
    <td>limit_reached</td>
    <td>Wheter the limit has been reached or not</td>
  </tr>
</table>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
