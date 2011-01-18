
module K3
  module Blog
    class BlogPost < ActiveRecord::Base
      set_table_name 'k3_blog_blog_posts'

      # There are multiple fields/methods involved for the slug/friendly_id. Don't be confused:
      # * The cached_slug attribute is used when we do BlogPost.find('my-slug')
      # * The url attribute is never (!!!) "used", except as input to friendly_id, which will then process it and *convert* it to a valid url, as necessary. The result of that, of course, is available in cached_slug.
      # * The url= setter is left intact, but the url getter is overridden to return cached_slug, because we essentially never want to accidentally use a user-supplied value (read_attribute(:url)) instead of the processed value.
      # The url attribute will remain nil unless it is ever manually set by the user.
      # As long as custom_url? is false (the url attribute is nil), it will automatically create a slug based on title any time the title is updated.
      # As soon as you set the url manually, however, it will stop doing that.
      has_friendly_id :title_or_custom_url, :use_slug => true

      belongs_to :author, :class_name => 'User'

      normalize_attributes :title, :summary, :body, :with => [:strip, :blank]

      validates :title, :presence => true
      #validates :url, :uniqueness => true, :allow_nil => true, :allow_blank => true

      after_initialize :set_defaults
      def set_defaults
        # Copy summary to body
        default_summary = '<p>Summary description goes here</p>'
        self.body = self.attributes['summary']                   if self.attributes['body'].nil? && self.attributes['summary'].present? && self.attributes['summary'] != default_summary

        if new_record?
          self.title   = 'New Post'                             if self.attributes['title'].nil?
          self.summary = default_summary                        if self.attributes['summary'].nil?
          self.date = Date.tomorrow                             if self.attributes['date'].nil?
        end
      end

      def to_s
        title
      end

      def url
        cached_slug
      end
      def custom_url?
        read_attribute(:url).present?
      end
      def title_or_custom_url
        custom_url? ? read_attribute(:url) : title
      end
      def normalize_friendly_id(text)
        # This uses stringex
        text.to_url
      end

      def published?
        date and Time.zone.now >= date.beginning_of_day
      end
    end
  end
end
