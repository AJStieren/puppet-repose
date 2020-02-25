require 'spec_helper'
describe 'repose::filter::scripting', :type => :define do
  let :pre_condition do
    'include repose'
  end
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'default parameters' do
      let(:title) { 'default' }
      it {
        should raise_error(Puppet::Error,/script_lang is a required parameter/)
      }
    end

    context 'default parameters did not provide mod_script' do
      let(:title) { 'default' }
      let(:params) { {
        :script_lang => 'groovy'
      } }
      it {
        should raise_error(Puppet::Error,/mod_script is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/scripting.cfg.xml').with_ensure(
          'absent')
      }
    end
  end
end
