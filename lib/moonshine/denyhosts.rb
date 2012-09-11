module Moonshine
  module Denyhosts
    def denyhosts(options = {})
      package 'denyhosts', :ensure => :installed
      service 'denyhosts', :ensure => :running, :require => package('denyhosts')

      %w(allow deny).each do |k|
        entries = options[k.to_sym] || []
        if entries.any?
          file "/etc/hosts.#{k}",
            :ensure  => :present,
            :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', "hosts.#{k}.erb"), binding)
        end
      end
    end
  end
end
