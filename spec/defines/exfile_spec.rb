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
      :basedir => '/xyz',
      :path => '/tmp/test/test.txt',
    }}
    it { is_expected.to contain_file('test.txt').with({
      :path => '/tmp/test/test.txt',
    }) }
  end
  context 'absolute file creation with basedir set' do
    let(:title) { '/tmp/test.txt' }
    let(:params) {{ :basedir => '/xyz' }}
    it { is_expected.to contain_file('/tmp/test.txt').with({
      :path => '/tmp/test.txt',
    }) }
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
  context 'contenttemplate' do
    let(:title) { '/tmp/test.txt' }
    let(:params) {{
      :contenttemplate => 'exfile/hashofkeyvalue.erb',
      :content => {
        'key1' => 'value1',
      }
    }}
    it { is_expected.to contain_file('/tmp/test.txt').with({
      :path => '/tmp/test.txt',
      :content => "key1 = value1\n",
    }) }
  end
end
