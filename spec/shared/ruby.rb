require "serverspec"
require_relative "no_errors"

shared_examples "ruby::ruby" do |cmd|
  describe command("#{cmd} -e \"puts 'ruby installed'\"") do
    it "should execute Ruby" do
      expect(subject.stdout).to eq "ruby installed\n"
    end

    include_examples "no errors"
  end

  describe command("#{cmd} --version") do
    it "should be a correct version" do
      expect(subject.stdout).to match /2\.\d+\.\d+p\d+/
    end

    include_examples "no errors"
  end
end

shared_examples "ruby::gem" do |cmd|
  describe command("#{cmd} --version") do
    it "should be a correct version" do
      expect(subject.stdout).to match /^2\.\d+\.\d+/
    end

    include_examples "no errors"
  end
end
