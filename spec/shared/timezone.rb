require "serverspec"
require_relative "no_errors"

shared_examples "timezone" do |tzName|
  describe command("timedatectl") do
    it "shoud be #{tzName}" do
      expect(subject.stdout).to match /Time ?zone: #{Regexp.quote(tzName)}/
    end

    it "should have NTP enabled" do
      pattern = if os[:release] == "14.04" then /NTP enabled: yes/ else /Network time on: yes/ end

      expect(subject.stdout).to match pattern
    end

    include_examples "no errors"
  end
end
