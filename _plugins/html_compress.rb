require 'html_press'

module Jekyll
  module Compressor
    def exclude?(dest, dest_path)
      res = false
      file_name = dest_path.slice(dest.length+1..dest_path.length)
      exclude = @site.config['html-compress'] && @site.config['html-compress']['exclude']
      if exclude
        if exclude.is_a? String
          exclude = [exclude]
        end
        exclude.each do |e|
          if e == file_name || File.fnmatch(e, file_name)
            res = true
            break
          end
        end
      end
      res
    end

    def output_file(dest, content)
      FileUtils.mkdir_p(File.dirname(dest))
      File.open(dest, 'w') do |f|
        f.write(content)
      end
    end

    def output_html(path, content)
      if @site.config['html-compress'] && !@site.config['html-compress']['debug']
        output_file(path, HtmlPress.press(content, {}))
      else
        output_file(path, content)
      end
    end
  end

  class Post
    include Compressor

    def write(dest)
      dest_path = destination(dest)
      output_html(dest_path, output)
    end
  end

  class Page
    include Compressor

    def write(dest)
      dest_path = destination(dest)
      if exclude?(dest, dest_path)
        output_file(dest_path, output)
      else
        output_html(dest_path, output)
      end
    end
  end

  class StaticFile
    include Compressor

    def copy_file(path, dest_path)
      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.cp(path, dest_path)
    end

    def write(dest)
      dest_path = destination(dest)

      return false if File.exist?(dest_path) and !modified?
      @@mtimes[path] = mtime

      copy_file(path, dest_path)

      true
    end
  end
end
