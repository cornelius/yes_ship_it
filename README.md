# Yes, ship it!

*The ultimate release script*

Whenever the answer is "Yes, ship it!" you will need `yes_ship_it`, this tool.
It is the ultimate helper in releasing software.

Shipping software is not an action. It's a state of mind. `yes_ship_it` helps
you to make sure that reality matches this state of mind. It won't fix the bugs
in your software, it doesn't create the tests which would need to be there, it
doesn't write your release notes. It does make sure that your good engineering
is delivered to your users with zero cost.

The approach of `yes_ship_it` is different from the typical release script. It
doesn't define a series of steps which are executed to make a release. It
defines a sequence of assertions about the release, which then are checked and
enforced.

This works in a way you could describe as idempotent, which means you
can execute it as many times as you want, the result will always be the same,
regardless of the initial state. That means the whole process is robust against
errors which happen during releasing, it transparently copes with manual tweaks
and changes, and it works on old releases just as well as on new releases.

After successfully running `yes_ship_it` your release will have shipped, and the
state of the world will reflect the state of your mind.

## Assumptions

`yes_ship_it` assumes that you develop your software in a version control
system and keep at least some minimal state of releases there. This could just
be a tag. It also assumes that you are able to run `yes_ship_it` from the
command line and have some access to the systems which are needed to complete
the things part of a release.

## How to run it

Go to the checkout of the sources of your software. Check that there is a file
called `yes_ship_it.conf` there. Run `yes_ship_it`. Done.

## Configuration

The central configuration of what happens when you run `yes_ship_it` is the
`yes_ship_it.conf` file in the root directory of the sources of your software.
There you define the sequence of assertions which are run through for making
sure that the release is happening in the way you intend. `yes_ship_it` comes
with some predefined sequences of assertions you can simply reuse.

The format of `yes_ship_it.conf` uses YAML. A minimal `yes_ship_it.conf` file
could look like this:

```yaml
include:
  standard_rubygem
```

A more detailed configuration could look like this:

```yaml
assertions:
  - ci_green
  - release_notes
  - version_number
  - gem_built
  - release_tagged
  - gem_pushed
```

There can be more configuration on a general level or the level of the
assertions to adjust to specific needs of each software project. There also can
be other or additional assertions.

## Extending `yes_ship_it`

Many software projects will have specific needs for their releases. These can
be broken down and reflected in additional assertions. Adding assertions is
easy. There is a well-defined API for it.

There is no supported plugin concept. The idea is that all assertions ship with
`yes_ship_it`. This will maximize the value for the community of people who ship
software. The project is very open to include new assertions. Just submit a pull
request. `yes_ship_it` will ship it with the next release.

## Testing

Testing a tool such as `yes_ship_it` is not easy because its prime functionality
is to interact with other systems and publish data. There are unit tests for the
code. There also are integration tests which work in a virtual environment which
fakes the services `yes_ship_it` interacts with. It uses the `pennyworth` tool
to manage the virtual environment and make them accessible in a convenient way
from the RSpec tests.

## Further documentation

You get basic documentation from the tool itself by executing
`yes_ship_it help`. There also is a simple man page with some pointers.

The main documentation with details about different scenarios how `yes_ship_it`
can be used is maintained in the
[Wiki](https://github.com/cornelius/yes_ship_it/wiki). You are welcome to
contribute there.

## Users

There is a list of [users of yes_ship_it](https://github.com/cornelius/yes_ship_it/blob/master/USERS.md).
I'm happy to add you there. Just send me a pull requests for the `USERS.md`
file.

## License

`yes_ship_it` is licensed under the MIT license.

## Contact

If you have any questions or comments, please don't hesitate to get in touch
with me: Cornelius Schumacher <schumacher@kde.org>.
