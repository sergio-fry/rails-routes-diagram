module Diagram
  class Action
    def initialize(method, path, controller)
      @method, @path, @controller = method, path, controller
    end

    def to_s
      return if path == '/*path'
      <<-TXT
' #{@method} #{@path} #{@controller}
#{parent_link}
class #{klass_name} {
  +#{action}()
}
      TXT
    end

    def base_klass_name
      camelize @controller.split("/")[-1].split('#')[0]
    end

    def action
      camelize @controller.split("/")[-1].split('#')[1]
    end

    def route
      Route.new path
    end

    def method
      @method.downcase
    end

    private

    def parent_link
      "#{klass_name} .. #{route.klass_name}: #{method}"
    end

    def path
      @path
    end

    def klass_name
      namespace + base_klass_name
    end

    def namespace
      camelize @controller.split("/")[0..-2].join('_')
    end

    def camelize(s)
      s.split('_').collect(&:capitalize).join
    end
  end
end
