module Jekyll
  class EpisodeTag < Liquid::Tag
    def initialize(tag_name, video_url, tokens)
      super
    end

    def render(context)
    end
  end
end

Liquid::Template.register_tag('episode', Jekyll::EpisodeTag)