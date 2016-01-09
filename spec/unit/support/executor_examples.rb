shared_examples "an executor" do
  it "runs command" do
    expect(subject).to respond_to(:run_command)
  end

  it "posts http" do
    expect(subject).to respond_to(:http_post)
  end

  it "puts http" do
    expect(subject).to respond_to(:http_put)
  end

  it "deletes http" do
    expect(subject).to respond_to(:http_delete)
  end
end
