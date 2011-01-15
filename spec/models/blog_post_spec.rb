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

    describe "validation" do
    end

    describe "normalization" do
      [:title, :summary, :body].each do |attr_name|
        it { should normalize_attribute(attr_name).from('  Something  ').to('Something') }
        it { should normalize_attribute(attr_name).from('').to(nil) }
      end
    end

    describe 'to_s' do
      it 'should return the title' do
        blog_post = BlogPost.new(:title => 'Home')
        blog_post.to_s.should match(/Home/)
      end
    end
  end
end
