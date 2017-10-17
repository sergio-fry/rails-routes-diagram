#!/usr/bin/env ruby

require_relative './lib/diagram/diagram'

include Diagram

data = File.read(ARGV[0])
routes = {}
actions = []

def add_new_path(routes, path)
  routes[path.path] ||= path

  add_new_path(routes, path.parent) unless path.parent_path == ''
end

require 'pry'

data.split("\n").each do |line|
  m = line.match(/^.+(GET|POST|PATCH|PUT|DELETE)(.+)$/)
  next if m.nil?
  line = m[1] + ' ' + m[2]

  method, path, controller = line.split
  path = path.gsub(/\(\.:format\)/, '')

  add_new_path(routes, Route.new(path))

  actions << Action.new(method, path, controller)
end

controllers = []
actions.group_by(&:base_klass_name).each do |base_klass_name, actions|
  controllers << Controller.new(base_klass_name, actions)
end

File.open('./schema.pu', 'w') do |out|
  out.write <<-UML
@startuml
' #{Time.now}
#{controllers.map(&:to_s).join}
#{routes.values.map(&:to_s).join}
@enduml
  UML
end
