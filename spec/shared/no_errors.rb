require "serverspec"

shared_examples "no errors" do
  it "should have no errors" do
    expect(subject.stderr).to eq ""
    expect(subject.exit_status).to eq 0
  end
end
