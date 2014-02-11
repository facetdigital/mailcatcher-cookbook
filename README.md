mailcatcher Cookbook
====================
This cookbook does a brute-force install of [Mailcatcher](http://mailcatcher.me/), an SMTP server that catches all messages sent to it and displays then in a web interface, instead of relaying them.

By brute-force, I mean this is designed for use on a system without RVM, Ruby, Bundler, etc., where you could normally just add this to your Gemfile. Rather than use a complex setup of RVM cookbooks and such, this just runs a single script that installs RVM, Ruby 2.0.0, and Mailcatcher, along with an `/etc/init.d` script to manage it, an iptables rule to allow access to its web interface.

_Disclaimer: Because this is mostly just a brute-force script, your mileage may vary, and this may not play well with other cookbooks, especially if you are already installing RVM and such._

Usage
-----
#### mailcatcher::default

Just include `mailcatcher` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mailcatcher]"
  ]
}
```

You will also likely want to configure your app and/or framework to use `catchmail` instead of `sendmail` or point to `smtp://127.0.0.1:1025` as your SMTP server. One way to do this is to configure postfix to relay there. For example, if you are also using the `postfix` cookbook, you can use these attributes to set that:

```ruby
override_attributes(
  :postfix => {
    :main => {
      :relayhost => '127.0.0.1:1025'
    }
  }
)
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Scott W. Bradley (scottwb@gmail.com)
