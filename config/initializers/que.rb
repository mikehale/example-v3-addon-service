Que.connection = DB
Que.logger = Logger.new($stdout)

module QueInstrumentor
  module ClassMethods
    def execute(*args)
      if args&.first == :lock_job
        Pliny::Metrics.measure "que.lock_sec" do
          super
        end
      else
        super
      end
    end
  end

  def self.prepended(base)
    class << base
      prepend ClassMethods
    end
  end
end

Que.send(:prepend, QueInstrumentor)

ENV['QUE_HARD_LOCK_INTERVAL'] ||= Config.que_hard_lock_interval.to_s
