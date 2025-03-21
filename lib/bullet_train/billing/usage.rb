require "bullet_train/billing/usage/version"
require "bullet_train/billing/usage/engine"

require "verbs"

module BulletTrain
  module Billing
    module Usage
      def self.default_for(klass, method, default_value)
        klass.respond_to?(method) ? klass.send(method) || default_value : default_value
      end

      mattr_accessor :parent_class, default: default_for(BulletTrain, :parent_class, "Team")
      mattr_accessor :base_class, default: default_for(BulletTrain, :base_class, "ApplicationRecord")

      def self.parent_association
        parent_class.underscore.tr("/", "_").to_sym
      end

      def self.parent_resource
        parent_class.underscore.pluralize.to_sym
      end

      def self.parent_class_specified?
        parent_class != "Team"
      end

      def self.current_parent_method
        "current_#{parent_association}"
      end

      def self.parent_association_id
        "#{parent_association}_id".to_sym
      end
    end
  end
end
