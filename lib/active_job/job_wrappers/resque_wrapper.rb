require 'resque'

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/string/inflections'


module ActiveJob
  module JobWrappers
    class ResqueWrapper
      class << self
        def wrap(job, args)
          [ new(job), *args.prepend(job) ]
        end

        def perform(*args)
          unwrapped_job = args.first.constantize
          
          if args.many?
            unwrapped_job.perform *args.from(1)
          else
            unwrapped_job.perform
          end
        end
      end


      def initialize(job)
        @queue = job.queue_name
      end
      
      def to_s
        self.class.to_s
      end
    end
  end
end