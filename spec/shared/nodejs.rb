require "serverspec"
require_relative "no_errors"

shared_examples "nodejs" do |cmd|
  describe command("#{cmd} -e \"console.log('node installed');\"") do
    it "should execute JavaScript" do
      expect(subject.stdout).to eq "node installed\n"
    end

    include_examples "no errors"
  end

  describe command("#{cmd} --version") do
    it "should be a correct version" do
      expect(subject.stdout).to match /^v6\.\d+\.\d+$/
    end

    include_examples "no errors"
  end
end
