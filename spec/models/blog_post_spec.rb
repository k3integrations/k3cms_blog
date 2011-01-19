# encoding: utf-8
require 'spec_helper'
require 'app/models/k3/blog/blog_post'

module K3::Blog
  describe BlogPost do
    before do
      Time.stub!(:now).and_return(Time.mktime(2011,1,1, 12,0))
    end

    describe "when a new record is initialized" do
      before do

        @blog_post = BlogPost.new
      end

      it "should have summary set to #{s='<p>Summary description goes here</p>'}" do
        @blog_post.summary.should == s
      end
      it "should have body set to nil" do
        @blog_post.body.should == nil
      end
      it "should have date set to tomorrow" do
        @blog_post.date.should == Date.new(2011,1,2)
      end
    end

    describe "when a saved record (with body set to nil) is initialized" do
      before do
        @blog_post = BlogPost.create!(:title => 'Something')
        @blog_post.update_attributes!(:body => nil, :date => nil)
      end

      it "should not change body" do
        @blog_post.body.should be_nil
      end
      it "should not change date" do
        @blog_post.date.should be_nil
      end
    end

    describe "when a new record is initialized with summary 'This talks about the stuff'" do
      before do
        @blog_post = BlogPost.new(:summary => 'This talks about the stuff')
      end

      it 'sets body accordingly' do
        @blog_post.body.should == @blog_post.summary
      end
    end

    describe "when a *saved* record is initialized with summary 'This talks about the stuff'" do
      before do
        @blog_post = BlogPost.create!(:title => 'Something')
        @blog_post.update_attributes!(:body => nil, :summary => 'Old summary')
        @blog_post = BlogPost.new(:summary => 'This talks about the stuff')
      end

      it 'sets body accordingly' do
        @blog_post.body.should == @blog_post.summary
      end
    end

    describe 'friendly_id' do
      [['my COOL tItLe!', 'my-cool-title'],
       ['你好',           'ni-hao'],
       ['Łódź, Poland',   'lodz-poland'],
      ].each do |title, slug|
        it "converts title '#{title}' to #{slug}" do
          @blog_post = BlogPost.create!(:title => title)
          @blog_post.friendly_id.should == slug
        end
      end

      it "when I create 2 posts with default title 'New Post', the url for the 2nd post gets a sequence ('new-post--2')" do
        BlogPost.destroy_all
        @blog_post_1 = BlogPost.create!()
        @blog_post_1.cached_slug.should == 'new-post'
        @blog_post_2 = BlogPost.create!()
        @blog_post_2.cached_slug.should == 'new-post--2'
      end

      it "when I change the url/slug, it should still be accessable by the old as well as the new" do
        BlogPost.destroy_all
        @blog_post = BlogPost.create!()
        @blog_post.cached_slug.should == 'new-post'

        @blog_post.update_attributes!(:url => 'a')
        @blog_post.cached_slug.should == 'a'

        @blog_post.should == BlogPost.find('new-post')
        @blog_post.should == BlogPost.find('a')
      end

      # Updates slug automatically because custom url has not been set
      it "when I set title to 'A', then change title to 'B', url and cached_slug ends up being 'b'" do
        BlogPost.destroy_all
        @blog_post = BlogPost.create!(:title => 'A')
        @blog_post.url        .should == 'a'
        @blog_post.cached_slug.should == 'a'
        @blog_post.should_not be_custom_url

        @blog_post.update_attributes!(:title => 'B')
        @blog_post.url        .should == 'b'
        @blog_post.cached_slug.should == 'b'
        @blog_post.should_not be_custom_url
      end

      # Setting custom url disables automatic slug generation
      it "when I set url to 'a', then change title to 'B', cached_slug remains at the custom url, 'a'" do
        BlogPost.destroy_all
        @blog_post = BlogPost.create!()
        @blog_post.url        .should == 'new-post'
        @blog_post.cached_slug.should == 'new-post'
        @blog_post.should_not be_custom_url

        @blog_post.update_attributes!(:url => 'a')
        @blog_post.url        .should == 'a'
        @blog_post.cached_slug.should == 'a'
        @blog_post.should be_custom_url

        @blog_post.update_attributes!(:title => 'B')
        @blog_post.url        .should == 'a'
        @blog_post.cached_slug.should == 'a'
      end

      1.times do
      it "when I set url to invalid url value '#{s='Invalid as URL'}', it converts it to something valid" do
        BlogPost.destroy_all
        @blog_post = BlogPost.create!()
        @blog_post.url        .should == 'new-post'
        @blog_post.cached_slug.should == 'new-post'
        @blog_post.should == BlogPost.find('new-post')

        @blog_post.update_attributes!(:url => s)
        @blog_post.read_attribute(:url).should == 'invalid-as-url'
        @blog_post.url.                 should == 'invalid-as-url'
        @blog_post.cached_slug.         should == 'invalid-as-url'
        @blog_post.should == BlogPost.find('invalid-as-url')

        @blog_post.update_attributes!(:title => 'B')
        @blog_post.url        .should == 'invalid-as-url'
        @blog_post.cached_slug.should == 'invalid-as-url'
      end
      end

      1.times do
      it "when I set url to invalid url value '#{s='<blink>cool</blink>'}', it strips out the tags" do
        BlogPost.destroy_all
        @blog_post = BlogPost.create!()
        @blog_post.url        .should == 'new-post'
        @blog_post.cached_slug.should == 'new-post'
        @blog_post.should == BlogPost.find('new-post')

        @blog_post.update_attributes!(:url => s)
        @blog_post.read_attribute(:url).should == 'cool'
        @blog_post.url.                 should == 'cool'
        @blog_post.cached_slug.         should == 'cool'
        @blog_post.should == BlogPost.find('cool')

        @blog_post.update_attributes!(:title => 'B')
        @blog_post.url        .should == 'cool'
        @blog_post.cached_slug.should == 'cool'
      end
      end

      [
        [nil]*2,
        ['']*2,
        ['<br>', '']
      ].each do |s, normalized_s|
        it "when I set url to #{s.inspect}, it goes back to creating the slug based on title" do
          BlogPost.destroy_all
          @blog_post = BlogPost.create!(:title => 'My title', :url => 'my-url')
          @blog_post.url        .should == 'my-url'
          @blog_post.cached_slug.should == 'my-url'
          @blog_post.should be_custom_url

          @blog_post.update_attributes!(:url => s)
          @blog_post.read_attribute(:url).should == normalized_s
          @blog_post.url        .should == 'my-title'
          @blog_post.cached_slug.should == 'my-title'
          @blog_post.should_not be_custom_url
        end
      end
    end

    describe "published?" do
      it 'when date is yesterday, it will report itself as being unpublished' do
        @blog_post = BlogPost.create!(:date => Date.new(2011,12,31))
        @blog_post.should_not be_published
      end

      it 'when date is today, it will report itself as being published' do
        @blog_post = BlogPost.create!(:date => Date.new(2011,1,1))
        @blog_post.should be_published
      end

    end

    describe "normalization" do
      [:title, :summary, :body].each do |attr_name|
        it { should normalize_attribute(attr_name).from('  Something  ').to('Something') }
        it { should normalize_attribute(attr_name).from('').to(nil) }
      end
    end

    describe "validation" do
     #describe "when it has the same url as another page" do
     #  it "should fail validation" do
     #    page1 = BlogPost.create(url: '/page1')
     #    page2 = BlogPost.create(url: '/page1')
     #    page2.should_not be_valid
     #    page2.errors[:url].should be_present
     #  end
     #end
    end

    describe 'to_s' do
      it 'should return the title' do
        blog_post = BlogPost.new(:title => 'Home')
        blog_post.to_s.should match(/Home/)
      end
    end
  end
end
