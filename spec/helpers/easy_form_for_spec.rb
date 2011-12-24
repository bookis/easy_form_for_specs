require 'spec_helper'

describe EasyFormFor do
  before(:each) do
    Country.create(:name => "new zealand", :abbreviation => "NZ")
  end
  
  describe "except" do
    before(:each) do
      @result = helper.easy_form_for(Blog.new, :except => :tagline, :sort_by => [:theme]) do |f|
        f.label :temp_field
        f.text_field :temp_field
      end
    end
  
    it "should have a name" do
      @result.should include 'id="blog_name"'
    end
  
    it "should not have a tagline" do
      @result.should_not include "tagline"
    end
  
    it "should have theme first" do
      @result.scan(/blog_\w+/i).first.should eq "blog_theme"
    end
  
    it "should have the temp field field" do
      @result.should include 'id="blog_temp_field"'
    end
    
    it "should have name from country select" do
      @result.should include 'New Zealand</option>'
    end
    
  end
  
  describe "only" do
    
    before(:each) do
      @result = helper.easy_form_for(Blog.new, 
        :only => [:tagline, :name, :theme, :country_id, :published], 
        :yield_block => {:after => :name},
        :field_options  => {:form => {"data-user" => 1}, :name => {:placeholder => "Name"}},
        :associations => {:country => :abbreviation},
        :classes => {:fields => 'pink'}) { |f|
          f.label :temp_field
          f.text_field :temp_field
        }
    end
    
    it "should not have published_at" do
      @result.should_not include "published_at"
    end
    
    it "should have tagline first" do
      @result.scan(/blog_\w+/i).uniq.should == ["blog_tagline", "blog_name", "blog_temp_field", "blog_theme", "blog_country_id", "blog_published"]
    end
    
    it "should have the class pink on each field" do
      @result.scan(/pink/).length.should eq 5
    end
    
    it "should have name from country select" do
      @result.should include 'NZ</option>'
    end
    
    it "should have a placeholder for name only" do
      @result.should include 'placeholder="Name"'
    end
    
    it "should have data user in the form" do
      @result.should include 'data-user="1"'
    end
  end
  
  describe "Random" do
    before(:each) do
      @result = helper.easy_form_for(Blog.new, 
        :only           => [:tagline, :name, :theme, :country_id, :published, nil], 
        :yield_block    => {:before => :start},
        :field_options  => {:submit => {:id => "push-me"}, :name => {:hidden => true}, :tagline => {:class => "extra-class", :label => "Tag Snizzle"}},
        :associations   => {:country => :abbreviation},
        :classes        => {:fields => 'pink', :form => "form-class"}) { |f| 
          f.label :temp_field
          f.text_field :temp_field
        }
    end
    
    it "should have a country label" do
      @result.should include '<label for="blog_country_id">Country</label>'
    end
    
    it "should place the yield at the beginning" do
      @result.scan(/blog_\w+/i).uniq.should == ["blog_temp_field", "blog_tagline", "blog_name", "blog_theme", "blog_country_id", "blog_published"]
    end
    
    it "should have hidden field for name" do
      @result.should include '<input class="pink" id="blog_name" name="blog[name]" type="hidden" />'
    end
    
    it "should have a normal label all the time" do
      @result.should include '<label for="blog_published">Published</label>'
    end
    
    it "should have a different label" do
      @result.should include '<label for="blog_tagline">Tag Snizzle</label>'
    end
    
    it "should have an extra class and the default class" do
      @result.should include 'class="pink extra-class"'
    end
    
    it "should have a class on the form" do
      @result.should include '<form accept-charset="UTF-8" action="/blogs" class="form-class" id="new_blog" method="post">'
    end
    
    it "should have a submit button" do
      @result.should include 'type="submit"'
    end
    
    it "should have a submit button" do
      @result.should include 'id="push-me"'
    end
  end
  
  describe "Random2" do
    #"name" "tagline" "theme" "body" "country_id" "published" "published_at"
    
    before(:each) do
      @result = helper.easy_form_for(Blog.new, 
        :except         => [:tagline, :name, :theme, :country_id, :published], 
        :sort_by        => [:published_at, :body],
        :yield_block    => {:after => :end},
        :field_options  => {:submit => {:id => "push-me"}},
        :classes        => {:fields => 'pink', :form => "form-class"}) { |f| 
          f.label :temp_field
          f.text_field :temp_field
        }
    end

    it "should place the yield at the beginning" do
      puts @result.inspect
      @result.scan(/blog_\w+/i).uniq.should == ["blog_published_at", "blog_body", "blog_temp_field"]
    end

    it "should have hidden field for name" do
      @result.should_not include 'blog_name'
    end

    it "should have a different label" do
      @result.should_not include 'blog_tagline'
    end

    it "should have a class on the form" do
      @result.should include '<form accept-charset="UTF-8" action="/blogs" class="form-class" id="new_blog" method="post">'
    end

    it "should have a submit button" do
      @result.should include 'type="submit"'
    end

    it "should have a submit button" do
      @result.should include 'id="push-me"'
    end
  end
end
