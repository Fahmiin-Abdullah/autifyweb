FROM ruby:2.6.2

RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y libxml2-dev libxslt1-dev

WORKDIR /assignments

COPY . .

RUN gem install bundler:2.3.20
ADD Gemfile Gemfile.lock .
RUN bundle install

ENTRYPOINT ["bundle", "exec", "ruby", "capture.rb"]
