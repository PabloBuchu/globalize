module Globalize
  module ActiveRecord
    autoload :ActMacro,        'globalize/active_record/act_macro'
    autoload :Adapter,         'globalize/active_record/adapter'
    autoload :Attributes,      'globalize/active_record/attributes'
    autoload :ClassMethods,    'globalize/active_record/class_methods'
    autoload :Exceptions,      'globalize/active_record/exceptions'
    autoload :InstanceMethods, 'globalize/active_record/instance_methods'
    autoload :Migration,       'globalize/active_record/migration'
    autoload :Translation,     'globalize/active_record/translation'
    autoload :QueryMethods,    'globalize/active_record/query_methods'

    class << self
      def define_accessors(klass, attr_names)
        attr_names.each do |attr_name|
          klass.send :define_method, attr_name, lambda { |*arg|
                                     locale = arg.first
                                     globalize.fetch locale || self.class.locale, attr_name
                                   }
          klass.send :define_method, "#{attr_name}=", lambda {|val|
                                     attribute_will_change!(attr_name)
                                     globalize.stash self.class.locale, attr_name, val
                                   }
          klass.send :define_method, "#{attr_name}_set", lambda {|val, locale|
                                     globalize.stash locale || self.class.locale, attr_name, val
                                   }
          klass.send :define_method, "#{attr_name}_changed?", lambda {
                                     attribute_changed? attr_name
                                   }
          klass.send :define_method, "#{attr_name}_was", lambda {
                                     changed_attributes[attr_name] if changed_attributes.include?(attr_name)
                                   }
        end
      end
    end
  end
end
