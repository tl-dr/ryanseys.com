module Jekyll
  module MyFilters
    def file_date(input)
      File.mtime(input) or DateTime.now
    end
  end
end

Liquid::Template.register_filter(Jekyll::MyFilters)
