module Salt
  module Publishable
    def write(path, context = false)
      directory_path = output_path(path)
      contents = context ? render(@contents, {this: self}.merge(context)) : @contents

      FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)

      File.open(File.join(directory_path, "#{@filename}.#{@extension}"), 'w') do |file|
        file.write(contents)
      end
    end

    def render(contents, context = {}, use_layout = true)
      context[:site] ||= @site

      begin
        output = Erubis::Eruby.new(contents).evaluate(context) { contents }
      rescue SyntaxError => e
        raise "Syntax error in #{path.gsub(site.source_paths[:root], '')}"
      end

      if @layout && @site.templates[@layout] && use_layout
        output = @site.templates[@layout].render(output, context) 
      end

      output
    end
  end
end