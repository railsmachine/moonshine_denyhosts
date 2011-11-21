module Moonshine
  module Denyhosts
    def denyhosts(sent_options = {})
      default_options = {
        :allow => [],
        :deny => []
      }

      allow_list = default_options[:allow] + configuration[:denyhosts][:allow]
      deny_list  = default_options[:deny]  + configuration[:denyhosts][:deny]

      options = HashWithIndifferentAccess.new(default_options.merge(configuration[:denyhosts]))
      
      options[:allow] = allow_list
      options[:deny]  = deny_list

      package 'denyhosts', :ensure => :installed
      service 'denyhosts', :ensure => :running

      %w(allow deny).each do |k|
        file "/etc/hosts.#{k}",
          :ensure  => :present,
          :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', "hosts.#{k}.erb"), binding)
        end
      end
    end
  end
end
