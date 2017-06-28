require "serverspec"

shared_examples "bash::aliases" do
  it "should use long format" do
    expect(subject.stdout).to match /^-rw-r--r--\s+\d+\s+root\s+root.+test$/
  end

  it "should use human syntax for file size" do
    expect(subject.stdout).to match /^-rw-r--r--\s+\d+\s+root\s+root\s+1\.0K.+test$/
  end
end

shared_examples "bash::regular_files" do
  it "should not include hidden files" do
    expect(subject.stdout).to_not match /\.test.?$/
  end
end

shared_examples "bash::hidden_files" do
  it "should include hidden files" do
    expect(subject.stdout).to match /\.test.?$/
  end

  it "should not include . or .." do
    expect(subject.stdout).to_not match /\.\/?$/
    expect(subject.stdout).to_not match /\.\.\/?$/
  end
end
