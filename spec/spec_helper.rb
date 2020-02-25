require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'

RSpec.configure do |c|
  c.default_facts = {
    :debug                     => 'true',
    :concat_basedir            => '/tmp',
    :id                        => 'root',
    :kernel                    => 'x86_64',
    :path                      => '/bin:/usr/bin',
  }
end
