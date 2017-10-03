require "serverspec"
require "date"

shared_examples "nginx" do |use_ssl=false|
  describe command("nginx -t") do
    let(:disable_sudo) { false }

    it "has no errors" do
      expect(subject.stderr).to match /configuration file [[:graph:]]+ syntax is ok/
      expect(subject.stderr).to match /configuration file [[:graph:]]+ test is successful/

      expect(subject.exit_status).to eq 0
    end
  end

  describe command("nginx -V") do
    it "has error and access logs set correctly" do
      expect(subject.stderr).to match %r{--http-log-path=/var/log/nginx/access\.log}
      expect(subject.stderr).to match %r{--error-log-path=/var/log/nginx/error\.log}
    end

    it "has Phusion Passenger enabled" do
      expect(subject.stderr).to match %r{--add-module=[[:graph:]]+/passenger/src/nginx_module}
    end

    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end

  describe service('nginx') do
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening.with('tcp') }
  end

  if use_ssl
    describe port(443) do
      it { should be_listening.with('tcp') }
    end
  end
end

shared_examples "curl request" do |code|
  it "responds with status #{code}" do
    expect(subject.stdout).to match /^HTTP\/1\.1 #{Regexp.quote(code)}/
  end
end

shared_examples "curl request html" do
  it "tells IE to use the latest version" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-UA-Compatible: IE=Edge$/
  end

  it "disallows other sites from embedding in a frame" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-Frame-Options: SAMEORIGIN$/
  end

  it "disallows content type sniffing" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-Content-Type-Options: nosniff$/
  end

  it "enables IE's XSS script protection" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-XSS-Protection: 1; mode=block$/
  end

  it "disables cache transforms" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^Cache-Control: no-transform$/
  end
end

shared_examples "access logs" do |opts|
  domain = opts.delete(:domain)
  url    = opts.delete(:url) || '/'
  code   = opts.delete(:code)

  path   = if domain then "/var/log/nginx/#{domain}/access.log" else "/var/log/nginx/access.log" end

  describe command("tail -n 1 #{path}") do
    it "logged the previous request" do
      expect(subject.stdout).to match /^127\.0\.0\.1 - - \[[0-9T:+-]+\] "GET #{Regexp.quote(url)} HTTP\/1\.1" #{Regexp.quote(code)} \d+ "-" "curl\/[0-9.]+" "-"$/
    end
  end
end

shared_examples "curl request cache" do |expires|
  it "has an ETag" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^ETag: "[[:xdigit:]-]+"$/
  end

  # If expires isn't a number of days, assume we used "epoch" and there's no max-age to check
  if expires.is_a? Integer
    it "includes cache control max age" do
      expect(subject.stdout.gsub(/\r/, '')).to match /^Cache-Control: max-age=#{Regexp.quote((expires * 24 * 3600).to_s)}/
    end
  end

  it "includes expires date" do
    if expires.is_a? Integer
      expires = DateTime.httpdate(subject.stdout.gsub(/\r/, '').match(/^Date: (.+)$/)[1]) + expires
    end

    expect(subject.stdout.gsub(/\r/, '')).to match /^Expires: #{Regexp.quote(expires.httpdate)}$/
  end
end
