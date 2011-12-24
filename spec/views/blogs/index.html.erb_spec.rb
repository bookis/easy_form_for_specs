require 'spec_helper'

describe "blogs/index.html.erb" do
  before(:each) do
    assign(:blogs, [
      stub_model(Blog),
      stub_model(Blog)
    ])
  end

  it "renders a list of blogs" do
    render
  end
end
