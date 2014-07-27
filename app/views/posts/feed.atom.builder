atom_feed :language => 'fr-FR' do |feed|
  feed.title @title
  feed.updated @updated

  @post.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url post_url(item)
      entry.title item.title
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
    end
  end
end