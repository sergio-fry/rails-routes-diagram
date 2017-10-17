module Diagram
  class Route
    def initialize(path)
      @path = path
    end

    def to_s
      return if path == '/*path'
      <<-TXT
' #{@path}
#{parent_link}
class #{klass_name} {
#{params.map { |p| "  Integer #{p}"}.join("\n") }
}
      TXT
    end

    def params
      @path.scan(/:[a-z_]+/)
    end

    def path
      @path
    end

    def parent_path
      path.split('/')[0..-2].join('/')
    end

    def parent
      return if parent_path.nil?
      Route.new parent_path
    end

    def klass_name
      camelize(@path.gsub(/:/, '').split("/").join('_')) + 'Route'
    end

    private

    def additional_path
      return if parent.nil?
      path.sub(parent_path, '')
    end

    def parent_link
      return if parent.nil?
      "#{klass_name} \"+#{additional_path}\" --* #{parent.klass_name}"
    end

    def camelize(s)
      s.split('_').collect(&:capitalize).join
    end
  end
end
