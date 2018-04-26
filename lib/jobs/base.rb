module Jobs
  class Base < Que::Job
    def self.count
      QueJob.where(job_class: self.to_s).count
    end

    def self.log(data={}, &block)
      defaults = Hash[
        self.to_s.underscore.split("/").map{ |e| [e, true] }
      ]
      Pliny.log(defaults.merge(data), &block)
    end

    def log(data={}, &block)
      self.class.log(data, &block)
    end
  end
end
