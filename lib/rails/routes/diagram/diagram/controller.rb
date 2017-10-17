module Diagram
  class Controller
    def initialize(name, actions)
      @name = name
      @actions = actions
    end

    def to_s
      <<-TXT
' #{klass_name}
#{parent_link}
class #{klass_name} {
  #{methods}
}
      TXT
    end

    private

    def klass_name
      @actions[0].base_klass_name
    end

    def parent_link
      links = []

      @actions.group_by { |ac| ac.route.klass_name }.each do |route_klass_name, actns|
        links << "#{klass_name} .. #{route_klass_name}"
      end

      links.join("\n")
    end

    def methods
      @actions.map do |action|
        "+#{action.action}()"
      end.uniq.join("\n")
    end
  end
end
