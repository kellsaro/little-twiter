Little twiter application based on [Ruby on Rails Tutorial](http://www.railstutorial.org/) 
sample application.

[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
is a web tutorial created by [Michael Hartl](http://www.michaelhartl.com/).

## License

All source code in the [Ruby on Rails Tutorial](http://railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo, go to a folder and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

## Differences

The little-twiter implementation sligtly differs from the original:
* I have created the Session Model wich is not an ActiveRecord subclass, but an ActiveModel subclass. It is used in the login logic.
* I have avoided the creation of methods for refactoring a simple line of code. For example: SecureRandom.urlsafe_base64 is used directly instead of using a wrapper method.
* The creation and configuration of account for sending emails is uncompleted. Follow the steps in the tutorial for complete.

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).
