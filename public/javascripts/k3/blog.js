K3_Blog = {
}

k3_blog_blog_post = {
  updatePage: function(object_name, object_id, object, source_element) {
    K3_InlineEditor.updatePageFromObject(object_name, object_id, object, source_element)

    // TODO: render_cell('k3/blog/blog_posts', :published_status, :blog_post => blog_post)
    // console.log(object.date)

    // TODO: only if page title was originally set to @page.title. Perhaps we should set some JS variable to indicate which object/attribute the page title was taken form?
    $('title').html(object.title)
    $('meta[name=description]').attr('content', object.meta_description);
    $('meta[name=keywords]').   attr('content', object.meta_keywords);
  }
}
