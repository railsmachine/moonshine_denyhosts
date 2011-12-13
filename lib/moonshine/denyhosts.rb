module Moonshine
  module Denyhosts
    def denyhosts(options = {})
      allow_list = options[:allow] || []
      deny_list  = options[:deny] || []

      package 'denyhosts', :ensure => :installed
      service 'denyhosts', :ensure => :running, :require => package('denyhosts')

      %w(allow deny).each do |k|
        file "/etc/hosts.#{k}",
          :ensure  => :present,
          :notify => service('denyhosts'),
          :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', "hosts.#{k}.erb"), binding)
      end
    end
  end
end
