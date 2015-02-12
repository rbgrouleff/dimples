module Salt
  module Publishable
    def write(path, context = false)
      contents = context ? render(@contents, {this: self}.merge(context)) : @contents

      publish_path = output_file_path(path)
      parent_path = File.dirname(publish_path)

      FileUtils.mkdir_p(parent_path) unless Dir.exist?(parent_path)

      File.open(publish_path, 'w') do |file|
        file.write(contents)
      end
    end

    def render(body, context = {}, use_layout = true)
      context[:site] ||= @site

      begin
        output = Erubis::Eruby.new(@contents).evaluate(context) { body }
      rescue SyntaxError => e
        raise "Syntax error in #{path.gsub(site.source_paths[:root], '')}"
      end

      if use_layout && @layout && @site.templates[@layout]
        output = @site.templates[@layout].render(output, context) 
      end

      output
    end
  end
end