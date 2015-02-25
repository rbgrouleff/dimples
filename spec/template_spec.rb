require 'dimples'

describe 'A template', publishing: true do

  subject { @site.templates['default'] }
    
  it 'should render' do
    expected = <<EXPECTED
<!DOCTYPE html>
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>My site</title>
</head>
<body>
Hello
</body>
</html>
EXPECTED

    expect(subject.render({}, 'Hello')).to eql(expected.rstrip)
  end

end