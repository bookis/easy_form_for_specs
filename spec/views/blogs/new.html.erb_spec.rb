require 'spec_helper'

describe "blogs/new.html.erb" do
  before(:each) do
    assign(:blog, stub_model(Blog).as_new_record)
  end

  it "renders new blog form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => blogs_path, :method => "post" do
    end
  end
end
