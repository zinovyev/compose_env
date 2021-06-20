# Compose Env

Compile docker-compose files for different environments using an ERB template.

The proposed approach might differ from the canonical way of handling multiple docker-compose environments and
extending the services for specific cases. So it might worth it to check the official documentation describing how to
[extend services](https://docs.docker.com/compose/extends/#multiple-compose-files) and also how to
[add and override configuration](https://docs.docker.com/compose/extends/#adding-and-overriding-configuration).

Anyway I find it sometimes easier to have the
[Puppet-like ERB template](https://puppet.com/docs/puppet/6/lang_template_erb.html#lang_template_erb) which describes
all the services in one place when building a small MVP application without a lot of dependencies.

Usually I used a couple of Makefile instructions before, but it is just much simpler to have these several steps defined
in one gem and be available as one executable command from the console. You can use boths: `compose_env` or
`compose-env` that's up to you, both commands are equal.

## Installation

```bash
gem install 'compose_env'
```

And then execute:

    $ compose-env --help

Or:

    $ compose_env --help

## Example

Create a `docker-compose.yml.erb` file with the following content inside of your project directory:

```yaml
version: "3.9"
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: <%= !development? ? 'strong123password' : 'password' %>
  web:
    <% if env.production? %>
    image: my_app:v0.1
    <% else %>
    build: .
    <% end %>
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/myapp
    environment:
      RAILS_ENV: <%= current_env %>
    ports:
      <% development do %>
      - "3000:3000"
      <% end %>
      - "80:3000"
    depends_on:
      - db
```

Now execute the command:

```bash
compose-env -f docker-compose.yml.erb  -e production, development
```

The result will be the following:

**docker-compose.development.yml**

```yaml
---
version: '3.9'
services:
  db:
    image: postgres
    volumes:
    - "./tmp/db:/var/lib/postgresql/data"
    environment:
      POSTGRES_PASSWORD: password
  web:
    build: "."
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b
      '0.0.0.0'"
    volumes:
    - ".:/myapp"
    environment:
      RAILS_ENV: development
    ports:
    - 3000:3000
    - 80:3000
    depends_on:
    - db
```

**docker-compose.production.yml**

```yaml
---
version: '3.9'
services:
  db:
    image: postgres
    volumes:
    - "./tmp/db:/var/lib/postgresql/data"
    environment:
      POSTGRES_PASSWORD: strong123password
  web:
    image: my_app:v0.1
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b
      '0.0.0.0'"
    volumes:
    - ".:/myapp"
    environment:
      RAILS_ENV: production
    ports:
    - 80:3000
    depends_on:
    - db
```

As you can see the command provides you a couple of helper methods to pick out the proper configuration for
each environment based on the environments passed to the `--envs` (or `-e`) option:

`environment?` returns a boolean value for the particular environment and can be used with `if/else` operators.

Which can be also used as a block of code. The code will be executed only if current environment statisfies the check.
```
<% environment do %>
  # environment specific code here...
<% end %>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ComposeEnv project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/compose_env/blob/master/CODE_OF_CONDUCT.md).
