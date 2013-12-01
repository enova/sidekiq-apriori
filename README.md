sidekiq-apriori
===============
Prioritization Middleware for Sidekiq

[![Build Status](https://travis-ci.org/enova/sidekiq-apriori.png)](https://travis-ci.org/enova/sidekiq-apriori)

Overview
--------

sidekiq-apriori simplifies dynamic prioritization for sidekiq by supplying a
simple sidekiq middleware, related active record hooks, & some additional
argument handling (for ruby 2 users).

Installation
------------

Manual installation is always an option. From the command line:

    $ gem install sidekiq-priority

Or, if you're using bundler, simply include it in your Gemfile:

    gem 'sidekiq-priority'

Priorities
----------

By default, sidekiq-apriori supports four priorities: immediate, high, nil
(default), and low. If you would like to use different priorities you can
add something along these lines to (as an example for you railsy folk) your
sidekiq initializer:

```ruby
## config/initializers/sidekiq.rb

Sidekiq::Apriori::PRIORITIES = ['wut', 'huh', 'ok', nil, 'not_even_a_little']
```

The nil is meaningful insofar as it represents the default priority. Unless you
want to disallow unset priorities, leave the nil in.

sidekiq-apriori is inspired by (a response to?) [sidekiq-priority](https://github.com/socialpandas/sidekiq-priority), in which the
order of the priorities is important. Contrary to the approach taken by
sidekiq-priority, sidekiq-apriori uses sidekiq's built in mechanism for
configuring the order of processing. As such, the ordering of priorities is
accomplished in the sidekiq.yml.

So, for example, if your sidekiq.yml currently looks like this:

```yaml
## sidekiq.yml

verbose: false
:pidfile: /tmp/sidekiq.pid
:concurrency: 5
:queues:
  - postback
  - background
```

You might want to change the 'queues' entry to look more like this:

```yaml
:queues:
  - postback_wut
  - postback_huh
  - postback_ok
  - postback
  - postback_not_even_a_little
  - background
```

To route an item to a prioritized queue, append an options hash of the form
```{ :priority => 'wut' }``` to the end of the arguments. If you're using ruby 2
& have included ```Sidekiq::Apriori::Worker``` in your worker class then this
should be enough. Otherwise, you'll need to update that method to optionally
take an additional argument

Additional Utility
------------------

In addition to the use described in the PRIORITIES section, some tooling is
provided for active record classes with priority as an attribute:

```ruby
## app/models/prioritized.rb

class Prioritized < ActiveRecord::Base
  include Sidekiq::Apriori::Arb

  prioritize do
    self.priority = nil unless
      Sidekiq::Apriori::PRIORITIES.include?(self.priority)

      self.priority = (...)
  end
end
```

Alternatively, you can pass a method name to prioritize:

```ruby
## app/models/prioritized.rb

class Prioritized < ActiveRecord::Base
  include Sidekiq::Apriori::Arb

  prioritize using: 'some_method'

  def some_method
    (...)
  end
end
```

If you're lucky enough to be using ruby 2, you can save yourself some work by
including ```Sidekiq::Apriori::Worker``` instead of ```Sidekiq::Worker``` in your
worker classes. This will save you the effort of changing the definition of the
classes' perform method & all of its invocations. ```Sidekiq::Apriori::Worker```
uses ```prepend``` to define a perform which will take an optional hash containing
a priority designation.

If you're not using ruby 2, you'll need to redefine your perform method to take an
additional, optional argument

License
-------

sidekiq-apriori is released under the MIT License. Please see the [LICENSE](LICENSE)
file for details.
