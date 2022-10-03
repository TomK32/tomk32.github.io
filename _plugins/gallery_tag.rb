require 'pp'
module Jekyll
  class GalleryImageTag < Liquid::Tag

    def initialize(directory, input, text)
      super
      @directory, @image, @text = input.split('|')
    end

    def render(context)
      "
<span class='gallery image'>
  <a href='/assets/#{@directory}/#{@image}'>
    <img src='/assets/#{@directory}/thumbnails/#{@image}' alt='#{@text}' />
    <span class='text'>#{@text}</span>
  </a>
</span>
"
    end
  end
end

Liquid::Template.register_tag('gallery_image', Jekyll::GalleryImageTag)

