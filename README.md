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
      action :name_of_action, amount: 1337

      # only 1 login all 10 seconds
      action :login, amount: 1, every: 10

      # at maximum 123 contact emails a day
      action :sending_contact_email, amount: 123, every: :day

      # you can also define identifier, which can be used to distinguish counters
      identifier :category, [:category_id]

      # no more than 50 posts a day are allowed per category
      action :post, amount: 50, every: :day, per: :category
    end

The second parameter given to action defines how many times the action
can be executed.

After defining an Action you can directly call a method on the `Limited`
module to access your Action like this:

    Limited.name_of_action 
    Limited.login
    Limited.sending_contact_email
    Limited.post

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

For example:

    unless Limited.sending_contact_email.limit_reached

      # code to send contact email

      Limited.sending_contact_email.executed
    end

If the action uses an identifier (you used the `:per` option in the config file) you can pass
a hash containing the values used to distingish counters.

For example:

    unless Limited.post.limit_reached({category_id: category.id})

      # code to insert post into the category ...

      Limited.post.executed({category_id: category.id})
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
