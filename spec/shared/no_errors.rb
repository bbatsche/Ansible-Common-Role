require "serverspec"

shared_examples "no_errors" do
  it "should have any errors" do
    expect(subject.stderr).to eq ""
    expect(subject.exit_status).to eq 0
  end
end
