# README

### Installation

This requires Ruby version 2.6.1 to work. Please install accordingly.
For RVM users:

    rvm install "ruby-2.6.3

Install depenencies using bundler: 

    gem install bundle
    bundle install

Last setup the server and get it running with:

    rake db:setup
    rake db:migrate
    rails s

You should be able to view the app locally at `http://localhost:3000/repos`

### Tests

Since this is a small Rails project we can target certain files and test them inline.

    ruby app/lib/git_request.rb

### Next Steps
Given some extra time there are a few more implementation ideas I would tackle next.

* Reset sessions on re-login. This adds a layer of security by avoiding session fixation hacks.
Link here: https://stackoverflow.com/questions/4812813/rails-login-reset-session

* The SASS can be structured better. Splitting out the files into components is a lot cleaner.
Currently we are dumping all the styles into `app/assets/repo.scss` which works for smaller projects, but scales poorly.

* After sorting the dropdown should reflect the current sort. Currently it always defaults to `Created at desc`.
