require 'active_record'
require 'attribute_normalizer'

module K3
  module Blog
    class BlogPost < ActiveRecord::Base
      set_table_name 'k3_blog_posts'

      belongs_to :author, :class_name => 'User'

      normalize_attributes :title, :summary, :body, :url, :with => [:strip, :blank]

      validates :title, :presence => true

      after_initialize :set_defaults
      def set_defaults
        # Copy summary to body
        self.body = self.attributes['summary'] if self.attributes['body'].nil? && self.attributes['summary']

        if new_record?
          self.title   = 'New Post'                             if self.attributes['title'].nil?
          self.summary = '<p>Summary description goes here</p>' if self.attributes['summary'].nil?
          self.date = Date.tomorrow                             if self.attributes['date'].nil?
        end
      end

      def to_s
        title
      end

      def inspect
        "BlogPost #{id} (#{title})"
      end

      def published?
        Time.zone.now >= date.beginning_of_day
      end
    end
  end
end
