require "serverspec"
require "date"

shared_examples "nginx" do |use_ssl=false|
  describe command("nginx -t"), :sudo => true do
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
    expect(subject.stdout).to match %r{^HTTP/(1\.1|2) #{Regexp.quote(code)}}
  end
end

shared_examples "curl request html" do
  it "tells IE to use the latest version" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-UA-Compatible: IE=Edge$/i
  end

  it "disallows other sites from embedding in a frame" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-Frame-Options: SAMEORIGIN$/i
  end

  it "disallows content type sniffing" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-Content-Type-Options: nosniff$/i
  end

  it "enables IE's XSS script protection" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^X-XSS-Protection: 1; mode=block$/i
  end

  it "uses a secure referrer policy" do
    expect(subject.stdout.gsub(/\r/, '')).to match /^Referrer-Policy: strict-origin-when-cross-origin$/i
  end
end

shared_examples "access logs" do |opts|
  domain = opts.delete(:domain)
  url    = opts.delete(:url) || '/'
  code   = opts.delete(:code)

  path   = if domain then "/var/log/nginx/#{domain}/access.log" else "/var/log/nginx/access.log" end

  describe command("tail -n 1 #{path}") do
    it "logged the previous request" do
      expect(subject.stdout).to match /^127\.0\.0\.1 - - \[[0-9T:+-]+\] "GET #{Regexp.quote(url)} HTTP\/(1\.1|2\.0)" #{Regexp.quote(code)} \d+ "-" "curl\/[0-9.]+" "-"$/
    end
  end
end
