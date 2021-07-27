# Use ruby image to build our own image
FROM ruby:2.7

# Install node and yarn
RUN apt-get update -qq && apt-get install -y nodejs npm yarn postgresql-client

# Create work dir
RUN mkdir /app
WORKDIR /app

# Install gems
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

RUN echo "here"

# Install yarn
COPY package.json /app/package.json
RUN npm install -g yarn

# Copy rails code
ADD . /app
RUN bundle exec rake assets:precompile
RUN rails db:migrate

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
