# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'helper'

describe 'Post' do
  before do
    test_site.scan_templates
    test_site.scan_pages
    test_site.scan_posts
  end

  subject do
    filename = '2015-01-01-a-post.markdown'
    path = File.join(test_site.source_paths[:posts], filename)
    Dimples::Post.new(test_site, path)
  end

  it 'parses its YAML frontmatter' do
    subject.title.must_equal('My first post')
    subject.categories.sort.must_equal(%w[green red])
  end

  it 'renders its contents' do
    expected_output = read_fixture('posts/2015-01-01-a-post')
    subject.render.must_equal(expected_output)
  end

  it 'publishes to a file' do
    path = subject.output_path(test_site.output_paths[:posts])

    subject.write(path)
    File.exist?(path).must_equal(true)
  end
end
