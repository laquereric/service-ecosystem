# frozen_string_literal: true

module LlmMemory
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
