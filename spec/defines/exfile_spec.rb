require 'spec_helper'

describe 'exfile', :type => :define do
  context 'absolute file creation with title' do
    let(:title) { '/tmp/test.txt' }
    it { is_expected.to contain_file('/tmp/test.txt').with({
      :path => '/tmp/test.txt',
    }) }
  end
  context 'absolute file creation with path' do
    let(:title) { 'test.txt' }
    let(:params) {{
      :path => '/tmp/test/test.txt',
    }}
    it { is_expected.to contain_file('test.txt').with({
      :path => '/tmp/test/test.txt',
    }) }
  end
  context 'absolute file creation with basedir set' do
    let(:title) { '/tmp/test.txt' }
    let(:params) {{ :basedir => '/xyz' }}
    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /basedir can only be used if no absolute path is given/
    end
  end
  context 'relative file creation' do
    let(:title) { 'test.txt' }
    let(:params) {{ :basedir => '/tmp' }}
    it { is_expected.to contain_file('test.txt').with({
      :path => '/tmp/test.txt',
    }) }
  end
  context 'relative file creation with path' do
    let(:title) { 'test.txt' }
    let(:params) {{
      :basedir => '/tmp',
      :path => 'test/test.txt',
    }}
    it { is_expected.to contain_file('test.txt').with({
      :path => '/tmp/test/test.txt',
    }) }
  end
  context 'content_template erb' do
    let(:title) { '/tmp/test.txt' }
    let(:params) {{
      :content_type => 'erb',
      :content_template => 'exfile/hashofkeyvalue.erb',
      :content => {
        'key1' => 'value1',
      }
    }}
    it { is_expected.to contain_file('/tmp/test.txt').with({
      :path => '/tmp/test.txt',
      :content => "key1 = value1\n",
    }) }
  end
  context 'content_template inline_epp' do
    let(:title) { '/tmp/test.txt' }
    let(:params) {{
      :content_type => 'inline_epp',
      :content_template => "<% $content.each |$key, $value| { -%>\n<%= $key %><%= pick(getvar('merger'), ' = ') %><%= $value %>\n<% } -%>",
      :additional_parameters => {
        'merger' => ' => ',
      },
      :content => {
        'key1' => 'value1',
      }
    }}
    it { is_expected.to contain_file('/tmp/test.txt').with({
      :path => '/tmp/test.txt',
      :content => "key1 => value1\n",
    }) }
  end
end
