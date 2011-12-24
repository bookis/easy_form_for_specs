require 'spec_helper'

describe "blogs/edit.html.erb" do
  before(:each) do
    @blog = assign(:blog, stub_model(Blog))
  end

  it "renders the edit blog form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => blogs_path(@blog), :method => "post" do
    end
  end
end
