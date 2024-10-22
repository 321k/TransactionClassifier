# use the official ruby image
FROM ruby:3.0

# install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# set working directory
WORKDIR /app

# copy the gemfile and install gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# copy the app source code
COPY . /app

# precompile assets for production (optional, if using asset pipeline)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# expose the port that rails listens to
EXPOSE 8080

# start the rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]