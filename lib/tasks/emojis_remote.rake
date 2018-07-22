# frozen_string_literal: true https://github.com/theboss/mastodon/blob/theboss.tech/lib/tasks/emojis_remote.rake

namespace :emojis_remote do
    desc 'Copy all remote emojis'
    task copy_all: :environment do
      local_emojis = CustomEmoji.select(:shortcode).where(domain: nil)
  
      saved_shortcodes = []
  
      CustomEmoji.where.not(domain: nil, shortcode: local_emojis).find_each do |e|
        unless saved_shortcodes.include? e.shortcode
          CustomEmoji.new(domain: nil, shortcode: e.shortcode, image: e.image).save!
          puts "Emoji saved. shortcode=#{e.shortcode}, domain=#{e.domain}, image=#{e.image}"
          saved_shortcodes << e.shortcode
        end
      end
    end
end