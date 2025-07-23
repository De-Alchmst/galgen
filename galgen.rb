#!/usr/bin/env ruby

# HANDLE .ENV #

env = File.read(File.join(File.dirname(__FILE__), ".env")).strip
abort("invalid .env") if env.empty?

key, path = env.split(/\n/)[0].split('=')
abort("invalid .env") unless key == "GALLERY" and path

# PREPARE TEMPLATE #

$img_regex = /.*(?:png|jpg|jpeg|gif|svg|bmp|apng|webp)/i

def template(css_path, title, desc, links, images)
  "
<!DOCTYPE html>
<html>
  <head>
    <title>#{title}</title>
    <meta charset='UTF-8'>
    <link rel='stylesheet' href='#{css_path}/style.css'>
  </head>
  <body>
    #{
      unless desc.empty?
        "
        <header>
          #{desc}
        </header>
        "
      end
    }

    <nav>
      <ul>
        <li><a href='..'>../</a></li>
        #{
          links.map {|l|
            "<li><a href='#{l}'>#{l}/</a></li>"
          }.join "\n"
        }
      <ul>
    </nav>

    #{
      unless images.empty?
        "
        <main>
        #{
          images.map {|i|
            "<a href='#{i}'><img src='#{i}' alt='#{i}'></a>"
          }.join "\n"
        }
        </main>
        "
      end
    }
  </body>
</html>
  "
end

# HANDLE RECURSIVELY #

def handle_dir(path, css_path)
  puts path
  title = File.split(path)[1]
  desc = ""
  links = []
  images = []

  if File.exist? File.join(path, "style.css")
    css_path = File.join(css_path, File.split(path)[1])
  end

  Dir.each_child(path) {|c|
    full_path = File.join(path, c)
    if File.directory? full_path
      links.append c
      handle_dir full_path, File.join('..', css_path)

    elsif c == 'desc.html'
      desc = File.read full_path

    elsif c.match? $img_regex
      images.append c
    end
  }

  File.write(File.join(path, 'index.html'),
             template(css_path, title, desc, links, images))
end

handle_dir path, '..'

