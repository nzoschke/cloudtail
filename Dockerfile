FROM gliderlabs/alpine:3.2

WORKDIR /root

RUN apk-install bash curl jq make python ruby ruby-bundler ruby-json ruby-irb

ENV AWS_DEFAULT_REGION us-east-1

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
  && unzip awscli-bundle.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && rm -rf awscli-bundle \
  && rm awscli-bundle.zip

COPY Gemfile /root/Gemfile
COPY Gemfile.lock /root/Gemfile.lock
RUN bundle install

COPY . /root
